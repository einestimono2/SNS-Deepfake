import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return SliverPage(
          title: "PROFILE_TEXT".tr(),
          actions: [
            OutlinedButton.icon(
              onPressed: () => context.goNamed(Routes.buyCoins.name),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(
                FontAwesomeIcons.coins,
                size: 16,
                color: Colors.yellow,
              ),
              label: Text(
                state.user?.coins?.toString() ?? "0",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: "SETTING_TEXT".tr(),
              enableFeedback: true,
              onPressed: () => context.goNamed(Routes.setting.name),
              icon: const Icon(Icons.settings),
            ),
          ],
          slivers: [
            SliverList.list(
              children: [
                /* My Info */
                Divider(
                  height: 1,
                  thickness: 0.5,
                  color: context.minBackgroundColor(),
                ),
                _myInfo(context, state),

                /*  */
                Container(height: 8, color: context.minBackgroundColor()),

                /*  */
                ListTile(
                  onTap: () => context.goNamed(Routes.buyCoins.name),
                  leading: const Icon(FontAwesomeIcons.bolt, size: 18),
                  title: Text(
                    "BUY_COINS_TEXT".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                /*  */
                ListTile(
                  onTap: () => context.goNamed(Routes.videoDF.name),
                  leading: const Icon(FontAwesomeIcons.clapperboard, size: 18),
                  title: Text(
                    "Video Deepfake",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),

                /*  */
                Container(height: 8, color: context.minBackgroundColor()),

                /*  */
                ListTile(
                  onTap: () => context.goNamed(Routes.updatePassword.name),
                  leading: const Icon(Icons.password, size: 18),
                  title: Text(
                    "CHANGE_PASSWORD_TEXT".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),

                /*  */
                ListTile(
                  onTap: _handleLogout,
                  leading: const Icon(
                    FontAwesomeIcons.arrowRightFromBracket,
                    size: 18,
                  ),
                  title: Text(
                    "LOGOUT_TEXT".tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  ListTile _myInfo(BuildContext context, AppState state) {
    return ListTile(
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
      trailing: const Icon(
        FontAwesomeIcons.arrowUpRightFromSquare,
        size: 18,
      ),
    );
  }
}
