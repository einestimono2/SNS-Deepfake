import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/user_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFN = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final btnController = AnimatedButtonController();

  @override
  void dispose() {
    _passwordFN.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    if (_formKey.currentState!.validate() && _emailController.text.isNotEmpty) {
      btnController.play();

      context.read<UserBloc>().add(ForgotPasswordSubmit(
            email: _emailController.text,
            onSuccess: () {
              btnController.reverse();
              context.pushNamed(
                Routes.resetPassword.name,
                extra: {"email": _emailController.text},
              );
            },
            onError: (msg) {
              btnController.reverse();
              context.showError(message: msg);
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FOROGT_PASSWORD_TITLE_TEXT".tr(),
          style: Theme.of(context).textTheme.headlineSmall?.sectionStyle,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "FOROGT_PASSWORD_CONTENT_TEXT".tr(),
                    style:
                        Theme.of(context).textTheme.headlineSmall.sectionStyle,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "FOROGT_PASSWORD_DESCRIPTION_TEXT".tr(),
                    style: Theme.of(context).textTheme.bodyMedium.sectionStyle,
                    textAlign: TextAlign.center,
                  ),

                  /*  */
                  SizedBox(height: 0.075.sh),
                  InputFieldWithShadow(
                    onTapOutside: (_) => _passwordFN.unfocus(),
                    focusNode: _passwordFN,
                    textInputAction: TextInputAction.done,
                    border: true,
                    title: "EMAIL_TEXT".tr(),
                    controller: _emailController,
                    onFieldSubmitted: (_) => _handleForgotPassword(),
                    validator: AppValidations.validateEmail,
                    prefixIcon: Icon(
                      FontAwesomeIcons.at,
                      size: 18.sp,
                      // color: null,
                    ),
                  ),

                  /*  */
                  SizedBox(height: 0.05.sh),
                  AnimatedButton(
                    height: 40.h,
                    title: "CONTINUE_TEXT".tr(),
                    onPressed: _handleForgotPassword,
                    controller: btnController,
                  ),
                  SizedBox(height: 0.075.sh),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
