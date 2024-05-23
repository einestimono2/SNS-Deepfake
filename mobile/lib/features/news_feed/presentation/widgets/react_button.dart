import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/libs/libs.dart';

import '../../../../core/utils/utils.dart';

class ReactionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final double width;

  const ReactionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.width,
  });

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  final _controller = OverlayPopupController();

  @override
  Widget build(BuildContext context) {
    return OverlayPopup(
      controller: _controller,
      menu: reactMenu(),
      verticalMargin: 20.h,
      horizontalMargin: 0.1.sw,
      showArrow: false,
      child: NormalReactionButton(
        label: widget.label,
        icon: widget.icon,
        width: widget.width,
        onTap: () {
          // TODO: Click -> like
        },
        onLongPress: () => _controller.showMenu(),
      ),
    );
  }

  Widget reactMenu() {
    return IntrinsicWidth(
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0xFF4C4C4C),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 36,
              child: Image.asset(AppImages.likeReaction),
            ),
            const SizedBox(width: 6),
            SizedBox.square(
              dimension: 36,
              child: Image.asset(AppImages.loveReaction),
            ),
            const SizedBox(width: 6),
            SizedBox.square(
              dimension: 36,
              child: Image.asset(AppImages.hahaReaction),
            ),
            const SizedBox(width: 6),
            SizedBox.square(
              dimension: 36,
              child: Image.asset(AppImages.sadReaction),
            ),
          ],
        ),
      ),
    );
  }
}

/*  */

class NormalReactionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double width;

  const NormalReactionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.onLongPress,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: width,
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
