import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../data/data.dart';

class ReactionSummary extends StatelessWidget {
  final PostModel post;

  const ReactionSummary({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...post.reactionOrder().map((e) => Image.asset(
              e,
              width: 13,
              height: 13,
            )),
        SizedBox(width: 3.w),
        Text(
          Formatter.formatShortenNumber(post.reactionCount.toDouble()),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(width: 8.w),
      ],
    );
  }
}
