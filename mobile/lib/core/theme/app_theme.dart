import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'components/components.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: AppColors.kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.kPrimaryColor,
      secondary: AppColors.kSecondaryColor,
      error: AppColors.kErrorColor,
    ),
    iconTheme: const IconThemeData(color: AppColors.kContentColorLightTheme),
    appBarTheme: const AppBarTheme(elevation: 0),
    bottomNavigationBarTheme:
        AppBottomNavigationBarTheme.lightBottomNavigationBar,
    navigationBarTheme: AppNavigationBarTheme.lightNavigationBar,
    bottomSheetTheme: AppBottomSheetTheme.lightBottomSheetTheme,
    checkboxTheme: AppCheckboxTheme.lightCheckboxTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
    textTheme: AppTextTheme.lightTextTheme,
    inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.kPrimaryColor,
    scaffoldBackgroundColor: AppColors.kContentColorLightTheme,
    appBarTheme: const AppBarTheme(elevation: 0)
        .copyWith(backgroundColor: AppColors.kContentColorLightTheme),
    iconTheme: const IconThemeData(color: AppColors.kContentColorDarkTheme),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: AppColors.kPrimaryColor,
      secondary: AppColors.kSecondaryColor,
      error: AppColors.kErrorColor,
    ),
    bottomNavigationBarTheme:
        AppBottomNavigationBarTheme.darkBottomNavigationBar,
    navigationBarTheme: AppNavigationBarTheme.darkNavigationBar,
    bottomSheetTheme: AppBottomSheetTheme.darkBottomSheetTheme,
    checkboxTheme: AppCheckboxTheme.darkCheckboxTheme,
    elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.darkOutlinedButtonTheme,
    textTheme: AppTextTheme.darkTextTheme,
    inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
  );
}
