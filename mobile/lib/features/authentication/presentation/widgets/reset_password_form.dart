import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/widgets/widgets.dart';
import '../../authentication.dart';

class ResetPasswordForm extends StatefulWidget {
  final double spacing;
  final String email;

  const ResetPasswordForm({
    super.key,
    this.spacing = 6,
    required this.email,
  });

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final pin1FocusNode = FocusNode();
  final pin2FocusNode = FocusNode();
  final pin3FocusNode = FocusNode();
  final pin4FocusNode = FocusNode();
  final pin5FocusNode = FocusNode();
  final pin6FocusNode = FocusNode();

  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();
  final _controller5 = TextEditingController();
  final _controller6 = TextEditingController();

  late final double pinSize;

  final btnController = AnimatedButtonController();
  final ValueNotifier<bool> _newObscure = ValueNotifier(true);

  Timer? _timer;
  final ValueNotifier<int> _timeRemaining = ValueNotifier(30);
  final ValueNotifier<bool> _resending = ValueNotifier(false);

  final _newCtl = TextEditingController();
  final _repeatCtl = TextEditingController();

  final _newFN = FocusNode();
  final _repeatFN = FocusNode();

  @override
  void initState() {
    pinSize = (1.sw - 0.05.sw * 2) / 6 - widget.spacing;

    super.initState();

    _startTimeExpired();
  }

  @override
  void dispose() {
    pin1FocusNode.dispose();
    pin2FocusNode.dispose();
    pin3FocusNode.dispose();
    pin4FocusNode.dispose();
    pin5FocusNode.dispose();
    pin6FocusNode.dispose();

    _timer!.cancel();
    _newFN.dispose();
    _repeatFN.dispose();

    super.dispose();
  }

  void _handleVerify() {
    String _otp = _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text +
        _controller5.text +
        _controller6.text;

    if (_otp.length != 6) {
      context.showError(message: "OTP_NOT_FILL_TEXT".tr());
      return;
    }

    if (_formKey.currentState!.validate() &&
        _newCtl.text.isNotEmpty &&
        _repeatCtl.text.isNotEmpty) {
      btnController.play();

      context.read<UserBloc>().add(ResetPasswordSubmit(
          email: widget.email,
          password: _newCtl.text,
          otp: _otp,
          onSuccess: () => context
            ..pop()
            ..pop(),
          onError: (msg) {
            btnController.reverse();
            context.showError(message: msg);
          }));
    }
  }

  void _handleResendOTP() {
    _resending.value = true;

    context.read<UserBloc>().add(ResendOTPSubmit(
          email: widget.email,
          onError: (msg) {
            _resending.value = false;
            context.showError(
              title: "RESEND_ERROR_TITLE_TEXT".tr(),
              message: msg,
            );
          },
          onSuccess: () => _resending.value = false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 0.015.sh),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            /* Time & Resend */
            _buildTimer(context),

            /* OTP */
            SizedBox(height: 0.015.sh),
            _buildOTP(),

            /*  */
            SizedBox(height: 0.05.sh),
            ValueListenableBuilder(
              valueListenable: _newObscure,
              builder: (context, value, child) => Column(
                children: <Widget>[
                  SectionTitle(
                    title: "NEW_PASSWORD_TEXT".tr(),
                    onShowMore: () => _newObscure.value = !value,
                    showMoreText: value ? "SHOW_TEXT".tr() : "HIDDEN_TEXT".tr(),
                  ),
                  const SizedBox(height: 12),
                  InputFieldWithShadow(
                    onTapOutside: (_) => _newFN.unfocus(),
                    textInputAction: TextInputAction.next,
                    focusNode: _newFN,
                    border: true,
                    obscureText: value,
                    hintText: "NEW_PASSWORD_HINT_TEXT".tr(),
                    controller: _newCtl,
                    validator: AppValidations.validatePassword,
                    onFieldSubmitted: (_) => _repeatFN.requestFocus(),
                  ),
                  const SizedBox(height: 16),
                  InputFieldWithShadow(
                    onTapOutside: (_) => _repeatFN.unfocus(),
                    textInputAction: TextInputAction.next,
                    focusNode: _repeatFN,
                    border: true,
                    obscureText: value,
                    hintText: "REPEAT_PASSWORD_HINT_TEXT".tr(),
                    controller: _repeatCtl,
                    validator: (value) =>
                        AppValidations.validateConfirmPassword(
                      value,
                      _newCtl.text,
                    ),
                    onFieldSubmitted: (_) => _handleVerify(),
                  ),
                ],
              ),
            ),

            /* Button */
            SizedBox(height: 0.05.sh),
            AnimatedButton(
              height: 40.h,
              title: "CONTINUE_TEXT".tr(),
              onPressed: _handleVerify,
              controller: btnController,
            ),
          ],
        ),
      ),
    );
  }

  Row _buildOTP() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPIN(
          _controller1,
          _controller2,
          pin1FocusNode,
          pin2FocusNode,
          autofocus: true,
        ),
        _buildPIN(
          _controller2,
          _controller3,
          pin2FocusNode,
          pin3FocusNode,
        ),
        _buildPIN(
          _controller3,
          _controller4,
          pin3FocusNode,
          pin4FocusNode,
        ),
        _buildPIN(
          _controller4,
          _controller5,
          pin4FocusNode,
          pin5FocusNode,
        ),
        _buildPIN(
          _controller5,
          _controller6,
          pin5FocusNode,
          pin6FocusNode,
        ),
        _buildPIN(
          _controller6,
          null,
          pin6FocusNode,
          null,
        ),
      ],
    );
  }

  Widget _buildTimer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${"RESEND_OTP_AFTER_TEXT".tr()} ",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        ValueListenableBuilder(
          valueListenable: _timeRemaining,
          builder: (context, value, child) => value > 0
              ? Text(
                  "${value}s",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                )
              : ValueListenableBuilder(
                  valueListenable: _resending,
                  builder: (context, loading, child) => loading
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: AppIndicator(size: 14.sp),
                        )
                      : TextButton(
                          onPressed: _handleResendOTP,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            "RESEND_TEXT".tr(),
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                ),
        )
      ],
    );
  }

  Widget _buildPIN(
    TextEditingController controller,
    TextEditingController? controllerNext,
    FocusNode? focusNode,
    FocusNode? focusNodeNext, {
    bool autofocus = false,
  }) {
    return SizedBox.square(
      dimension: pinSize,
      child: TextFormField(
        onTapOutside: (_) => focusNode?.unfocus(),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          contentPadding: EdgeInsets.zero,
          errorStyle: const TextStyle(fontSize: 0),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1.5,
              color: AppColors.kErrorColor,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        expands: false,
        autocorrect: false,
        autofocus: autofocus,
        controller: controller,
        focusNode: focusNode,
        obscureText: false,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onTap: () => controller.clear(),
        onChanged: (value) => focusNodeNext == null
            ? _newFN.requestFocus()
            : nextPin(
                value: value,
                focusNode: focusNodeNext,
                controller: controllerNext,
              ),
      ),
    );
  }

  void nextPin({
    String? value,
    FocusNode? focusNode,
    TextEditingController? controller,
  }) {
    if (value?.length == 1) {
      controller!.clear();
      focusNode!.requestFocus();
    }
  }

  void _startTimeExpired() {
    _timeRemaining.value = 30;

    const onsec = Duration(seconds: 1);

    _timer = Timer.periodic(onsec, (Timer timer) {
      if (_timeRemaining.value == 0) {
        timer.cancel();
      } else {
        _timeRemaining.value--;
      }
    });
  }
}
