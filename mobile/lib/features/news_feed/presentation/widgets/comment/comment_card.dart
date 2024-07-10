import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../../config/configs.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../app/bloc/bloc.dart';
import '../../../data/data.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool isAuthor;
  final int myId;
  final double avatarSize;
  final EdgeInsets margin;
  final Function(CommentModel) onReply;
  final bool isNested;

  const CommentCard({
    super.key,
    required this.comment,
    required this.isAuthor,
    required this.avatarSize,
    this.margin = EdgeInsets.zero,
    required this.onReply,
    required this.myId,
    this.isNested = false,
  });

  void _handleNavProfile(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();

    myId == comment.author.id
        ? context.pushNamed(context.read<AppBloc>().state.user!.role == 0
            ? Routes.childMyProfile.name
            : Routes.myProfile.name)
        : context.pushNamed(
            context.read<AppBloc>().state.user!.role == 0
                ? Routes.childOtherProfile.name
                : Routes.otherProfile.name,
            pathParameters: {"id": comment.author.id.toString()},
            extra: {'username': comment.author.username},
          );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _handleNavProfile(context),
            child: AnimatedImage(
              isAvatar: true,
              url: comment.author.avatar?.fullPath ?? "",
              width: avatarSize,
              height: avatarSize,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 8, bottom: 2, right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: context.minBackgroundColor(),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 6, 18, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            /* Name */
                            GestureDetector(
                              onTap: () => _handleNavProfile(context),
                              child: Text(
                                comment.author.username,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.minTextColor(),
                                    ),
                              ),
                            ),

                            /* Author */
                            if (isAuthor)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: _card(context),
                              ),
                          ],
                        ),

                        /* Comment */
                        const SizedBox(height: 6),
                        Text(
                          comment.content,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: context.minTextColor()),
                        ),
                      ],
                    ),
                  ),

                  /* Type */
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: LocalImage(
                        path: comment.type == 1
                            ? AppImages.likeReaction
                            : AppImages.dislikeReaction,
                        width: 16,
                        height: 16,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 8 + 10),
                  Text(
                    DateHelper.getTimeAgo(
                      comment.createdAt,
                      context.locale.languageCode,
                      showSuffixText: false,
                    ),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 10.5.sp),
                  ),

                  /* Reply */
                  const SizedBox(width: 8),
                  if (!isNested)
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => onReply(comment),
                      child: Text(
                        "REPLY_TEXT".tr(),
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontSize: 10.5.sp),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade200,
        borderRadius: BorderRadius.circular(3),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.marker, size: 8.sp),
          const SizedBox(width: 3),
          Text(
            "AUTHOR_TEXT".tr(),
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(fontSize: 8.5.sp),
          ),
        ],
      ),
    );
  }
}
