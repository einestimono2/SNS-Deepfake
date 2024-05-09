import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final bool isAvatar;
  final double? width;
  final double height;
  final double? radius;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final double marginLeft;

  const Skeleton({
    super.key,
    this.isAvatar = false,
    this.width,
    required this.height,
    this.radius,
    this.marginTop = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    this.marginLeft = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        marginLeft,
        marginTop,
        marginRight,
        marginBottom,
      ),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: isAvatar ? null : BorderRadius.circular(radius ?? 3),
        color: Colors.grey,
        shape: isAvatar ? BoxShape.circle : BoxShape.rectangle,
      ),
    );
  }
}
