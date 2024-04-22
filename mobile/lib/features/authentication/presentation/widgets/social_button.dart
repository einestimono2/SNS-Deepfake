import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClick;
  final Color background;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onClick,
    this.background = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClick,
      icon: Icon(
        icon,
        size: 18.sp,
        color: Colors.white,
      ),
      style: IconButton.styleFrom(
        backgroundColor: background,
      ),
    );
  }
}
