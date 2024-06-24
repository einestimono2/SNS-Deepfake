import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../../../friend/data/data.dart';

class ProfileFriendCard extends StatelessWidget {
  final FriendModel friendModel;
  final double width;
  final bool fromMyProfile;

  const ProfileFriendCard({
    super.key,
    required this.friendModel,
    required this.width,
    this.fromMyProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => friendModel.id == context.read<AppBloc>().state.user?.id
          ? context.showInfo(message: "YOURSELF_TEXT".tr())
          : fromMyProfile
              ? context.pushNamed(
                  Routes.otherProfile.name,
                  pathParameters: {"id": friendModel.id.toString()},
                  extra: {'username': friendModel.username},
                )
              : context.pushReplacementNamed(
                  Routes.otherProfile.name,
                  pathParameters: {"id": friendModel.id.toString()},
                  extra: {'username': friendModel.username},
                ),
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}
