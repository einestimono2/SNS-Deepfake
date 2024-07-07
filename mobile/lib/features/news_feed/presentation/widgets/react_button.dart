import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/libs/libs.dart';

import '../../../../core/utils/utils.dart';

class ReactionButton extends StatefulWidget {
  final double width;
  final int currentReaction;
  final Function(int) onClick;

  const ReactionButton({
    super.key,
    required this.width,
    required this.onClick,
    this.currentReaction = -1,
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
      verticalMargin: 25.h,
      showArrow: false,
      position: PopupPosition.top,
      child: InkWell(
        onTap: () => widget.onClick(widget.currentReaction != -1 ? -1 : 0),
        onLongPress: () => _controller.showMenu(),
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          width: widget.width,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AppMappers.getReactionIcon(widget.currentReaction),
                size: 18.sp,
                color: AppMappers.getReactionColor(
                    context, widget.currentReaction),
              ),
              SizedBox(width: 6.w),
              Text(
                AppMappers.getReactionText(widget.currentReaction),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 0,
                      color: AppMappers.getReactionColor(
                        context,
                        widget.currentReaction,
                      ),
                    ),
              ),
            ],
          ),
        ),
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
            GestureDetector(
              onTap: () {
                _controller.hideMenu();
                widget.onClick(0);
              },
              child: SizedBox.square(
                dimension: 36,
                child: Image.asset(AppImages.likeReaction),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                _controller.hideMenu();
                widget.onClick(1);
              },
              child: SizedBox.square(
                dimension: 36,
                child: Image.asset(AppImages.dislikeReaction),
              ),
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
