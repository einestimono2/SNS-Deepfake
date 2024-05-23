import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sns_deepfake/core/widgets/skeleton_shimmer.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../../../../core/utils/utils.dart';

class ShimmerFriendCard extends StatelessWidget {
  final int length;

  const ShimmerFriendCard({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: AppColors.shimmerGradient,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, i) => _shimmerCard(),
        separatorBuilder: (context, index) => SizedBox(height: 3.h),
        itemCount: length,
      ),
    );
  }

  Widget _shimmerCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
      child: Row(
        children: [
          Skeleton(
            width: 0.15.sw,
            height: 0.15.sw,
            isAvatar: true,
            marginRight: 16.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Skeleton(width: 0.35.sw, height: 16.sp),
                Skeleton(marginTop: 6.h, width: 0.25.sw, height: 16.sp),
              ],
            ),
          ),
          Skeleton(width: 0.075.sw, height: 12.sp),
        ],
      ),
    );
  }
}

class ShimmerFriendRequestCard extends StatelessWidget {
  final int length;

  const ShimmerFriendRequestCard({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: AppColors.shimmerGradient,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemBuilder: (_, i) => _shimmerCard(),
        separatorBuilder: (context, index) => SizedBox(height: 22.h),
        itemCount: length,
      ),
    );
  }

  Row _shimmerCard() {
    return Row(
      children: [
        Skeleton(
          height: 0.225.sw,
          width: 0.225.sw,
          isAvatar: true,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Skeleton(height: 16.sp, width: 0.25.sw),
                  Skeleton(height: 16.sp, width: 0.125.sw),
                ],
              ),
              Skeleton(
                marginBottom: 6.h,
                marginTop: 3.h,
                width: 0.2.sw,
                height: 14.sp,
              ),
              Row(
                children: [
                  Expanded(child: Skeleton(height: 36.h)),
                  SizedBox(width: 12.w),
                  Expanded(child: Skeleton(height: 36.h)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
