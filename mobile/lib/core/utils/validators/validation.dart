import 'package:easy_localization/easy_localization.dart';

class AppValidations {
  AppValidations._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "EMAIL_EMPTY".tr();
    }

    final emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (!emailRegExp.hasMatch(value)) {
      return "EMAIL_INVALID".tr();
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "PASSWORD_EMPTY".tr();
    }

    if (value.length < 6) {
      return "PASSWORD_TOO_SHORT".tr();
    }

    // "^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]$" --> at least one uppercase letter, one lowercase letter, one number and one special character

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return "CONFIRM_PASSWORD_EMPTY".tr();
    } else if (password != value) {
      return "CONFIRM_PASSWORD_NOT_MATCH".tr();
    }

    return null;
  }
  
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return "FULL_NAME_EMPTY".tr();
    }

    return null;
  }
  
  static String? validateGroupName(String? value) {
    if (value == null || value.isEmpty) {
      return "GROUP_NAME_EMPTY".tr();
    }

    return null;
  }
  
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "PHONE_NUMBER_EMPTY".tr();
    }

    if(!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value)){
      return "PHONE_NUMBER_INVALID".tr();
    }

    return null;
  }
}
