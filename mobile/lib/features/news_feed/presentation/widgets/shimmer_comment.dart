import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../../../../core/utils/utils.dart';

class ShimmerComment extends StatelessWidget {
  final int length;

  const ShimmerComment({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: AppColors.shimmerGradient,
      child: ListView.separated(
        separatorBuilder: (_, __) => const SizedBox(height: 22),
        itemCount: length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _shimmerCard(),
      ),
    );
  }

  Widget _shimmerCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton(isAvatar: true, width: 0.1.sw, height: 0.1.sw),
        const SizedBox(width: 8),
        Expanded(
          child: Skeleton(
            height: 0.125.sw,
            width: double.infinity,
            radius: 12,
          ),
        ),
      ],
    );
  }
}
