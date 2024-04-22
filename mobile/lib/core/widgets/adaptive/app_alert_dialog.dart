import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';

Future<dynamic> showAppAlertDialog({
  required BuildContext context,
  bool barrierDismissible = true,
  String? title,
  String? content,
  String? okText,
  VoidCallback? onOK,
}) async {
  dynamic response;

  if (DeviceUtils.isIOS()) {
    response = await showCupertinoDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CupertinoAlertDialog(
        title: title == null ? null : Text(title),
        content: content == null ? null : Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "CANCEL_TEXT".tr(),
              textAlign: TextAlign.justify,
            ),
          ),
          CupertinoDialogAction(
            onPressed: onOK ?? () => Navigator.of(context).pop(),
            isDefaultAction: true,
            child: Text(
              okText ?? "OK_TEXT".tr(),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  } else {
    response = showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: title == null ? null : Text(title),
        content: content == null ? null : Text(content),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "CANCEL_TEXT".tr(),
              textAlign: TextAlign.justify,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            onPressed: onOK ?? () => Navigator.of(context).pop(),
            child: Text(
              okText ?? "OK_TEXT".tr(),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );

    return response;
  }
}
