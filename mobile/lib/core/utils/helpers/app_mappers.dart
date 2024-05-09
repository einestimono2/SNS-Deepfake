import 'package:easy_localization/easy_localization.dart';

class AppMappers {
  AppMappers._();

  static String getRoleName(int value) {
    switch (value) {
      case 0:
        return "CHILDREN_TEXT".tr();
      case 1:
        return "PARENT_TEXT".tr();
      default:
        return "";
    }
  }
  
  static String getThemeName(String themeName) {
    switch (themeName) {
      case "system":
        return "THEME_SYSTEM_TEXT".tr();
      case "light":
        return "THEME_LIGHT_TEXT".tr();
      case "dark":
        return "THEME_DARK_TEXT".tr();
      default:
        return themeName;
    }
  }
}
