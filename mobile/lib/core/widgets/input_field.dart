import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';

class InputFieldWithShadow extends StatefulWidget {
  const InputFieldWithShadow({
    super.key,
    this.paddingVertical,
    this.paddingHorizontal,
    this.title,
    this.hintText,
    this.controller,
    this.focusNode,
    this.textInputType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.border = true,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autovalidateMode,
    this.onTapOutside,
    this.onTap,
    this.enabled,
  });

  final double? paddingVertical;
  final double? paddingHorizontal;
  final String? title;
  final bool obscureText;
  final bool? enabled;
  final String? hintText;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool border;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final AutovalidateMode? autovalidateMode;
  final Function(PointerDownEvent)? onTapOutside;
  final VoidCallback? onTap;

  @override
  State<InputFieldWithShadow> createState() => InputFieldWithShadowState();
}

class InputFieldWithShadowState extends State<InputFieldWithShadow> {
  final ValueNotifier<String?> _errorText = ValueNotifier(null);

  @override
  void dispose() {
    _errorText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 3,
          borderRadius: widget.border ? BorderRadius.circular(8.r) : null,
          child: TextFormField(
            autocorrect: false,
            onTap: widget.onTap,
            onTapOutside:
                widget.onTapOutside ?? (event) => widget.focusNode?.unfocus(),
            autovalidateMode:
                widget.autovalidateMode ?? AutovalidateMode.onUserInteraction,
            textInputAction: widget.textInputAction ?? TextInputAction.done,
            focusNode: widget.focusNode,
            obscureText: widget.obscureText,
            controller: widget.controller,
            validator: widget.validator != null
                ? (value) {
                    final msg = widget.validator!(value);

                    //!! the Future delayed is to avoid calling [setState] during [build]
                    Future.delayed(
                      Duration.zero,
                      () => mounted ? _errorText.value = msg : null,
                    );

                    return msg;
                  }
                : null,
            keyboardType: widget.textInputType,
            onFieldSubmitted: widget.onFieldSubmitted,
            decoration: InputDecoration(
              enabled: widget.enabled ?? true,
              errorStyle: const TextStyle(fontSize: 0, height: 0.1),
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.paddingVertical ?? 16.h,
                horizontal: widget.paddingHorizontal ?? 16.w,
              ),
              labelText: widget.title,
              // labelStyle: const TextStyle(color: Colors.black),
              hintText: widget.hintText,
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
              // prefixIconColor: _errorText != null
              //     ? AppColors.kErrorColor.withOpacity(0.95)
              //     : null,
              // suffixIconColor: _errorText != null
              //     ? AppColors.kErrorColor.withOpacity(0.95)
              //     : null,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _errorText,
          builder: (context, value, child) => value != null
              ? Padding(
                  padding: EdgeInsets.only(
                      left: 16.w, right: 16.w, top: 6.h, bottom: 1.h),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.kErrorColor.withOpacity(0.95),
                      letterSpacing: -0.1,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
