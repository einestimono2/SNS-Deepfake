import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/libs/libs.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../../data/data.dart';
import '../blocs/blocs.dart';
import 'grid_image_video.dart';
import 'model_post_action.dart';
import 'react_button.dart';
import 'reaction_summary.dart';

final double defaultHorizontal = 16.w;

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool showGroup;
  final int adminId;
  final int myId;

  const PostCard({
    super.key,
    required this.post,
    this.showGroup = true,
    this.adminId = -1,
    required this.myId,
  });

  void _handleNavigateProfile(BuildContext context) {
    final bool isChildRole = context.read<AppBloc>().state.user!.role == 0;

    post.author.id == myId
        ? context.pushNamed(
            isChildRole ? Routes.childMyProfile.name : Routes.myProfile.name)
        : context.pushNamed(
            isChildRole
                ? Routes.childOtherProfile.name
                : Routes.otherProfile.name,
            pathParameters: {"id": post.author.id.toString()},
            extra: {'username': post.author.username},
          );
  }

  void _handleNavDetail(BuildContext context, [bool focus = false]) {
    if (context.read<AppBloc>().state.user!.role == 0) return;

    context.pushNamed(
      Routes.postDetails.name,
      pathParameters: {"id": post.id.toString()},
      extra: {"focus": focus},
    );
  }

  void _handleFeel(BuildContext context, int type) {
    if (type == -1) {
      context.read<PostActionBloc>().add(UnfeelPost(
            postId: post.id,
            onError: (msg) {
              context.showError(message: msg);
            },
            onSuccess: () {},
          ));
    } else {
      context.read<PostActionBloc>().add(FeelPost(
            postId: post.id,
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
    return GestureDetector(
      onTap: () => _handleNavDetail(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Header */
          _buildHeader(context),

          /* Content */
          _buildContent(context),

          /* Stats */
          _buildStats(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(left: defaultHorizontal),
      child: Row(
        children: [
          /* Avatar */
          GestureDetector(
            onTap: () => _handleNavigateProfile(context),
            child: AnimatedImage(
              width: 0.1.sw,
              height: 0.1.sw,
              url: post.author.avatar?.fullPath ?? "",
              isAvatar: true,
            ),
          ),

          /* Info */
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*  */
                  InkWell(
                    onTap: () => _handleNavigateProfile(context),
                    child: Text(
                      post.author.username ?? post.author.email,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      if (adminId == post.author.id)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.blueAccent.shade200,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          margin: const EdgeInsets.only(right: 6),
                          child: Text(
                            "ADMIN_TEXT".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),

                      /*  */
                      Text(
                        DateHelper.getTimeAgo(
                          post.createdAt,
                          context.locale.languageCode,
                          showSuffixText: false,
                        ),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 12.sp,
                        child: Text(
                          "\u00b7",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Icon(
                        post.group == null
                            ? FontAwesomeIcons.earthAsia
                            : FontAwesomeIcons.usersRectangle,
                        size: 10.sp,
                        color: Theme.of(context).textTheme.labelMedium!.color,
                      ),
                      if (showGroup && post.group != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: InkWell(
                            onTap: () =>
                                context.read<AppBloc>().state.user!.role == 0
                                    ? null
                                    : context.pushNamed(
                                        Routes.groupDetails.name,
                                        pathParameters: {
                                          "id": post.id.toString()
                                        },
                                        extra: {
                                          "coverPhoto": post.group!.coverPhoto,
                                          "groupName": post.group!.groupName,
                                        },
                                      ),
                            child: Text(
                              post.group!.groupName,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /* Icon dot */
          if (context.read<AppBloc>().state.user!.role != 0)
            IconButton(
              onPressed: () {
                openModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  child: ModelPostAction(post),
                );
              },
              icon: Icon(Icons.more_horiz, size: 20.sp),
            )
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /* Text Section */
        if (post.description?.isNotEmpty ?? false)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultHorizontal,
              vertical: 3.h,
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 100),
              alignment: Alignment.topCenter,
              child: ReadMoreText(
                post.description!,
                trimMode: TrimMode.line,
                trimLines: 4,
                autoHandleOnClick: true,
                trimExpandedText: "",
                trimCollapsedText: "SEE_MORE_TEXT".tr(),
                colorClickableText: Colors.grey,
                style: const TextStyle(height: 1.15),
              ),
            ),
          ),

        /* Image Section - Không cần padding horizontal */
        if (post.images.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              top: 6,
              bottom: post.videos.isNotEmpty ? 12 : 6,
            ),
            child: PostGridImage(
              files: post.images.map((e) => e.url.fullPath).toList(),
            ),
          ),

        /* Video Section - Không cần padding horizontal */
        if (post.videos.isNotEmpty)
          Wrap(
            runSpacing: 6,
            children: post.videos
                .take(1)
                .map((e) => SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: AppVideo(
                        post.videos.first.url.fullPath,
                        isNetwork: true,
                        onlyShowThumbnail: true,
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.reactionCount > 0 || post.commentCount > 0)
          Container(
            // Thêm màu để có thể trigger mở details page khi ấn vào khoảng trống ở giữa reaction vs comment
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(
              horizontal: defaultHorizontal,
              vertical: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (post.reactionCount > 0) ReactionSummary(post: post),
                if (post.commentCount > 0) _viewInfo(context),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontal),
          child: const Divider(height: 8, thickness: 0.15),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ReactionButton(
              currentReaction: post.myFeel,
              onClick: (type) => _handleFeel(context, type),
              width: 1.sw / (post.canEdit ? 2.125 : 3.25),
            ),
            NormalReactionButton(
              label: "COMMENT_TEXT".tr(gender: 'none'),
              icon: FontAwesomeIcons.comment,
              onTap: () => _handleNavDetail(context, true),
              width: 1.sw / (post.canEdit ? 2.125 : 3.25),
            ),
            if (!post.canEdit)
              NormalReactionButton(
                label: "SHARE_TEXT".tr(gender: 'none'),
                icon: FontAwesomeIcons.share,
                onTap: () {
                  // TODO: Handle share post
                },
                width: 1.sw / 3.25,
              ),
          ],
        ),
      ],
    );
  }

  Widget _viewInfo(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "NUM_COMMENT_TEXT".plural(post.commentCount),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        // Text("8,1K lượt chia sẻ",
        //     style: Theme.of(context).textTheme.labelMedium),
        // SizedBox(width: 8.w),
        // Text("90.5K lượt xem",
        //     style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
