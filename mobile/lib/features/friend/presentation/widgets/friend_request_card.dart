import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/features/friend/friend.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';

class FriendRequestCard extends StatefulWidget {
  final FriendModel friend;

  const FriendRequestCard({
    super.key,
    required this.friend,
  });

  @override
  State<FriendRequestCard> createState() => _FriendRequestCardState();
}

class _FriendRequestCardState extends State<FriendRequestCard> {
  final ValueNotifier<int> _requestStatus = ValueNotifier(-1);
  final ValueNotifier<bool> _acceptLoading = ValueNotifier(false);
  final ValueNotifier<bool> _rejectLoading = ValueNotifier(false);

  void _handleAccept() {
    if (_acceptLoading.value || _rejectLoading.value) return;

    _acceptLoading.value = true;
    context.read<FriendActionBloc>().add(AcceptRequestSubmit(
          targetId: widget.friend.id,
          onSuccess: () => _requestStatus.value = 0,
          onError: (msg) {
            _acceptLoading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  void _handleReject() {
    if (_rejectLoading.value || _acceptLoading.value) return;

    _rejectLoading.value = true;
    context.read<FriendActionBloc>().add(RefuseRequestSubmit(
          targetId: widget.friend.id,
          onSuccess: () => _requestStatus.value = 1,
          onError: (msg) {
            _rejectLoading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        Routes.otherProfile.name,
        pathParameters: {"id": widget.friend.id.toString()},
        extra: {'username': widget.friend.username},
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.friend.username ?? "Unknown",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        DateHelper.getTimeAgo(
                          widget.friend.createdAt,
                          context.locale.languageCode,
                          showSuffixText: false,
                        ),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  widget.friend.sameFriends > 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Row(
                            children: [
                              SizedBox(width: 14.sp / 2),
                              ...widget.friend.sameFriendAvatars
                                  .map((e) => Align(
                                        widthFactor: 0.5,
                                        child: AnimatedImage(
                                          url: e,
                                          isAvatar: true,
                                          width: 14.sp,
                                          height: 14.sp,
                                        ),
                                      )),
                              const SizedBox(width: 8),
                              Text(
                                'MUTUAL_FRIENDS_TEXT'
                                    .plural(widget.friend.sameFriends),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(height: 6),
                  _buildActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ValueListenableBuilder<int> _buildActions() {
    return ValueListenableBuilder(
      valueListenable: _requestStatus,
      builder: (context, value, child) {
        if (value == 0) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              onPressed: () => context.pushNamed(
                Routes.conversation.name,
                pathParameters: {"id": "-1"},
                extra: {
                  "id": widget.friend.id,
                  "avatar": widget.friend.avatar,
                  "username": widget.friend.username,
                },
              ),
              icon: const Icon(Icons.waving_hand_rounded, size: 20),
              label: Text(
                "SEND_MESSAGE_TEXT".tr(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          );
        } else if (value == 1) {
          // Reject
          return Text(
            "REJECT_FRIEND_TEXT".tr(),
            style: Theme.of(context).textTheme.titleSmall,
          );
        }

        return Row(
          children: [
            _requestAction(
              color: Colors.blueAccent,
              label: "CONFIRM_TEXT".tr(),
              onClick: _handleAccept,
              listener: _acceptLoading,
            ),
            SizedBox(width: 12.w),
            _requestAction(
              color: context.minBackgroundColor(),
              label: "DELETE_FRIEND_TEXT".tr(),
              onClick: _handleReject,
              listener: _rejectLoading,
            ),
          ],
        );
      },
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
          builder: (context, value, child) => value
              ? AppIndicator(size: 18.sp)
              : Text(
                  label,
                  style: TextStyle(
                    color: label == "CANCEL_TEXT".tr()
                        ? context.minTextColor()
                        : Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
