import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

class AppNavigationBarTheme {
  AppNavigationBarTheme._();

  static final lightNavigationBar = NavigationBarThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 8,
    indicatorShape: const CircleBorder(eccentricity: 0.35),
    indicatorColor: AppColors.kPrimaryColor.withOpacity(0.25),
    labelTextStyle: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.kPrimaryColor,
            )
          : TextStyle(
              fontSize: 9.5.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.kContentColorLightTheme.withOpacity(0.5),
            ),
    ),
    iconTheme: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? const IconThemeData(
              color: AppColors.kPrimaryColor,
            )
          : IconThemeData(
              color: AppColors.kContentColorLightTheme.withOpacity(0.5),
            ),
    ),
  );

  static final darkNavigationBar = NavigationBarThemeData(
    backgroundColor: AppColors.kContentColorLightTheme,
    surfaceTintColor: AppColors.kContentColorLightTheme,
    elevation: 8,
    indicatorShape: const CircleBorder(eccentricity: 0.35),
    indicatorColor: AppColors.kPrimaryColor.withOpacity(0.25),
    labelTextStyle: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.kPrimaryColor,
            )
          : TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.kContentColorDarkTheme.withOpacity(0.5),
            ),
    ),
    iconTheme: MaterialStateProperty.resolveWith(
      (states) => states.contains(MaterialState.selected)
          ? const IconThemeData(
              color: AppColors.kPrimaryColor,
            )
          : IconThemeData(
              color: AppColors.kContentColorDarkTheme.withOpacity(0.5),
            ),
    ),
  );
}
