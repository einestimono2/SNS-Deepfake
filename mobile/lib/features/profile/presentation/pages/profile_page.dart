import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/extensions/image_path.dart';
import 'package:sns_deepfake/core/utils/extensions/theme_mode.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../../../authentication/authentication.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _handleLogout() async {
    context.read<UserBloc>().add(LogoutSubmit());
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "PROFILE_TEXT".tr(),
      actions: [
        IconButton(
          tooltip: "SETTING_TEXT".tr(),
          enableFeedback: true,
          onPressed: () => context.goNamed(Routes.setting.name),
          icon: const Icon(Icons.settings),
        )
      ],
      slivers: [
        BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            return SliverList.list(
              children: [
                /* My Info */
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: context.minBackgroundColor(),
                ),
                ListTile(
                  onTap: () => context.goNamed(Routes.myProfile.name),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  leading: AnimatedImage(
                    isAvatar: true,
                    url: state.user?.avatar?.fullPath ?? "",
                    width: 0.125.sw,
                    height: 0.125.sw,
                  ),
                  title: Text(
                    state.user?.username ?? state.user?.email ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "SEE_PERSONAL_PAGE_TEXT".tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

                /*  */
                SizedBox(height: 0.5.sh),

                /* Logout btn */
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.minBackgroundColor(),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: _handleLogout,
                    icon: Icon(Icons.logout, color: context.minTextColor()),
                    label: Text(
                      "LOGOUT_TEXT".tr(),
                      style: TextStyle(color: context.minTextColor()),
                    ),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
