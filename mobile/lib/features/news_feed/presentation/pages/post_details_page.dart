import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/news_feed/news_feed.dart';
import 'package:sns_deepfake/features/news_feed/presentation/widgets/shimmer_comment.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../widgets/comment/comment_tree.dart';
import '../widgets/react_button.dart';
import '../widgets/reaction_summary.dart';

class PostDetailsPage extends StatefulWidget {
  final int id;
  final bool focus;

  const PostDetailsPage({
    super.key,
    required this.id,
    this.focus = false,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  late final PostModel post;
  late final int myId;

  final TextEditingController _ctl = TextEditingController();
  final FocusNode _focus = FocusNode();

  final ValueNotifier<CommentModel?> _reply = ValueNotifier(null);
  final ValueNotifier<bool> _canSend = ValueNotifier(false);
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  final ValueNotifier<int> _type = ValueNotifier(1);

  late final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _loadingMore = false;
  bool _hasReachedMax = false;

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;

    context.read<PostActionBloc>().add(GetPostDetails(widget.id));

    post = (context.read<ListPostBloc>().state as ListPostSuccessfulState)
        .posts
        .firstWhere((e) => e.id == widget.id);

    _getListComment();

    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _focus.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  void _getListComment() {
    _loadingMore = true;
    _page = 1;

    context.read<ListCommentBloc>().add(GetListComment(
          postId: widget.id,
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
            postId: widget.id,
            page: ++_page,
            size: AppStrings.commentPageSize,
          ));
    }
  }

  void _handleReply(CommentModel _comment) {
    _focus.requestFocus();
    _reply.value = _comment;
  }

  void _handleComment() {
    if (_loading.value) return;

    _loading.value = true;
    context.read<PostActionBloc>().add(CreateCommentSubmit(
          postId: widget.id,
          content: _ctl.text,
          type: _type.value,
          markId: _reply.value?.id,
          page: _page,
          size: AppStrings.commentPageSize,
          onSuccess: () {
            _loading.value = false;
            _ctl.clear();
            _reply.value = null;
          },
          onError: (msg) {
            context.showError(message: msg);
            _loading.value = false;
          },
        ));
  }

  void _handleFeel(int type) {
    if (type == -1) {
      context.read<PostActionBloc>().add(UnfeelPost(
            postId: widget.id,
            onError: (msg) {
              context.showError(message: msg);
            },
            onSuccess: () {},
          ));
    } else {
      context.read<PostActionBloc>().add(FeelPost(
            postId: widget.id,
            type: type,
            onError: (msg) {
              context.showError(message: msg);
            },
            onSuccess: () {},
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<PostActionBloc, PostActionState>(
              builder: (context, state) {
                final _post = state is PASuccessfulState ? state.post : post;

                return GestureDetector(
                  onTap: () => _reply.value = null,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      _appBar(_post),

                      /*  */
                      if (_post.description?.isNotEmpty ?? false)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverToBoxAdapter(
                            child: Text(_post.description!),
                          ),
                        ),

                      /* Images */
                      if (_post.images.isNotEmpty)
                        SliverToBoxAdapter(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 16),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, idx) => AnimatedImage(
                              url: _post.images[idx].url.fullPath,
                              width: double.infinity,
                            ),
                            separatorBuilder: (__, _) =>
                                const SizedBox(height: 8),
                            itemCount: _post.images.length,
                          ),
                        ),

                      /* Videos */
                      if (_post.videos.isNotEmpty)
                        SliverToBoxAdapter(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(top: 16),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, idx) => SizedBox(
                              width: double.infinity,
                              child: AppVideo(
                                _post.videos[idx].url.fullPath,
                                isNetwork: true,
                              ),
                            ),
                            separatorBuilder: (__, _) =>
                                const SizedBox(height: 8),
                            itemCount: _post.videos.length,
                          ),
                        ),

                      /* Button */
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: context.minBackgroundColor(),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ReactionButton(
                                onClick: _handleFeel,
                                currentReaction: _post.myFeel,
                                width: (1.sw - 16 * 2) /
                                    (_post.canEdit ? 2.125 : 3.25),
                              ),
                              NormalReactionButton(
                                label: "COMMENT_TEXT".tr(gender: 'none'),
                                icon: FontAwesomeIcons.comment,
                                onTap: () => _focus.requestFocus(),
                                width: (1.sw - 16 * 2) /
                                    (_post.canEdit ? 2.125 : 3.25),
                              ),
                              if (!_post.canEdit)
                                NormalReactionButton(
                                  label: "SHARE_TEXT".tr(gender: 'none'),
                                  icon: FontAwesomeIcons.share,
                                  onTap: () {
                                    // TODO: Handle share post
                                  },
                                  width: (1.sw - 16 * 2) / 3.25,
                                ),
                            ],
                          ),
                        ),
                      ),

                      /* Summary */
                      if (_post.reactionCount > 0)
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: context.minBackgroundColor()),
                              ),
                            ),
                            child: ReactionSummary(post: _post),
                          ),
                        ),

                      /* Comments */
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: _postComment(_post.author.id),
                        ),
                      ),

                      /*  */
                      const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    ],
                  ),
                );
              },
            ),
          ),

          /*  */
          _commentField(),
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
                  autofocus: widget.focus,
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

  Widget _postComment(int authorId) {
    return BlocBuilder<ListCommentBloc, ListCommentState>(
      builder: (context, state) {
        if (state is ListCommentInProgressState ||
            state is ListCommentInitialState) {
          return const ShimmerComment(length: 5);
        } else if (state is ListCommentSuccessfulState) {
          _loadingMore = false;
          _hasReachedMax = state.hasReachedMax;

          if (state.comments.isEmpty) return const SizedBox.shrink();

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 18),
            padding: const EdgeInsets.only(bottom: 8, top: 12),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.hasReachedMax
                ? state.comments.length
                : state.comments.length + 1,
            itemBuilder: (context, index) => index < state.comments.length
                ? CommentTree(
                    authorId: authorId,
                    comment: state.comments[index],
                    rootAvatarSize: 0.1.sw,
                    childAvatarSize: 0.05.sw,
                    childMargin: EdgeInsets.only(left: 0.1.sw + 12, top: 16),
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
    );
  }

  Widget _appBar(PostModel _post) {
    final bool isGroup = _post.group != null;

    return SliverAppBar(
      pinned: true,
      scrolledUnderElevation: 0,
      titleSpacing: 1,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.25),
        child: Container(
          height: 0.25,
          color: context.minBackgroundColor(),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.ellipsis),
        )
      ],
      title: Row(
        children: [
          AnimatedImage(
            url: _post.author.avatar?.fullPath ?? "",
            isAvatar: true,
            width: kToolbarHeight - 16,
            height: kToolbarHeight - 16,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _post.author.username ?? _post.author.email,
                style:
                    Theme.of(context).textTheme.titleLarge?.copyWith(height: 1),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  if (isGroup)
                    InkWell(
                      onTap: () => context.pushNamed(
                        Routes.groupDetails.name,
                        pathParameters: {"id": _post.group!.id.toString()},
                        extra: {
                          "coverPhoto": _post.group!.coverPhoto,
                          "groupName": _post.group!.groupName,
                        },
                      ),
                      child: Text(
                        _post.group!.groupName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 13.sp,
                              height: 1,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  if (isGroup)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 12.sp,
                      child: Text(
                        "\u00b7",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(height: 1),
                      ),
                    ),
                  Text(
                    DateHelper.getTimeAgo(
                      _post.createdAt,
                      context.locale.languageCode,
                      showSuffixText: false,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(height: 1),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 12.sp,
                    child: Text(
                      "\u00b7",
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(height: 1),
                    ),
                  ),
                  Icon(
                    !isGroup
                        ? FontAwesomeIcons.earthAsia
                        : FontAwesomeIcons.usersRectangle,
                    size: 10.sp,
                    color: Theme.of(context).textTheme.labelMedium!.color,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
