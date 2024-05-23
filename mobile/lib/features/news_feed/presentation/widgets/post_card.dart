import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns_deepfake/core/libs/libs.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/data.dart';
import 'grid_image_video.dart';
import 'model_post_action.dart';
import 'react_button.dart';

final double defaultHorizontal = 16.w;

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* Group Info */
        if (post.group != null) _buildGroupInfo(context),

        /* Header */
        _buildHeader(context),

        /* Content */
        _buildContent(context),

        /* Stats */
        _buildStats(context),
      ],
    );
  }

  Widget _buildGroupInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: EdgeInsets.only(left: defaultHorizontal, bottom: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.minTextColor().withOpacity(0.5),
            width: 0.35,
          ),
        ),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.labelMedium,
          children: [
            const TextSpan(text: "Bài viết nằm trong nhóm '"),
            TextSpan(
              text: post.group!.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  print('Click to post ${post.id}');
                  // TODO: Naivigate to group page
                },
            ),
            const TextSpan(text: "'"),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: defaultHorizontal, top: 3.h),
      child: Row(
        children: [
          /* Avatar */
          GestureDetector(
            onTap: () {
              // TODO: Navigate to author or my profile
            },
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
                  InkWell(
                    onTap: () {
                      // TODO: Navigate to author or my profile
                    },
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
                    ],
                  ),
                ],
              ),
            ),
          ),

          /* Icon dot */
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
        // TODO: Hiện đang để 1 video cho đỡ lag
        if (post.videos.isNotEmpty && post.videos.length == 1000)
          // TODO: Click image thì mở detail post chứ k mở list image như hiện tại
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
        GestureDetector(
          onTap: () {
            print("Nav detail post");
            // TODO: Navigate to detail post
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: defaultHorizontal,
              vertical: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (post.reactionCount > 0) _reactionSummary(context),
                _viewInfo(context),
              ],
            ),
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
              label: "LIKE_TEXT".tr(gender: 'none'),
              icon: FontAwesomeIcons.thumbsUp,
              width: 1.sw / (post.canEdit ? 2.125 : 3.25),
            ),
            NormalReactionButton(
              label: "COMMENT_TEXT".tr(gender: 'none'),
              icon: FontAwesomeIcons.comment,
              onTap: () {
                // TODO: Navigate to detail post
              },
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

  Widget _reactionSummary(BuildContext context) {
    return Row(
      children: [
        ...post.reactionOrder().map((e) => Image.asset(
              e,
              width: 13,
              height: 13,
            )),
        SizedBox(width: 3.w),
        Text(
          Formatter.formatShortenNumber(post.reactionCount.toDouble()),
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }

  Widget _viewInfo(BuildContext context) {
    return Row(
      children: [
        Text(
          "COMMENT_TEXT".tr(gender: "other", args: ['15,3K']),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(width: 8.w),
        // Text("8,1K lượt chia sẻ",
        //     style: Theme.of(context).textTheme.labelMedium),
        // SizedBox(width: 8.w),
        // Text("90.5K lượt xem",
        //     style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
