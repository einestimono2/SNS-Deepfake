import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../app/app.dart';
import '../widgets/otp_form.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: <Widget>[
              /* Title */
              SizedBox(height: 0.05.sh, width: double.infinity),
              Text(
                "OTP_VERIFICATION_TEXT".tr(),
                style: Theme.of(context).textTheme.headlineLarge.sectionStyle,
              ),

              /* Email & expire */
              SizedBox(height: 0.035.sh),
              _buildEmailAndExpireInfo(context),

              /* OTP Form */
              SizedBox(height: 0.15.sh),
              OtpForm(spacing: 6.r),

              /*  */
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailAndExpireInfo(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "WE_SENT_OTP_TO_TEXT".tr(),
            style: Theme.of(context).textTheme.bodyMedium.sectionStyle,
            children: [
              TextSpan(
                text: " '${context.read<AppBloc>().state.user?.email}'",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    .sectionStyle
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "OTP_VALID_TIME_TEXT".tr(),
            style: Theme.of(context).textTheme.bodyMedium.sectionStyle,
            children: [
              TextSpan(
                text: " ${"TIME_MINUTES_ARGS".plural(5)}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    .sectionStyle
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
