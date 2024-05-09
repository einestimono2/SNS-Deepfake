import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../widgets/login_form.dart';
import '../widgets/navigation_text.dart';
import '../widgets/social_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0.075.sw, vertical: 8.h),
          child: Column(
            children: [
              /* Logo */
              SizedBox(height: 0.03.sh),
              Image.asset(AppImages.appLogo, width: 0.35.sw),

              /* Form */
              Padding(
                padding: EdgeInsets.only(top: 0.05.sh, bottom: 0.075.sh),
                child: const LoginForm(),
              ),

              /* Or */
              _buildSocialLogin(context),

              /* Register */
              SizedBox(height: 0.05.sh),
              NavigationText(
                onTap: () => context.goNamed(Routes.signup.name),
                label: "NO_ACCOUNT_TEXT".tr(),
                navigationText: "SIGN_UP_TEXT".tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLogin(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.grey)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Text(
                "VIA_SOCIAL_MEDIA_TEXT".tr(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const Expanded(child: Divider(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 0.005.sh),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialButton(
              icon: FontAwesomeIcons.facebookF,
              onClick: () => context.showWarning(
                title: "COMING_SOON_TEXT".tr(),
                message: "UPCOMING_FEATURE_TEXT".tr(),
              ),
              background: AppColors.facebookBackgroundColor,
            ),
            SizedBox(width: 0.02.sw),
            SocialButton(
              icon: FontAwesomeIcons.google,
              onClick: () => context.showWarning(
                title: "COMING_SOON_TEXT".tr(),
                message: "UPCOMING_FEATURE_TEXT".tr(),
              ),
              background: AppColors.googleBackgroundColor,
            ),
          ],
        ),
      ],
    );
  }
}
