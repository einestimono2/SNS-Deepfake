import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../app/app.dart';
import '../../authentication.dart';

class OtpForm extends StatefulWidget {
  final double spacing;

  const OtpForm({
    super.key,
    this.spacing = 6,
  });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
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
  late final UserModel? user;

  final btnController = AnimatedButtonController();

  Timer? _timer;
  final ValueNotifier<int> _timeRemaining = ValueNotifier(30);
  final ValueNotifier<bool> _resending = ValueNotifier(false);

  @override
  void initState() {
    pinSize = (1.sw - 0.05.sw * 2) / 6 - widget.spacing;
    user = context.read<AppBloc>().state.user;

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

    super.dispose();
  }

  void _handleVerify() {
    pin6FocusNode.unfocus();

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

    btnController.play();
    context.read<UserBloc>().add(
          VerifyOTPSubmit(
            email: user?.email ?? "",
            otp: _otp,
          ),
        );
  }

  void _handleResendOTP() {
    _resending.value = true;

    context.read<UserBloc>().add(ResendOTPSubmit(email: user?.email ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is FailureState) {
          String title = "";

          if (state.type == "RESEND_OTP") {
            _resending.value = false;
            title = "RESEND_ERROR_TITLE_TEXT";
          } else if (state.type == "VERIFY_OTP") {
            btnController.reverse();
            title = "VERIFY_ERROR_TITLE_TEXT";
          }

          context.showError(
            title: title.tr(),
            message: state.message,
          );
        } else if (state is SuccessfulState) {
          if (state.type == "RESEND_OTP") {
            _resending.value = false;
          } else if (state.type == "VERIFY_OTP") {
            btnController.reverse();
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw, vertical: 0.015.sh),
        child: Form(
          child: Column(
            children: [
              /* Time & Resend */
              _buildTimer(context),

              /* OTP */
              SizedBox(height: 0.015.sh),
              _buildOTP(),

              /* Button */
              SizedBox(height: 0.15.sh),
              AnimatedButton(
                height: 50.h,
                title: "VERIFY_TEXT".tr(),
                onPressed: _handleVerify,
                controller: btnController,
              ),
            ],
          ),
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
            ? _handleVerify()
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
