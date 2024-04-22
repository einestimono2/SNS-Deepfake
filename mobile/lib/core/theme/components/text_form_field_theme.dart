import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static final lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    labelStyle: const TextStyle().copyWith(
      fontSize: 12.sp,
      color: AppColors.kContentColorLightTheme,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 11.sp,
      color: AppColors.kContentColorLightTheme,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      fontSize: 13.sp,
      color: AppColors.kContentColorLightTheme.withOpacity(0.85),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1.w, color: Colors.grey),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1.w, color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1.w, color: AppColors.kPrimaryColor),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        width: 1.w,
        color: AppColors.kErrorColor.withOpacity(0.5),
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1.w, color: AppColors.kErrorColor),
    ),
  );

  static final darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    labelStyle: const TextStyle().copyWith(
      fontSize: 12.sp,
      color: AppColors.kContentColorDarkTheme,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 11.sp,
      color: AppColors.kContentColorDarkTheme,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      fontSize: 13.sp,
      color: AppColors.kContentColorDarkTheme.withOpacity(0.85),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1.w, color: Colors.grey.withOpacity(0.75)),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1.w, color: Colors.grey.withOpacity(0.75)),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1.w, color: AppColors.kPrimaryColor),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        width: 1.w,
        color: AppColors.kErrorColor.withOpacity(0.5),
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(width: 1.w, color: AppColors.kErrorColor),
    ),
  );
}
