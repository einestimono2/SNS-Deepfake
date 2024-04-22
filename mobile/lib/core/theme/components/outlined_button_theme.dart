import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

class AppOutlinedButtonTheme {
  AppOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.kContentColorLightTheme,
      side: const BorderSide(color: AppColors.kPrimaryColor),
      textStyle: TextStyle(
        fontSize: 16.sp,
        color: AppColors.kContentColorLightTheme,
        fontWeight: FontWeight.w600,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.kContentColorDarkTheme,
      side: const BorderSide(color: AppColors.kPrimaryColor),
      textStyle: TextStyle(
        fontSize: 16.sp,
        color: AppColors.kContentColorDarkTheme,
        fontWeight: FontWeight.w600,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
  );
}
