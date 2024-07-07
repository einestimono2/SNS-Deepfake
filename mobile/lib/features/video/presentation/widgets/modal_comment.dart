import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../news_feed/data/data.dart';
import '../../../news_feed/presentation/blocs/list_comment/list_comment_bloc.dart';
import '../../../news_feed/presentation/widgets/comment/comment_tree.dart';
import '../../../news_feed/presentation/widgets/shimmer_comment.dart';
import '../../data/data.dart';
import '../blocs/blocs.dart';

class ModalComment extends StatefulWidget {
  final VideoModel video;
  final Function(int, int) onComment;

  const ModalComment({
    super.key,
    required this.video,
    required this.onComment,
  });

  @override
  State<ModalComment> createState() => _ModalCommentState();
}

class _ModalCommentState extends State<ModalComment> {
  late final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasReachedMax = false;

  final TextEditingController _ctl = TextEditingController();
  final FocusNode _focus = FocusNode();

  final ValueNotifier<CommentModel?> _reply = ValueNotifier(null);
  final ValueNotifier<int> _type = ValueNotifier(1);
  final ValueNotifier<bool> _canSend = ValueNotifier(false);
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void initState() {
    _getListComment();

    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focus.dispose();

    super.dispose();
  }

  void _getListComment() {
    _loadingMore = true;
    _page = 1;

    context.read<ListCommentBloc>().add(GetListComment(
          postId: widget.video.id,
          page: 1,
          size: AppStrings.commentPageSize,
        ));
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_loadingMore &&
        !_hasReachedMax) {
      _loadingMore = true;

      context.read<ListCommentBloc>().add(LoadMoreListComment(
            postId: widget.video.id,
            page: ++_page,
            size: AppStrings.commentPageSize,
          ));
    }
  }

  void _handleComment() {
    if (_loading.value) return;

    if (bannedWords[context.locale.languageCode]!
        .any((e) => _ctl.text.toLowerCase().contains(e))) {
      context.showError(message: "BANNED_COMMENT_NOTIFICATION".tr());
      return;
    }

    _loading.value = true;
    context.read<ListVideoBloc>().add(CreateCommentSubmit(
          postId: widget.video.id,
          content: _ctl.text,
          type: _type.value,
          markId: _reply.value?.id,
          page: _page,
          size: AppStrings.commentPageSize,
          onSuccess: (fakes, trusts) {
            _loading.value = false;
            _ctl.clear();
            _reply.value = null;

            widget.onComment(fakes, trusts);
          },
          onError: (msg) {
            context.showError(message: msg);
            _loading.value = false;
          },
        ));
  }

  void _handleReply(CommentModel _comment) {
    _focus.requestFocus();
    _reply.value = _comment;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.5.sh,
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: BlocBuilder<ListCommentBloc, ListCommentState>(
                builder: (context, state) {
                  if (state is ListCommentInProgressState ||
                      state is ListCommentInitialState) {
                    return const ShimmerComment(length: 5);
                  } else if (state is ListCommentSuccessfulState) {
                    _loadingMore = false;
                    _hasReachedMax = state.hasReachedMax;

                    if (state.comments.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return ListView.separated(
                      controller: _scrollController,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 18),
                      padding: const EdgeInsets.only(bottom: 8, top: 12),
                      shrinkWrap: true,
                      itemCount: state.hasReachedMax
                          ? state.comments.length
                          : state.comments.length + 1,
                      itemBuilder: (context, index) => index <
                              state.comments.length
                          ? CommentTree(
                              authorId: widget.video.authorId,
                              comment: state.comments[index],
                              rootAvatarSize: 0.1.sw,
                              childAvatarSize: 0.05.sw,
                              childMargin:
                                  EdgeInsets.only(left: 0.1.sw + 12, top: 16),
                              identColor: context.minBackgroundColor(),
                              onReply: _handleReply,
                              initExpand: false,
                            )
                          : const Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Center(child: AppIndicator(size: 32)),
                            ),
                    );
                  } else {
                    return ErrorCard(
                      onRefresh: _getListComment,
                      message: (state as ListCommentFailureState).message,
                    );
                  }
                },
              ),
            ),
          ),

          /*  */
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: _commentField(),
          ),
        ],
      ),
    );
  }

  Widget _commentField() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(color: context.minBackgroundColor(), width: 1.5),
    );

    return Container(
      decoration: BoxDecoration(
        boxShadow: highModeShadow,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: _reply,
            builder: (context, value, child) => value == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(
                      bottom: 6,
                      left: 12,
                      right: 16 + 12, // current + parent
                    ),
                    child: Row(
                      children: [
                        Text(
                          "REPLYING_TO_TEXT".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(fontSize: 10.sp),
                        ),
                        Text(
                          " ${value.author.username}",
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 12.sp,
                          child: Text(
                            "\u00b7",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 10.sp),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _reply.value = null,
                          child: Text(
                            "CANCEL_TEXT".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 10.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: _type,
                builder: (context, value, child) => AnimatedCrossFade(
                  firstChild: GestureDetector(
                    onTap: () => _type.value = 0,
                    child: LocalImage(
                      path: AppImages.likeReaction,
                      width: 0.075.sw,
                      height: 0.075.sw,
                    ),
                  ),
                  secondChild: GestureDetector(
                    onTap: () => _type.value = 1,
                    child: LocalImage(
                      path: AppImages.dislikeReaction,
                      height: 0.075.sw,
                      width: 0.075.sw,
                    ),
                  ),
                  crossFadeState: value == 1
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: Durations.medium2,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  focusNode: _focus,
                  onTapOutside: (_) => _focus.unfocus(),
                  onChanged: (value) => _canSend.value = value.isNotEmpty,
                  controller: _ctl,
                  maxLines: null,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                    hintText: "POST_COMMENT_HINT_TEXT".tr(),
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _canSend,
                builder: (context, value, child) {
                  if (value) {
                    return IconButton(
                      onPressed: _handleComment,
                      icon: ValueListenableBuilder(
                        valueListenable: _loading,
                        builder: (context, value, child) => value
                            ? const AppIndicator(size: 28)
                            : const Icon(Icons.send),
                      ),
                      color: Colors.blueAccent,
                    );
                  } else {
                    return const SizedBox(width: 16);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
