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
}
