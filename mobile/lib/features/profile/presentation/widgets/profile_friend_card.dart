import 'package:flutter/material.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../friend/data/data.dart';

class ProfileFriendCard extends StatelessWidget {
  final FriendModel friendModel;
  final double width;

  const ProfileFriendCard({
    super.key,
    required this.friendModel,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          AnimatedImage(
            width: width,
            height: width,
            url: friendModel.avatar?.fullPath ?? "",
            radius: 8,
            errorImage: AppImages.avatarPlaceholder,
          ),
          const SizedBox(height: 6),
          Text(
            friendModel.username ?? friendModel.email,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
