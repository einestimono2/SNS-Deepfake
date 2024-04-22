import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AppBottomNavigationBarTheme {
  AppBottomNavigationBarTheme._();

  static final lightBottomNavigationBar = BottomNavigationBarThemeData(
    selectedItemColor: AppColors.kPrimaryColor,
    selectedLabelStyle: const TextStyle(color: AppColors.kPrimaryColor),
    selectedIconTheme: const IconThemeData(color: AppColors.kPrimaryColor),
    unselectedLabelStyle: TextStyle(
      color: AppColors.kContentColorLightTheme.withOpacity(0.55),
    ),
    unselectedItemColor: AppColors.kContentColorLightTheme.withOpacity(0.55),
    unselectedIconTheme: IconThemeData(
      color: AppColors.kContentColorLightTheme.withOpacity(0.55),
    ),
    showUnselectedLabels: true,
    landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
    enableFeedback: true,
  );

  static final darkBottomNavigationBar = BottomNavigationBarThemeData(
    selectedItemColor: AppColors.kPrimaryColor,
    selectedLabelStyle: const TextStyle(color: AppColors.kPrimaryColor),
    selectedIconTheme: const IconThemeData(color: AppColors.kPrimaryColor),
    unselectedLabelStyle: TextStyle(
      color: AppColors.kContentColorDarkTheme.withOpacity(0.35),
    ),
    unselectedItemColor: AppColors.kContentColorDarkTheme.withOpacity(0.35),
    unselectedIconTheme: IconThemeData(
      color: AppColors.kContentColorDarkTheme.withOpacity(0.35),
    ),
    showUnselectedLabels: true,
    landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
    enableFeedback: true,
  );
}
