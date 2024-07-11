import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../data/data.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({super.key, required this.notification});

  String getNotificationTitle() {
    switch (notification.type) {
      case 1: // FriendRequest
        return "FRIEND_REQUEST_NOTI_TEXT".tr();
      case 2: // FriendAccepted
        return "FRIEND_ACCEPTED_NOTI_TEXT".tr();
      case 3: // PostAdded
        return "POST_ADDED_NOTI_TEXT".tr();
      case 4: // PostUpdated
        return "PostUpdated";
      case 5: // PostFelt
        return "POST_FELT_NOTI_TEXT".tr();
      case 6: // PostMarked
        return "PostMarked";
      case 7: // MarkCommented
        return "MarkCommented";
      case 8: // VideoAdded
        return "VideoAdded";
      case 9: // PostCommented
        return "PostCommented";
      case 10: // PlusCoins
        return "PlusCoins";
      case 11: // ScheduledVideo
        return "ScheduledVideo";
      case 12: // CreateVideo
        return "FINISH_DEEPFAKE_NOTI_TEXT".tr();
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: Text(
        getNotificationTitle(),
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
