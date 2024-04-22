import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationText extends StatelessWidget {
  final String? label;
  final String navigationText;
  final VoidCallback onTap;

  const NavigationText({
    super.key,
    this.label,
    required this.navigationText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        label != null
            ? Text(
                label!,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : const SizedBox.shrink(),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(3.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              navigationText,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
