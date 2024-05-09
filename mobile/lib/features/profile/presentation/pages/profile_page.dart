import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/extensions/theme_mode.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
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
      title: "Cá nhân",
      actions: [
        IconButton(
          tooltip: "Cài đặt",
          enableFeedback: true,
          onPressed: () => context.goNamed(Routes.setting.name),
          icon: const Icon(Icons.settings),
        )
      ],
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 0.65.sh,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
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
                "Đăng xuất",
                style: TextStyle(color: context.minTextColor()),
              ),
            ),
          ),
        )
      ],
    );
  }
}
