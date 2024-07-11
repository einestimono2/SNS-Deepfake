import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/extensions/image_path.dart';
import 'package:sns_deepfake/core/widgets/app_video.dart';

class PlayVideoDialog extends StatelessWidget {
  final String url;

  const PlayVideoDialog({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: SizedBox(
        height: 0.5.sh,
        width: double.infinity,
        child: AppVideo(
          url.fullPath,
          isNetwork: true,
        ),
      ),
    );
  }
}
