import 'package:flutter/material.dart';

import '../../data/data.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({super.key, required this.notification});

  String getNotificationTitle() {
    switch (notification.type) {
      case 1: // FriendRequest
        return "Nguyễn Văn A đã gửi lời mời kết bạn!";
      case 2: // FriendAccepted
        return "Nguyễn Văn A đã chấp nhận yêu cầu kết bạn!";
      case 3: // PostAdded
        return "Đã thêm mới bài viết";
      case 4: // PostUpdated
        return "Đã cập nhật bài viết";
      case 5: // PostFelt
        return "Nguyễn Văn A đã ";
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
      default:
        return "Default";
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
