import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? showMoreText;
  final VoidCallback? onShowMore;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool showTopSeparate;

  const SectionTitle({
    super.key,
    required this.title,
    this.onShowMore,
    this.showMoreText,
    this.margin,
    this.showTopSeparate = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 6.h),
      padding: padding ?? EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: showTopSeparate ? 0.1 : 0,
            color: showTopSeparate
                ? Theme.of(context).textTheme.titleLarge!.color!
                : Colors.transparent,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Lời mời kết bạn",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (onShowMore != null)
            TextButton(
              onPressed: onShowMore,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Text(
                showMoreText ?? "SEE_MORE_TEXT".tr(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
              ),
            )
        ],
      ),
    );
  }
}
