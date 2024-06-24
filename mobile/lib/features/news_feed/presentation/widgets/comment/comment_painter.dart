import 'package:flutter/material.dart';

class RootPainter extends CustomPainter {
  final double avatarSize;
  final Color identColor;
  final double identThickness;

  late Paint _paint;

  RootPainter({
    required this.avatarSize,
    required this.identColor,
    required this.identThickness,
  }) {
    _paint = Paint()
      ..color = identColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = identThickness
      ..strokeCap = StrokeCap.square;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double dx = avatarSize / 2;

    canvas.drawLine(
      Offset(dx, avatarSize),
      Offset(dx, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ChildPainter extends CustomPainter {
  final bool isLast;
  final double rootAvatarSize;
  final double childAvatarSize;
  final Color identColor;
  final double identThickness;
  final EdgeInsets childMargin;

  ChildPainter({
    required this.isLast,
    required this.rootAvatarSize,
    required this.childAvatarSize,
    required this.identColor,
    required this.identThickness,
    required this.childMargin,
  }) {
    _paint = Paint()
      ..color = identColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = identThickness
      ..strokeCap = StrokeCap.square;
  }

  late Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();

    double rootDx = rootAvatarSize / 2;
    path.moveTo(rootDx, 0);
    path.cubicTo(
      rootDx,
      0,
      rootDx,
      childMargin.top + childAvatarSize / 2,
      rootDx * 2,
      childMargin.top + childAvatarSize / 2,
    );
    canvas.drawPath(path, _paint);

    if (!isLast) {
      canvas.drawLine(
        Offset(rootDx, 0),
        Offset(rootDx, size.height),
        _paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
