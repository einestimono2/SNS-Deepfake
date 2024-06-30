import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/widgets/widgets.dart';

class EmptyConversationCard extends StatelessWidget {
  final Map<String, dynamic> friendData;

  const EmptyConversationCard({
    super.key,
    required this.friendData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0.05.sh, width: double.infinity), // full width

        /* Avatar */
        AnimatedImage(
          width: 0.25.sw,
          height: 0.25.sw,
          url: (friendData['avatar'] as String).fullPath,
          isAvatar: true,
        ),

        /* Name */
        const SizedBox(height: 12),
        Text(
          friendData['username'],
          style: Theme.of(context).textTheme.titleLarge,
        ),

        /*  */
        // const SizedBox(height: 3),
        // Text(
        //   "Các bạn hiện đang là bạn bè",
        //   style: Theme.of(context).textTheme.bodySmall,
        // ),

        /*  */
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
          child: Text(
            "EMPTY_CONVERSATION_PAGE_TEXT".tr(),
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
