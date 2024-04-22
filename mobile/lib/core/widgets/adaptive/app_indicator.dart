import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AppIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  final double strokeWidth;

  const AppIndicator({
    super.key,
    this.color,
    this.size,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return size != null
        ? SizedBox.square(
            dimension: size,
            child: _indicator(),
          )
        : _indicator();
  }

  Widget _indicator() => DeviceUtils.isIOS() ? _buildIOS() : _buildAndroid();

  Widget _buildIOS() => CupertinoActivityIndicator(
        color: color ?? Colors.white,
      );

  Widget _buildAndroid() => CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? Colors.white),
        strokeWidth: strokeWidth,
      );
}
