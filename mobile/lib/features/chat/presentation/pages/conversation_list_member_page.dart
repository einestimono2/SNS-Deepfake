import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../../../app/app.dart';
import '../../data/data.dart';
import '../blocs/bloc.dart';
import '../widgets/conversation_avatar.dart';
import '../widgets/modal_add_conversation_member.dart';

class ConversationListMemberPage extends StatefulWidget {
  final int id;

  const ConversationListMemberPage({super.key, required this.id});

  @override
  State<ConversationListMemberPage> createState() =>
      _ConversationListMemberPageState();
}

class _ConversationListMemberPageState
    extends State<ConversationListMemberPage> {
  late ConversationModel conversation;
  late int myId;
  late bool isOwner;

  final ValueNotifier<int> _loading = ValueNotifier(-1);
  final ValueNotifier<List<int>> _deleted = ValueNotifier([]);

  bool hasChanged = false;

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;

    conversation =
        (context.read<MyConversationsBloc>().state as SuccessfulState)
            .conversations
            .firstWhere((e) => e.id == widget.id);
    isOwner = conversation.creatorId == myId;

    super.initState();
  }

  void _handleAdd() {
    openModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      useRootNavigator: true,
      fullscreen: true,
      child: ModalAddConversationMember(id: widget.id),
    ).then((members) {
      if (members == null) return;

      setState(() {
        if (mounted) {
          conversation = conversation.copyWith(
            members: [...conversation.members, ...members],
          );

          hasChanged = true;
        }
      });
    });
  }

  void _handleKick(int id) {
    if (_loading.value != -1) return;

    if (conversation.members.length <= 2) {
      context.showError(message: "DELETE_MEMBER_WHEN_MINIMUM_ERROR_TEXT".tr());
      return;
    }

    _loading.value = id;
    context.read<ConversationDetailsBloc>().add(DeleteMemberSubmit(
          id: widget.id,
          kick: true,
          memberId: id,
          onSuccess: () {
            _deleted.value = [..._deleted.value, id];
            _loading.value = -1;
            hasChanged = true;
          },
          onError: (msg) {
            _loading.value = -1;
            context.showError(message: msg);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          onPressed: () => context.pop(hasChanged),
        ),
        title: Text(
          "CONVERSATION_MEMBERS_TEXT".tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _handleAdd,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          separatorBuilder: (context, index) => Container(
            height: 0.5,
            width: double.infinity,
            color: Colors.grey,
            margin: EdgeInsets.only(left: 18 + 0.1125.sw + 16, right: 18),
          ),
          itemCount: conversation.members.length,
          itemBuilder: (context, index) {
            final _member = conversation.members[index];

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              onTap: () {},
              title: Text(
                _member.username ?? _member.email,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              leading: BlocBuilder<SocketBloc, SocketState>(
                builder: (context, state) {
                  return ConversationAvatar(
                    size: 0.1125.sw,
                    avatars: [_member.avatar?.fullPath ?? ""],
                    isOnline: state.online.contains(_member.id),
                  );
                },
              ),
              subtitle: Text(
                _member.id == conversation.creatorId
                    ? "CONVERSATION_CREATOR_TEXT".tr()
                    : "CONVERSATION_MEMBER_TEXT".tr(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              trailing: (isOwner && _member.id != conversation.creatorId)
                  ? ValueListenableBuilder(
                      valueListenable: _deleted,
                      builder: (context, value, child) =>
                          value.contains(_member.id)
                              ? Text(
                                  "DELETED_MEMBER_TEXT".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: Colors.redAccent),
                                )
                              : IconButton(
                                  onPressed: () => _handleKick(_member.id),
                                  icon: ValueListenableBuilder(
                                    valueListenable: _loading,
                                    builder: (context, value, child) =>
                                        value == _member.id
                                            ? const AppIndicator(size: 24)
                                            : const Icon(
                                                Icons.logout,
                                                color: Colors.redAccent,
                                                size: 24,
                                              ),
                                  ),
                                ),
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
