import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

class ShimmerNotification extends StatelessWidget {
  final int length;
  const ShimmerNotification({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 0.75.sh,
      child: const Center(child: AppIndicator()),
    );
  }
}
