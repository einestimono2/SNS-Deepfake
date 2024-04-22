import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sns_deepfake/features/authentication/presentation/widgets/radio_image_button.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../authentication.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _passwordObscure = ValueNotifier(true);
  final ValueNotifier<bool> _confirmPasswordObscure = ValueNotifier(true);
  final ValueNotifier<int> _role = ValueNotifier(1);

  final _emailFN = FocusNode();
  final _passwordFN = FocusNode();
  final _confirmPasswordFN = FocusNode();

  final _emailController = TextEditingController(text: "einestimono2@gmail.com");
  final _passwordController = TextEditingController(text: "123123");
  final _confirmPasswordController = TextEditingController(text: "123123");

  final btnController = AnimatedButtonController();

  void _handleSignUp() {
    // Trường hợp submit luôn mà chưa nhập gì thì chưa validate
    if (_formKey.currentState!.validate() &&
        _emailController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      btnController.play();

      context.read<UserBloc>().add(
            SignUpSubmit(
              email: _emailController.text,
              password: _passwordController.text,
              role: _role.value,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is FailureState) {
          btnController.reverse();

          context.showError(
            title: "SIGNUP_ERROR_TITLE_TEXT".tr(),
            message: state.message,
          );
        } else if (state is SuccessfulState) {
          btnController.reverse();
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* Email Field */
            InputFieldWithShadow(
              onTap: () => _handleTap(_emailFN, true),
              onTapOutside: (_) => _handleTap(_emailFN, false),
              textInputAction: TextInputAction.next,
              focusNode: _emailFN,
              border: true,
              title: "EMAIL_TEXT".tr(),
              controller: _emailController,
              validator: AppValidations.validateEmail,
              onFieldSubmitted: (_) => _nextRequest(_passwordFN),
              prefixIcon: Icon(
                FontAwesomeIcons.at,
                size: 18.sp,
              ),
            ),

            /* Passworđ Field */
            SizedBox(height: 16.h),
            ValueListenableBuilder(
              valueListenable: _passwordObscure,
              builder: (context, value, child) => InputFieldWithShadow(
                onTap: () => _handleTap(_passwordFN, true),
                onTapOutside: (_) => _handleTap(_passwordFN, false),
                focusNode: _passwordFN,
                textInputAction: TextInputAction.next,
                border: true,
                title: "PASSWORD_TEXT".tr(),
                obscureText: _passwordObscure.value,
                controller: _passwordController,
                validator: AppValidations.validatePassword,
                onFieldSubmitted: (_) => _nextRequest(_confirmPasswordFN),
                prefixIcon: Icon(
                  FontAwesomeIcons.lock,
                  size: 18.sp,
                ),
                suffixIcon: IconButton(
                  splashRadius: 16.r,
                  onPressed: () =>
                      _passwordObscure.value = !_passwordObscure.value,
                  icon: Icon(
                    _passwordObscure.value
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 16.sp,
                  ),
                ),
              ),
            ),

            /* Confirm Passworđ Field */
            SizedBox(height: 16.h),
            ValueListenableBuilder(
              valueListenable: _confirmPasswordObscure,
              builder: (context, value, child) => InputFieldWithShadow(
                onTap: () => _handleTap(_confirmPasswordFN, true),
                onTapOutside: (_) => _handleTap(_confirmPasswordFN, false),
                focusNode: _confirmPasswordFN,
                textInputAction: TextInputAction.send,
                border: true,
                title: "CONFIRM_PASSWORD_TEXT".tr(),
                obscureText: _confirmPasswordObscure.value,
                controller: _confirmPasswordController,
                validator: (value) => AppValidations.validateConfirmPassword(
                    value, _passwordController.text),
                onFieldSubmitted: (_) => _nextRequest(null),
                prefixIcon: Icon(
                  FontAwesomeIcons.lock,
                  size: 18.sp,
                ),
                suffixIcon: IconButton(
                  splashRadius: 16.r,
                  onPressed: () => _confirmPasswordObscure.value =
                      !_confirmPasswordObscure.value,
                  icon: Icon(
                    _confirmPasswordObscure.value
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 16.sp,
                  ),
                ),
              ),
            ),

            /* Role */
            SizedBox(height: 24.h),
            ValueListenableBuilder(
              valueListenable: _role,
              builder: (context, value, child) =>
                  _buildRoleSelection(context, value),
            ),

            /* Button */
            SizedBox(height: 0.08.sh),
            AnimatedButton(
              height: 50.h,
              title: "SIGN_UP_TEXT".tr(),
              onPressed: _handleSignUp,
              controller: btnController,
            ),
          ],
        ),
      ),
    );
  }

  Column _buildRoleSelection(BuildContext context, int currentValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 6.w),
          child: Text(
            "YOU_ARE_TEXT".tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            RadioImageButton(
              value: 1,
              image: AppImages.roleParents,
              isSelected: 1 == currentValue,
              onClick: (value) => _role.value = value,
            ),
            SizedBox(width: 0.03.sw),
            RadioImageButton(
              value: 0,
              image: AppImages.roleChildren,
              isSelected: 0 == currentValue,
              onClick: (value) => _role.value = value,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailFN.dispose();
    _passwordFN.dispose();
    _confirmPasswordFN.dispose();
    super.dispose();
  }

  void _nextRequest(FocusNode? next) {
    _emailFN.unfocus();
    _passwordFN.unfocus();
    _confirmPasswordFN.unfocus();

    if (next == null) {
      _handleSignUp();
    } else {
      next.requestFocus();
    }
  }

  // Set Forcus khi ấn, tại dùng node.hasFocus để xác định loại màu của suffixIcon
  void _handleTap(FocusNode node, bool focus) {
    if (focus) {
      node.requestFocus();
    } else {
      node.unfocus();
    }
  }
}
