import 'package:flutter/widgets.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';

class ShimmerNotification extends StatelessWidget {
  final int length;
  const ShimmerNotification({super.key, required this.length});

  @override
  Widget build(BuildContext context) {
    return const AppIndicator();
  }
}
