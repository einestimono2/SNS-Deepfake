import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReactButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ReactButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: 1.sw / 3.5,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 0),
            ),
          ],
        ),
      ),
    );
  }
}
