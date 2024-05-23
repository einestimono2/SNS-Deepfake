import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/widgets/widgets.dart';
import 'color_separate.dart';

class ShimmerPost extends StatelessWidget {
  final int length;

  const ShimmerPost({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    double btnWidth = (1.sw - 12 - 12) / 3 - 12;

    return Shimmer(
      gradient: AppColors.shimmerGradient,
      child: ListView.separated(
        separatorBuilder: (context, index) =>
            const ColorSeparate(isSliverType: false),
        itemCount: length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _shimmerCard(btnWidth),
      ),
    );
  }

  Widget _shimmerCard(double btnSpaceBetween) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 3),
        Row(
          children: [
            Skeleton(
              marginLeft: 12,
              marginRight: 8,
              isAvatar: true,
              width: 0.1.sw,
              height: 0.1.sw,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(height: 14.sp, width: 0.25.sw),
                Skeleton(height: 12.sp, width: 0.5.sw, marginTop: 3),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Skeleton(
          marginLeft: 12,
          marginRight: 12,
          height: 0.2.sh,
          width: double.infinity,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Skeleton(height: 32, width: btnSpaceBetween),
              Skeleton(height: 32, width: btnSpaceBetween),
              Skeleton(height: 32, width: btnSpaceBetween),
            ],
          ),
        ),
        const SizedBox(height: 3),
      ],
    );
  }
}
