import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";
import "package:sns_deepfake/core/utils/utils.dart";
import "package:sns_deepfake/core/widgets/widgets.dart";

import "../../../config/configs.dart";

class PermissionHelper {
  PermissionHelper._();

  static Future<bool> request(List<Permission> permission) async {
    // Thực hiện show dialog cấp quyền
    final Map<Permission, PermissionStatus> status = await permission.request();

    bool containPermanentlyDenied =
        status.values.any((e) => e.isPermanentlyDenied);

    if (containPermanentlyDenied) {
      if (rootNavigatorKey.currentContext == null) {
        AppLogger.error("[rootNavigatorKey.currentContext] is null");
      } else {
        showAppAlertDialog(
            context: rootNavigatorKey.currentContext!,
            barrierDismissible: false,
            title: "PERMISSION_DENIED".tr(),
            content: "PERMISSION_DENIED_DONT_SHOW_AGAIN".tr(),
            okText: "SETTING_TEXT".tr(),
            onOK: () {
              openAppSettings().then(
                (_) => Navigator.of(rootNavigatorKey.currentContext!).pop(),
              );
            });
      }
    }

    return status.values.every((e) => e.isGranted);
  }
}
