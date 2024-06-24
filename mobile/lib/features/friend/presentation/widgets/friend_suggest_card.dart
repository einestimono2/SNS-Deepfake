import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/features/friend/friend.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';

class FriendSuggestCard extends StatefulWidget {
  final FriendModel friend;

  const FriendSuggestCard({
    super.key,
    required this.friend,
  });

  @override
  State<FriendSuggestCard> createState() => _FriendSuggestCardState();
}

class _FriendSuggestCardState extends State<FriendSuggestCard> {
  final ValueNotifier<String?> _requestStatus = ValueNotifier(null);
  final ValueNotifier<bool> _addLoading = ValueNotifier(false);
  final ValueNotifier<bool> _rejectLoading = ValueNotifier(false);

  void _handleAdd() {
    if (_addLoading.value || _rejectLoading.value) return;

    _addLoading.value = true;
    context.read<FriendActionBloc>().add(SendRequestSubmit(
          targetId: widget.friend.id,
          onSuccess: () =>
              _requestStatus.value = "SENT_FRIEND_REQUEST_TEXT".tr(),
          onError: (msg) {
            _addLoading.value = false;

            context.showError(message: msg);
          },
        ));
  }

  void _handleReject() {
    if (_rejectLoading.value || _addLoading.value) return;

    _rejectLoading.value = true;
    Future.delayed(const Duration(seconds: 1)).then((value) {
      context
          .read<SuggestedFriendsBloc>()
          .add(RemoveSuggestedFriend(widget.friend.id));
      _rejectLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        Routes.otherProfile.name,
        pathParameters: {"id": widget.friend.id.toString()},
        extra: {'username': widget.friend.username},
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            AnimatedImage(
              width: 0.225.sw,
              height: 0.225.sw,
              url: widget.friend.avatar?.fullPath ?? "",
              isAvatar: true,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.friend.username ?? "Unknown",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  widget.friend.sameFriends > 0
                      ? Padding(
                          padding: EdgeInsets.only(top: 3.h, bottom: 6.h),
                          child: Text(
                            'MUTUAL_FRIENDS_TEXT'
                                .plural(widget.friend.sameFriends),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey,
                                    ),
                          ),
                        )
                      : const SizedBox(height: 6),
                  ValueListenableBuilder(
                    valueListenable: _requestStatus,
                    builder: (context, value, child) => value == null
                        ? Row(
                            children: [
                              _requestAction(
                                color: Colors.blueAccent,
                                label: "ADD_FRIEND_TEXT".tr(),
                                onClick: _handleAdd,
                                listener: _addLoading,
                              ),
                              SizedBox(width: 12.w),
                              _requestAction(
                                color: context.minBackgroundColor(),
                                label: "REMOVE_FRIEND_TEXT".tr(),
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
        ),
      ),
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
