import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../authentication/data/data.dart';

class UserInfoCard extends StatelessWidget {
  final UserModel user;
  final double paddingHorizontal;
  final bool isMyProfile;

  const UserInfoCard({
    super.key,
    required this.user,
    this.paddingHorizontal = 12.0,
    this.isMyProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
      child: Column(
        children: [
          isMyProfile
              ? SectionTitle(
                  title: "PROFILE_DETAILS_TEXT".tr(),
                  onShowMore: () => context.goNamed(Routes.updateProfile.name),
                  showMoreText: "UPDATE_TEXT".tr(),
                )
              : SectionTitle(title: "PROFILE_DETAILS_TEXT".tr()),
          const SizedBox(height: 12),
          _infoRow(
            context,
            Icons.email,
            "EMAIL_TEXT".tr(),
            user.email,
            () async => await DeviceUtils.mailTo(user.email),
          ),
          const SizedBox(height: 4),
          Divider(
            thickness: 0.25,
            height: 1,
            color: context.minBackgroundColor(),
          ),
          const SizedBox(height: 4),
          _infoRow(
            context,
            Icons.phone,
            "PHONE_NUMBER_TEXT".tr(),
            user.phoneNumber ?? "NO_PHONENUMBER_TEXT".tr(),
            () async =>
                await DeviceUtils.callPhoneNumber(user.phoneNumber ?? ""),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String text,
    VoidCallback onTap,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 0.35.sw,
          child: Row(
            children: [
              Icon(
                icon,
                size: 14.sp,
                color: Theme.of(context).textTheme.labelMedium?.color,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: InkWell(
            onTap: onTap,
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}
