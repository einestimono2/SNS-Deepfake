import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../utils/utils.dart';

/* Normal Button */
class Button extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;
  final bool shadow;
  final BorderRadiusGeometry? borderRadius;

  const Button({
    super.key,
    required this.title,
    this.onPressed,
    this.height,
    this.width,
    this.shadow = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 35.h,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.gradColors,
            stops: [0, 1],
          ),
          borderRadius: borderRadius ?? BorderRadius.all(Radius.circular(8.r)),
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: AppColors.gradShadowColor,
                    blurRadius: 4,
                    offset: const Offset(1, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class AnimatedButtonController {
  late VoidCallback play;
  late VoidCallback reverse;
}

/* Animated Button */
class AnimatedButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final bool shadow;
  final BorderRadiusGeometry? borderRadius;
  final AnimatedButtonController controller;

  const AnimatedButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.height,
    this.shadow = true,
    this.borderRadius,
    this.width,
    required this.controller,
  });

  @override
  State<AnimatedButton> createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late Animation btnSqueezeAnimation;
  late AnimationController btnController;

  @override
  void initState() {
    super.initState();

    btnController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    btnSqueezeAnimation = Tween(
      begin: widget.width ?? 1.sw,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: btnController,
        curve: const Interval(0.0, 0.150),
      ),
    );

    // Gắn function vào controller
    widget.controller.play = _play;
    widget.controller.reverse = _reverse;
  }

  @override
  void dispose() {
    btnController.dispose();

    super.dispose();
  }

  void _play() async {
    if (!mounted) return;

    try {
      await btnController.forward();
    } on TickerCanceled {
      //
    }
  }

  void _reverse() async {
    if (!mounted) return;

    try {
      await btnController.reverse();
    } on TickerCanceled {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildBtnAnimation,
      animation: btnController,
    );
  }

  Widget _buildBtnAnimation(BuildContext context, Widget? child) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      onPressed: btnController.isAnimating ? null : widget.onPressed,
      child: Container(
        width: btnSqueezeAnimation.value,
        height: widget.height ?? 35.h,
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.gradColors,
            stops: [0, 1],
          ),
          borderRadius:
              widget.borderRadius ?? BorderRadius.all(Radius.circular(8.r)),
          boxShadow: widget.shadow
              ? [
                  BoxShadow(
                    color: AppColors.gradShadowColor,
                    blurRadius: 4,
                    offset: const Offset(1, 3),
                  ),
                ]
              : null,
        ),
        child: btnSqueezeAnimation.value > 75.w
            ? Text(
                widget.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    .sectionStyle!
                    .copyWith(color: Colors.white),
              )
            : const AppIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
