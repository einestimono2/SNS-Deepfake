import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sns_deepfake/core/widgets/skeleton_shimmer.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../../../../core/utils/utils.dart';

class ShimmerFriendCard extends StatelessWidget {
  const ShimmerFriendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: AppColors.shimmerGradient,
      child: Row(
        children: [
          Skeleton(
            width: 0.25.sw,
            height: 0.25.sw,
            isAvatar: true,
            marginRight: 12.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton(width: 0.3.sw, height: 16.sp),
                    Skeleton(width: 0.15.sw, height: 16.sp),
                  ],
                ),
                Skeleton(
                  marginTop: 6.h,
                  marginBottom: 6.h,
                  width: 0.25.sw,
                  height: 16.sp,
                ),
                Row(
                  children: [
                    Expanded(child: Skeleton(height: 32.h)),
                    SizedBox(width: 12.w),
                    Expanded(child: Skeleton(height: 32.h)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
