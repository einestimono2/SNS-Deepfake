import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/extensions/theme_mode.dart';

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
    builder: (context) => Column(
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
  );
}
