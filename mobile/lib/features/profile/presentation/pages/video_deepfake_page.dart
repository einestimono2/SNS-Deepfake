import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

import '../../../../config/configs.dart';

class VideoDeepfakePage extends StatelessWidget {
  const VideoDeepfakePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "Deepfake",
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          sliver: SliverList.list(children: [
            const SectionTitle(title: "Đang chờ xử lý"),
            SizedBox(height: 0.35.sh),
            const SectionTitle(title: "Video của tôi"),
          ]),
        ),
      ],
      actions: [
        IconButton(
          onPressed: () => context.goNamed(Routes.createVideoDF.name),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
