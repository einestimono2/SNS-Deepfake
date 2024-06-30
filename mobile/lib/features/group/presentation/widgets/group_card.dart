import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/group_model.dart';

class GroupCard extends StatelessWidget {
  final GroupModel group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.pushNamed(
        Routes.groupDetails.name,
        pathParameters: {"id": group.id.toString()},
        extra: {
          "coverPhoto": group.coverPhoto,
          "groupName": group.groupName,
        },
      ),
      leading: AnimatedImage(
        url: group.coverPhoto?.fullPath ??
            AppImages.defaultGroupCoverPhotoNetwork,
        radius: 6,
        width: 0.2.sw,
        height: double.infinity,
        errorImage: AppImages.brokenImage,
      ),
      title: Text(
        group.groupName ?? "",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: group.description != null
          ? Text(
              group.description ?? "",
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          : null,
    );
  }
}
