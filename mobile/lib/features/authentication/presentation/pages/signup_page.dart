import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../widgets/signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.goNamed(Routes.login.name),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 0.075.sw, vertical: 16.h),
        child: Column(
          children: [
            /* Text Section */
            SizedBox(height: DeviceUtils.getAppBarHeight(context) - 8.h),
            Text(
              "GET_STARTED_TEXT".tr(),
              style: Theme.of(context).textTheme.headlineLarge.sectionStyle,
            ),
            SizedBox(height: 6.h),
            Text(
              "CREATE_NEW_ACCOUNT_TEXT".tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  .sectionStyle
                  ?.copyWith(color: Colors.grey),
            ),

            /* Form */
            SizedBox(height: 0.05.sh),
            const SignUpForm(),
            // Padding(
            //   padding: EdgeInsets.only(top: 0.05.sh, bottom: 0.075.sh),
            //   // ignore: prefer_const_constructors
            //   child: SignUpForm(),
            // ),

            // /* Register */
            // SizedBox(height: 0.05.sh),
            // NavigationText(
            //   onTap: () => context.pop(),
            //   label: "ALREADY_HAVE_ACCOUNT_TEXT".tr(),
            //   navigationText: "LOGIN_TEXT".tr(),
            // ),
          ],
        ),
      ),
    );
  }
}
