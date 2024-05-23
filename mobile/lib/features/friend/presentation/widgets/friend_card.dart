import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/data.dart';

class FriendCard extends StatelessWidget {
  final FriendModel friend;

  const FriendCard({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        Routes.otherProfile.name,
        pathParameters: {"id": friend.id.toString()},
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
        child: Row(
          children: [
            /*  */
            AnimatedImage(
              width: 0.15.sw,
              height: 0.15.sw,
              url: friend.avatar?.fullPath ?? "",
              isAvatar: true,
            ),

            /*  */
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.username ?? "Unknown",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (friend.sameFriends != 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        'MUTUAL_FRIENDS_TEXT'.plural(friend.sameFriends),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    )
                ],
              ),
            ),

            /*  */
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
      ),
    );
  }
}
