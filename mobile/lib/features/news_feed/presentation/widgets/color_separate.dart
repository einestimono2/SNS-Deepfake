import 'package:flutter/material.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

class ColorSeparate extends StatelessWidget {
  final bool isSliverType;
  final double thickness;

  const ColorSeparate({
    super.key,
    this.isSliverType = true,
    this.thickness = 6,
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
        : Divider(
            thickness: thickness,
            color: context.minBackgroundColor(),
          );
  }
}
