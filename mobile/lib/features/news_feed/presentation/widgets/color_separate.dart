import 'package:flutter/material.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

class ColorSeparate extends StatelessWidget {
  final bool isSliverType;
  final double thickness;
  final double paddingVertical;

  const ColorSeparate({
    super.key,
    this.isSliverType = true,
    this.thickness = 6,
    this.paddingVertical = 6,
  });

  @override
  Widget build(BuildContext context) {
    return isSliverType
        ? SliverToBoxAdapter(
            child: Divider(
              thickness: thickness,
              color: context.minBackgroundColor(),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: paddingVertical),
            child: Divider(
              thickness: thickness,
              color: context.minBackgroundColor(),
            ),
          );
  }
}
