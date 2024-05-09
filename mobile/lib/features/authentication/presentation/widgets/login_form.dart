import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../bloc/user_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ValueNotifier<bool> _obscure = ValueNotifier(true);

  final _emailFN = FocusNode();
  final _passwordFN = FocusNode();

  final _emailController =
      TextEditingController(text: "user1@gmail.com");
  final _passwordController = TextEditingController(text: "123123123");

  final btnController = AnimatedButtonController();

  void _handleLogin() {
    // Trường hợp submit luôn mà chưa nhập gì thì chưa validate
    if (_formKey.currentState!.validate() &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      btnController.play();

      context.read<UserBloc>().add(
            LoginSubmit(
              email: _emailController.text,
              password: _passwordController.text,
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
            title: "LOGIN_ERROR_TITLE_TEXT".tr(),
            message: state.message,
          );
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
                // color: _emailFN.hasFocus ? AppColors.kPrimaryColor : null,
              ),
            ),

            /* Passworđ Field */
            SizedBox(height: 18.h),
            ValueListenableBuilder(
              valueListenable: _obscure,
              builder: (context, value, child) => InputFieldWithShadow(
                onTap: () => _handleTap(_passwordFN, true),
                onTapOutside: (_) => _handleTap(_passwordFN, false),
                focusNode: _passwordFN,
                textInputAction: TextInputAction.send,
                border: true,
                title: "PASSWORD_TEXT".tr(),
                obscureText: _obscure.value,
                controller: _passwordController,
                validator: AppValidations.validatePassword,
                onFieldSubmitted: (_) => _nextRequest(null),
                prefixIcon: Icon(
                  FontAwesomeIcons.lock,
                  size: 18.sp,
                  // color: null,
                ),
                suffixIcon: IconButton(
                  splashRadius: 16.r,
                  onPressed: () => _obscure.value = !_obscure.value,
                  icon: Icon(
                    _obscure.value
                        ? FontAwesomeIcons.eye
                        : FontAwesomeIcons.eyeSlash,
                    size: 16.sp,
                    // color: Colors.black,
                  ),
                ),
              ),
            ),

            /* Forgot password */
            SizedBox(height: 8.h),
            _forgotPasswordSection(context),

            /* Button */
            SizedBox(height: 0.07.sh),
            AnimatedButton(
              height: 50.h,
              title: "LOGIN_TEXT".tr(),
              onPressed: _handleLogin,
              controller: btnController,
            ),
          ],
        ),
      ),
    );
  }

  Align _forgotPasswordSection(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => context.goNamed(Routes.forgot.name),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5.w),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          "FORGOT_TEXT".tr(),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailFN.dispose();
    _passwordFN.dispose();
    super.dispose();
  }

  void _nextRequest(FocusNode? next) {
    _emailFN.unfocus();
    _passwordFN.unfocus();

    if (next == null) {
      _handleLogin();
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
