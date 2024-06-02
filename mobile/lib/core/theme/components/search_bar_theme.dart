import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

class AppSearchBarTheme {
  AppSearchBarTheme._();

  static final lightSearchBarTheme = SearchBarThemeData(
    shape: MaterialStatePropertyAll<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    textStyle: MaterialStatePropertyAll<TextStyle>(const TextStyle().copyWith(
      fontSize: 12.sp,
      color: AppColors.kContentColorLightTheme,
    )),
    hintStyle: MaterialStatePropertyAll<TextStyle>(const TextStyle().copyWith(
      fontSize: 11.sp,
      color: AppColors.kContentColorLightTheme.withOpacity(0.85),
    )),
  );

  static final darkSearchBarTheme = SearchBarThemeData(
    shape: MaterialStatePropertyAll<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    textStyle: MaterialStatePropertyAll<TextStyle>(
      const TextStyle().copyWith(
        fontSize: 12.sp,
        color: AppColors.kContentColorDarkTheme,
      ),
    ),
    hintStyle: MaterialStatePropertyAll<TextStyle>(
      const TextStyle().copyWith(
        fontSize: 11.sp,
        color: AppColors.kContentColorDarkTheme.withOpacity(0.85),
      ),
    ),
  );
}
