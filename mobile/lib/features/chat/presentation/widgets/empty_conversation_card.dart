import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/widgets.dart';

class EmptyConversationCard extends StatelessWidget {
  const EmptyConversationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 0.05.sh),

        /* Avatar */
        AnimatedImage(
          width: 0.25.sw,
          height: 0.25.sw,
          url:
              "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/652.jpg",
          isAvatar: true,
        ),

        /* Name */
        const SizedBox(height: 12),
        Text(
          "Nguyễn Tuệ",
          style: Theme.of(context).textTheme.titleLarge,
        ),

        /*  */
        const SizedBox(height: 3),
        Text(
          "Các bạn hiện đang là bạn bè",
          style: Theme.of(context).textTheme.bodySmall,
        ),

        /*  */
        const SizedBox(height: 16),
        Text(
          "Gửi tin nhắn đầu tiên để bắt đầu cuộc trò chuyện!",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
