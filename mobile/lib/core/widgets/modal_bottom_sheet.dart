// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

Future<dynamic> openModalBottomSheet({
  required BuildContext context,
  double borderRadius = 16,
  bool enableDrag = true,
  bool fullscreen = false,
  bool isDismissible = true,

  /// Ẩn bottom nav bar
  bool useRootNavigator = false,
  required Widget child,
}) async {
  return await showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: fullscreen
          ? BorderRadius.zero
          : BorderRadius.vertical(
              top: Radius.circular(borderRadius),
            ),
    ),
    isScrollControlled: fullscreen,
    context: context,
    useRootNavigator: useRootNavigator,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    showDragHandle: false,
    useSafeArea: fullscreen,
    builder: (context) => SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!fullscreen)
            Center(
              child: Container(
                width: 0.2.sw,
                height: 5.h,
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: context.minBackgroundColor(),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),

          /*  */
          child,

          /*  */
        ],
      ),
    ),
  );
}

void openUploadBottomSheet({
  required BuildContext context,
  required Function(String) onSelected,
  bool isPickVideo = false,
}) {
  openModalBottomSheet(
    context: context,
    child: Column(
      children: [
        ListTile(
          onTap: () async {
            final url = isPickVideo
                ? (await FileHelper.pickVideo())?.path
                : await FileHelper.pickImage();

            if (url != null) {
              onSelected(url);
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          leading: const Icon(Icons.image),
          title: Text(
            "GALLERY_TEXT".tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListTile(
          onTap: () async {
            final url = isPickVideo
                ? (await FileHelper.pickVideo(source: ImageSource.camera))?.path
                : await FileHelper.pickImage(source: ImageSource.camera);

            if (url != null) {
              onSelected(url);
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          leading: const Icon(Icons.camera),
          title: Text(
            "CAMERA_TEXT".tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    ),
  );
}
