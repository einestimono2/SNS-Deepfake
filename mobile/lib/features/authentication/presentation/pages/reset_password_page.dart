import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/features/app/bloc/app/app_bloc.dart';
import 'package:sns_deepfake/features/authentication/presentation/widgets/reset_password_form.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RESET_PASSWORD_TITLE_TEXT".tr(),
          style: Theme.of(context).textTheme.headlineSmall?.sectionStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /* Email & expire */
              SizedBox(height: 0.035.sh),
              _buildEmailAndExpireInfo(context),

              /*  */
              SizedBox(height: 0.05.sh),
              const ResetPasswordForm(),
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
                text:
                    " '${context.read<AppBloc>().state.user?.email ?? "einestimono2@gmail.com"}'",
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
