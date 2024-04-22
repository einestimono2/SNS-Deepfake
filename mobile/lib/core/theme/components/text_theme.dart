import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = const TextTheme().copyWith(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.kContentColorLightTheme,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.kContentColorLightTheme,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.kContentColorLightTheme.withOpacity(0.75),
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.kContentColorLightTheme,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.kContentColorLightTheme.withOpacity(0.75),
    ),
  );

  static TextTheme darkTextTheme = const TextTheme().copyWith(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.kContentColorDarkTheme,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.kContentColorDarkTheme,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.kContentColorDarkTheme.withOpacity(0.75),
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.kContentColorDarkTheme,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.normal,
      color: AppColors.kContentColorDarkTheme.withOpacity(0.75),
    ),
  );
}
