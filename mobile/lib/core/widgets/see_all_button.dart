import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

class SeeAllButton extends StatelessWidget {
  final VoidCallback onClick;
  final String? label;
  final EdgeInsetsGeometry? margin;

  const SeeAllButton({
    super.key,
    required this.onClick,
    this.label,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
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
        child: Text(label ?? "See all"),
      ),
    );
  }
}
