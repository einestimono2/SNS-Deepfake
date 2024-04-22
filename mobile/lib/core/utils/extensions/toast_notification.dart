import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/extensions/text_theme.dart';
import 'package:toastification/toastification.dart';

extension ToastNotification on BuildContext {
  ToastificationItem showError({
    String title = 'Error',
    required String message,
  }) {
    return toastification.show(
      context: this,
      borderRadius: BorderRadius.circular(8.r),
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        title,
        style: Theme.of(this).textTheme.titleLarge.sectionStyle,
      ),
      description: Text(
        message,
        style: Theme.of(this).textTheme.labelMedium,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.justify,
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 400),
      boxShadow: highModeShadow,
      showProgressBar: true,
      // progressBarTheme: const ProgressIndicatorThemeData(
      //   color: Colors.white,
      //   linearTrackColor: errorColor,
      // ),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  ToastificationItem showSuccess({
    String title = 'Successful',
    required String message,
  }) {
    return toastification.show(
      context: this,
      borderRadius: BorderRadius.circular(8.r),
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        title,
        style: Theme.of(this).textTheme.titleLarge!.sectionStyle,
      ),
      description: Text(
        message,
        style: Theme.of(this).textTheme.labelMedium,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.justify,
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 400),
      boxShadow: highModeShadow,
      showProgressBar: true,
      // progressBarTheme: const ProgressIndicatorThemeData(
      //   color: Colors.white,
      //   linearTrackColor: errorColor,
      // ),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  ToastificationItem showInfo({
    String title = 'Information',
    required String message,
  }) {
    return toastification.show(
      context: this,
      borderRadius: BorderRadius.circular(8.r),
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        title,
        style: Theme.of(this).textTheme.titleLarge!.sectionStyle,
      ),
      description: Text(
        message,
        style: Theme.of(this).textTheme.labelMedium,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.justify,
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 400),
      boxShadow: highModeShadow,
      showProgressBar: true,
      // progressBarTheme: const ProgressIndicatorThemeData(
      //   color: Colors.white,
      //   linearTrackColor: errorColor,
      // ),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  ToastificationItem showWarning({
    String title = 'Warning',
    required String message,
  }) {
    return toastification.show(
      context: this,
      borderRadius: BorderRadius.circular(8.r),
      type: ToastificationType.warning,
      style: ToastificationStyle.minimal,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        title,
        style: Theme.of(this).textTheme.titleLarge!.sectionStyle,
      ),
      description: Text(
        message,
        style: Theme.of(this).textTheme.labelMedium,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
        // textAlign: TextAlign.justify,
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 400),
      boxShadow: highModeShadow,
      showProgressBar: true,
      // progressBarTheme: const ProgressIndicatorThemeData(
      //   color: Colors.white,
      //   linearTrackColor: errorColor,
      // ),
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }
}
