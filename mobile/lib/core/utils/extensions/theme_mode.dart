import 'package:flutter/material.dart';

import '../utils.dart';

extension ThemeModeType on BuildContext {
  bool isDarkMode() => Theme.of(this).brightness == Brightness.dark;
  bool isLightMode() => Theme.of(this).brightness == Brightness.light;
  Color minBackgroundColor() => Theme.of(this).brightness == Brightness.dark
      ? Colors.white10
      // : Colors.blueGrey.shade200;
      // : const Color(0xffe4e5e3);
      : Colors.black.withOpacity(0.25);
  Color minTextColor() => Theme.of(this).brightness == Brightness.dark
      ? AppColors.kContentColorDarkTheme.withOpacity(0.85)
      // : Colors.blueGrey.shade200;
      : AppColors.kContentColorLightTheme.withOpacity(0.85);
}
