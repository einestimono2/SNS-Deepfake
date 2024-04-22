import 'package:flutter/material.dart';

extension ThemeModeType on BuildContext {
  bool isDarkMode() => Theme.of(this).brightness == Brightness.dark;
  bool isLightMode() => Theme.of(this).brightness == Brightness.light;
  Color minBackgroundColor() => Theme.of(this).brightness == Brightness.dark ? Colors.white10 : Colors.black12;
}