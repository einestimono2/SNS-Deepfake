import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

class SeeAllButton extends StatelessWidget {
  final VoidCallback onClick;
  final String? label;
  final EdgeInsetsGeometry? margin;
  final double? width;

  const SeeAllButton({
    super.key,
    required this.onClick,
    this.label,
    this.margin,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: context.minBackgroundColor(),
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        onPressed: onClick,
        child: Text(
          label ?? "SEE_MORE_TEXT".tr(),
          style: TextStyle(
            color: context.minTextColor(),
          ),
        ),
      ),
    );
  }
}
