import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/extensions/theme_mode.dart';

import '../../../../core/widgets/widgets.dart';

class FriendRequestCard extends StatefulWidget {
  const FriendRequestCard({super.key});

  @override
  State<FriendRequestCard> createState() => _FriendRequestCardState();
}

class _FriendRequestCardState extends State<FriendRequestCard> {
  final ValueNotifier<String?> _requestStatus = ValueNotifier(null);
  final ValueNotifier<bool> _acceptLoading = ValueNotifier(false);
  final ValueNotifier<bool> _rejectLoading = ValueNotifier(false);

  void _handleAccept() {
    if (_acceptLoading.value || _rejectLoading.value) return;

    _acceptLoading.value = true;

    Future.delayed(const Duration(seconds: 3)).then((value) {
      _requestStatus.value = "Đã chấp nhận lời mời";
      _acceptLoading.value = false;
    });
  }

  void _handleReject() {
    if (_rejectLoading.value || _acceptLoading.value) return;

    _rejectLoading.value = true;

    Future.delayed(const Duration(seconds: 3)).then((value) {
      _requestStatus.value = "Đã từ chối lời mời";
      _rejectLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 0.25.sw,
          child: const AnimatedImage(
            url:
                "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/652.jpg",
            isAvatar: true,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hữu Khôi Mai",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "5 phút",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 3.h, bottom: 6.h),
                child: Text(
                  '5 bạn chung',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _requestStatus,
                builder: (context, value, child) => value == null
                    ? Row(
                        children: [
                          _requestAction(
                            color: Colors.blueAccent,
                            label: "Xác nhận",
                            onClick: _handleAccept,
                            listener: _acceptLoading,
                          ),
                          SizedBox(width: 12.w),
                          _requestAction(
                            color: context.minBackgroundColor(),
                            label: "Từ chối",
                            onClick: _handleReject,
                            listener: _rejectLoading,
                          ),
                        ],
                      )
                    : Text(
                        value,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Expanded _requestAction({
    required Color color,
    required ValueListenable<bool> listener,
    required String label,
    required VoidCallback onClick,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
        onPressed: onClick,
        child: ValueListenableBuilder(
          valueListenable: listener,
          builder: (context, value, child) =>
              value ? AppIndicator(size: 18.sp) : Text(label),
        ),
      ),
    );
  }
}
