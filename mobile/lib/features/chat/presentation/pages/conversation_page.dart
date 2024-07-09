import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/app/app.dart';
import 'package:sns_deepfake/features/chat/chat.dart';
import 'package:sns_deepfake/features/chat/presentation/widgets/empty_conversation_card.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../config/configs.dart';
import '../widgets/conversation_avatar.dart';
import '../widgets/message_card.dart';

class ConversationPage extends StatefulWidget {
  final int id;
  final Map<String, dynamic>? friendData;

  const ConversationPage({
    super.key,
    required this.id,
    this.friendData,
  });

  @override
  State<ConversationPage> createState() => ConversationPageState();
}

class ConversationPageState extends State<ConversationPage> {
  final FocusNode _fn = FocusNode();
  final TextEditingController _controller = TextEditingController();

  late final ScrollController _scrollController = ScrollController();
  bool _loadingMore = false;
  bool _hasReachedMax = false;

  final ValueNotifier<bool> _focusing = ValueNotifier(false);
  final ValueNotifier<bool> _pickEmoji = ValueNotifier(false);
  final ValueNotifier<MessageModel?> _replying = ValueNotifier(null);

  Timer? _debounce;
  Timer? _endTyping;

  int _currentPage = 1;
  late int myId;
  ConversationModel? conversation;
  late int conversationId;

  late SocketBloc _socketBloc;
  late final Map<int, String> memberAvatars;
  late final Map<int, String> memberNames;

  @override
  void initState() {
    _socketBloc = context.read<SocketBloc>();
    myId = context.read<AppBloc>().state.user!.id!;
    conversationId = widget.id;

    if (conversationId != -1) {
      _socketBloc.add(JoinConversation(conversationId));
      _initDeclare();
      context.read<ConversationDetailsBloc>().add(
            GetConversationDetails(
              page: _currentPage,
              size: AppStrings.messagePageSize,
              id: conversationId,
            ),
          );
    }

    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    if (_endTyping?.isActive ?? false) {
      _endTyping?.cancel();
      _socketBloc.add(TypingSubmit(
        conversationId: conversation!.id,
        members: conversation!.members.map((e) => e.id).toList(),
        isTyping: false,
      ));
    }
    if (conversationId != -1) {
      _socketBloc.add(LeaveConversation(conversationId));
    }

    _debounce?.cancel();
    _endTyping?.cancel();
    _scrollController.dispose();
    _fn.dispose();
    super.dispose();
  }

  void _handleTypeMessage(value) {
    if (conversationId == -1) return;

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Durations.medium1, () {
      _focusing.value = _fn.hasFocus;

      if (_endTyping?.isActive ?? false || _controller.text.isEmpty) {
        _endTyping?.cancel();
      }
      _socketBloc.add(TypingSubmit(
        conversationId: conversation!.id,
        members: conversation!.members.map((e) => e.id).toList(),
        isTyping: _controller.text.isNotEmpty,
      ));

      // Sau 10s tự động hủy typing
      _endTyping = Timer(const Duration(seconds: 10), () {
        _socketBloc.add(TypingSubmit(
          conversationId: conversation!.id,
          members: conversation!.members.map((e) => e.id).toList(),
          isTyping: false,
        ));
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore &&
        !_hasReachedMax) {
      _loadingMore = true;

      context.read<ConversationDetailsBloc>().add(
            LoadMoreConversationDetails(
              page: ++_currentPage,
              size: AppStrings.messagePageSize,
              id: conversationId,
            ),
          );
    }
  }

  void _handleSendMessage([List<String> attachments = const []]) {
    if (_controller.text.isEmpty && attachments.isEmpty) return;

    if (conversationId == -1) {
      context.read<MessageBloc>().add(SendFirstMessageSubmit(
            memberIds: [widget.friendData!["id"]],
            type: attachments.isNotEmpty ? MessageType.media : MessageType.text,
            message: _controller.text,
            onSuccess: handleChangeEmptyConversation,
            attachments: attachments,
            replyId: _replying.value?.id,
          ));
    } else {
      context.read<MessageBloc>().add(SendMessageSubmit(
            conversationId: conversation!.id,
            type: attachments.isNotEmpty ? MessageType.media : MessageType.text,
            message: _controller.text,
            attachments: attachments,
            replyId: _replying.value?.id,
          ));
    }

    _fn.unfocus();
    _replying.value = null;
    _pickEmoji.value = false;
    _controller.clear();
  }

  void _initDeclare() {
    conversation ??=
        (context.read<MyConversationsBloc>().state as SuccessfulState)
            .conversations
            .firstWhere((e) => e.id == conversationId);

    memberAvatars = {
      for (var member in conversation!.members) member.id: member.avatar ?? ""
    };

    memberNames = {
      for (var member in conversation!.members)
        member.id: member.username ?? member.email
    };

    if (conversation != null &&
        conversation!.messages.isNotEmpty &&
        !conversation!.messages.first.seenIds.contains(myId)) {
      context.read<ConversationDetailsBloc>().add(
            SeenConversation(conversationId),
          );
    }
  }

  void handleChangeEmptyConversation(ConversationModel model) {
    if (conversationId != -1) return;

    setState(() {
      if (mounted) {
        conversationId = model.id;
        conversation = model;

        _socketBloc.add(JoinConversation(conversationId));

        _initDeclare();
      }
    });
  }

  Map<int, int> _mapMemberSeen(List<MessageModel> messages) {
    Map<int, int> _map = {};

    for (int idx = 0; idx < messages.length; idx++) {
      final _message = messages[idx];

      for (var e in _message.seenIds) {
        if (_map[e] == null) {
          _map[e] = idx;
        }
      }

      if (_map.length == conversation!.members.length) break;
    }

    return _map;
  }

  void _handlePick(int type) async {
    openUploadBottomSheet(
      isPickVideo: type == 1,
      context: context,
      onSelected: (url) => _handleSendMessage([url]),
    );
  }

  void _handleReply(MessageModel msg) {
    _replying.value = msg;
    _fn.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: BlocListener<MessageBloc, MessageState>(
          listener: (context, state) {
            if (state.status == MessageStatus.failure) {
              context.showError(message: state.errorMsg!);
            }
          },
          child: Column(
            /* Sử dụng flexible + spaceBetween OR expanded + align topCenter cho listview */
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Messages */
              Expanded(
                child: GestureDetector(
                  onTapUp: (_) {
                    _focusing.value = false;
                    _fn.unfocus();
                    _pickEmoji.value = false;
                  },
                  child: _buildMessages(),
                ),
              ),

              /* Other members are typing */
              BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  return state.isTyping
                      ? _overlapTyping(state.members)
                      : const SizedBox.shrink();
                },
              ),

              /*  */
              _buildInputField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return BlocBuilder<ConversationDetailsBloc, ConversationDetailsState>(
      builder: (context, state) {
        if (conversationId == -1) {
          return EmptyConversationCard(friendData: widget.friendData!);
        }

        if (state is CDInProgressState || state is CDInitialState) {
          return const Center(
            child: AppIndicator(),
          );
        } else if (state is CDSuccessfulState) {
          final length = state.messages.length;
          final memberSeen = _mapMemberSeen(state.messages);
          _loadingMore = false;
          _hasReachedMax = state.hasReachedMax;

          return Scrollbar(
            /* Container để height full vs expanded --> click để ẩn keyboard */
            child: Container(
              alignment: Alignment.topCenter,
              child: ListView.separated(
                controller: _scrollController,
                reverse: true,
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                separatorBuilder: (context, index) => const SizedBox(height: 3),
                itemCount: state.hasReachedMax ? length : length + 1,
                itemBuilder: (_, idx) => idx < state.messages.length
                    ? MessageCard(
                        onReply: _handleReply,
                        lastMessageTime: idx == length - 1
                            ? state.messages[idx].createdAt
                            : state.messages[idx + 1].createdAt,
                        message: state.messages[idx],
                        myId: myId,
                        memberSeen: memberSeen,
                        idx: idx,
                        memberAvatars: memberAvatars,
                        memberNames: memberNames,
                      )
                    : const Center(
                        child: AppIndicator(size: 32),
                      ),
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              state is CDFailureState
                  ? state.message
                  : "Some thing went wrong!",
            ),
          );
        }
      },
    );
  }

  Widget _overlapTyping(Set<int> members) {
    return AnimatedPadding(
      duration: Durations.medium1,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ...members.map((id) => Align(
                widthFactor: 0.5,
                child: AnimatedImage(
                  width: 16,
                  height: 16,
                  url: memberAvatars[id]?.fullPath ?? "",
                  isAvatar: true,
                ),
              )),
          const SizedBox(width: 8),
          Text(
            "TYPING_WITH_DOTS_TEXT".plural(members.length),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Container _buildInputField(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(3, 0, 3, 8),
      child: Column(
        children: [
          /* Replying */
          ValueListenableBuilder(
            valueListenable: _replying,
            builder: (context, value, child) => _buildReplyMessage(value),
          ),

/*  */
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: _focusing,
                builder: (context, value, child) => value
                    ? InkWell(
                        onTap: () => _focusing.value = false,
                        borderRadius: BorderRadius.circular(1000),
                        child: Ink(
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.chevron_right),
                        ),
                      )
                    : AnimatedContainer(
                        duration: Durations.long1,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () => _handlePick(0),
                              borderRadius: BorderRadius.circular(1000),
                              child: Ink(
                                padding: const EdgeInsets.all(6),
                                child: const Icon(Icons.image),
                              ),
                            ),
                            InkWell(
                              onTap: () => _handlePick(1),
                              borderRadius: BorderRadius.circular(1000),
                              child: Ink(
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  FontAwesomeIcons.fileVideo,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              /*  */
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: context.minBackgroundColor(),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _fn,
                          // onTapOutside: (_) => _fn.unfocus(),
                          onTap: () {
                            _focusing.value = true;
                            _pickEmoji.value = false;
                          },
                          onChanged: _handleTypeMessage,
                          controller: _controller,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                EdgeInsets.fromLTRB(12.w, 8.h, 0, 8.h),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "TYPE_MESSAGE_TEXT".tr(),
                          ),
                        ),
                      ),

                      /*  */
                      InkWell(
                        onTap: () {
                          _pickEmoji.value = !_pickEmoji.value;
                          _fn.unfocus();
                        },
                        borderRadius: BorderRadius.circular(1000),
                        child: Ink(
                          padding: const EdgeInsets.all(3),
                          child: const Icon(Icons.emoji_emotions, size: 22),
                        ),
                      ),
                      SizedBox(width: 4.w),
                    ],
                  ),
                ),
              ),

              /*  */
              InkWell(
                onTap: _handleSendMessage,
                borderRadius: BorderRadius.circular(1000),
                child: Ink(
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.send, size: 22),
                ),
              ),
            ],
          ),

          /* Icon Picker */
          ValueListenableBuilder(
            valueListenable: _pickEmoji,
            builder: (context, value, child) => AnimatedSize(
              duration: Durations.short2,
              child: Container(
                width: double.infinity,
                height: !value ? 0 : 0.35.sh,
                margin: const EdgeInsets.only(top: 8),
                decoration: const BoxDecoration(
                  boxShadow: highModeShadow,
                ),
                child: !value ? const SizedBox.shrink() : _buildEmojiPicker(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReplyMessage(MessageModel? msg) {
    return AnimatedSize(
      duration: Durations.short4,
      child: Container(
        decoration: BoxDecoration(
          border: msg == null
              ? null
              : Border(top: BorderSide(color: context.minBackgroundColor())),
          boxShadow: highModeShadow,
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: msg == null
            ? const SizedBox.shrink()
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        msg.senderId == myId
                            ? Text(
                                "${"REPLYING_TO_TEXT".tr()} ${"REPLY_YOURSELF_TEXT".tr()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontSize: 11.5.sp),
                              )
                            : RichText(
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        fontSize: 11.5.sp,
                                      ),
                                  children: [
                                    TextSpan(text: "REPLYING_TO_TEXT".tr()),
                                    const TextSpan(text: " "),
                                    TextSpan(
                                      text: memberNames[msg.senderId],
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11.75.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 3),
                        Text(
                          _getReplyMessageContent(msg),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontSize: 10.5.sp),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _replying.value = null,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white12,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: const Icon(Icons.clear,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _getReplyMessageContent(MessageModel msg) {
    if (msg.type == MessageType.media) {
      return fileIsVideo(msg.attachments.first) ? "Video" : "IMAGE_TEXT".tr();
    }

    return msg.message ?? "";
  }

  Widget _buildEmojiPicker() {
    return EmojiPicker(
      textEditingController: _controller,
      onBackspacePressed: () {},
      config: Config(
        bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
        categoryViewConfig: CategoryViewConfig(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          showBackspaceButton: true,
        ),
        emojiViewConfig: EmojiViewConfig(
          loadingIndicator: const CircularProgressIndicator(),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
          columns: 8,
          emojiSizeMax: 28 * (DeviceUtils.isIOS() ? 1.20 : 1.0),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    bool isOnline(List<int> listOnline) {
      if (listOnline.isEmpty) return false;

      if (conversationId == -1) {
        return listOnline.contains(widget.friendData!["id"]);
      }

      final others =
          conversation!.members.where((member) => member.id != myId).toList();
      if (conversation!.type == ConversationType.group) {
        return others.any((user) => listOnline.contains(user.id));
      } else {
        return listOnline.contains(others.first.id);
      }
    }

    return AppBar(
      excludeHeaderSemantics: true,
      scrolledUnderElevation: 0,
      titleSpacing: 1,
      title: BlocBuilder<SocketBloc, SocketState>(
        builder: (context, state) {
          final bool _online = isOnline(state.online);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () => context.goNamed(
                    Routes.conversationSetting.name,
                    pathParameters: {
                      "id": widget.id.toString(),
                    },
                  ),
                  borderRadius: BorderRadius.circular(1000),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConversationAvatar(
                        size: kToolbarHeight - 16,
                        avatars: conversationId == -1
                            ? [
                                (widget.friendData!['avatar'] as String)
                                    .fullPath
                              ]
                            : conversation?.getConversationAvatar(myId) ?? [""],
                        isOnline: _online,
                      ),

                      /*  */
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversationId == -1
                                  ? widget.friendData!['username']
                                  : conversation?.getConversationName(myId) ??
                                      "Unknown",
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (_online)
                              Text(
                                "IS_ACTIVE_TEXT".tr(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                          ],
                        ),
                      ),

                      /*  */
                      SizedBox(width: 8.w),
                    ],
                  ),
                ),
              ),

              /*  */
              if (conversation != null)
                ZegoSendCallInvitationButton(
                  isVideoCall: true,
                  resourceID: conversation!.id.toString(),
                  callID: conversation!.id.toString(),
                  invitees: conversation!.members
                      .where((e) => e.id != myId)
                      .map((usr) => ZegoUIKitUser(
                            id: usr.id.toString(),
                            name: usr.username ?? usr.email,
                          ))
                      .toList(),
                  icon: ButtonIcon(
                    icon: const Icon(FontAwesomeIcons.video, size: 22),
                  ),
                  iconSize: const Size.fromRadius(22),
                  buttonSize: const Size.fromRadius(22),
                  margin: const EdgeInsets.only(right: 6),
                )
            ],
          );
        },
      ),
    );
  }
}
