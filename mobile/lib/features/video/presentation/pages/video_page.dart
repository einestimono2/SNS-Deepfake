import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/widgets.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Video Page'),
        SizedBox(
          height: 0.5.sh,
          width: 1.sw,
          child: const AppVideo(
            "http://192.168.1.2:8888/api/v1/media/videos",
            isNetwork: true,
          ),
        ),
      ],
    );
  }
}
