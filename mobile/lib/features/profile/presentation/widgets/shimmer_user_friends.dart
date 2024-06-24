import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sns_deepfake/core/utils/constants/colors.dart';

import '../../../../core/widgets/widgets.dart';

class ShimmerUserFriends extends StatelessWidget {
  final double cardWidth;
  final double separateWidth;

  const ShimmerUserFriends({
    super.key,
    required this.cardWidth,
    required this.separateWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: AppColors.shimmerGradient,
      child: Wrap(
        spacing: separateWidth,
        runSpacing: 6,
        children: [
          _card(),
          _card(),
          _card(),
          _card(),
          _card(),
          _card(),
          _card(),
          _card(),
        ],
      ),
    );
  }

  Widget _card() {
    return SizedBox(
      width: cardWidth,
      child: Column(
        children: [
          Skeleton(
            width: cardWidth,
            height: cardWidth,
            radius: 8,
          ),
          const SizedBox(height: 6),
          Skeleton(width: cardWidth, height: 15.sp * 1.75)
        ],
      ),
    );
  }
}
