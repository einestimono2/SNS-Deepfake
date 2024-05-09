import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/data.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;
  final String lastMessageTime;
  final int myId;
  final int idx;
  final Map<int, String> memberAvatars;
  final Map<int, String> memberNames;
  final Map<int, int> memberSeen;

  const MessageCard({
    super.key,
    required this.message,
    required this.myId,
    required this.lastMessageTime,
    required this.memberAvatars,
    required this.memberSeen,
    required this.memberNames,
    required this.idx,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final ValueNotifier<bool> _isExpanded = ValueNotifier(false);

  String _getSeenText() {
    int senderId = widget.message.senderId;
    int myId = widget.myId;

    // Chat riêng
    if (widget.memberAvatars.length == 2) {
      // Tôi gửi
      if (senderId == myId) {
        return widget.message.seenIds.length == 2
            ? "SEEN_TEXT".tr(gender: 'none')
            : "SENT_TEXT".tr();
      } else {
        return "SEEN_TEXT".tr(gender: 'none');
      }
    } else {
      List<String> names = [];

      widget.memberNames.forEach((id, value) {
        if (widget.myId != id && widget.memberSeen[id]! <= widget.idx) {
          names.add(value);
        }
      });

      return names.isEmpty
          ? "SENT_TEXT".tr()
          : "SEEN_TEXT".tr(gender: 'names', args: [names.join(", ")]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mine = widget.message.senderId == widget.myId;
    final lastMessageTimeNull =
        widget.lastMessageTime == widget.message.createdAt;

    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /* Label date -- Nhóm theo các nhóm liên tiếp cách nhau 30p */
        if (lastMessageTimeNull ||
            !DateHelper.is30MinutesDifference(
              widget.lastMessageTime,
              widget.message.createdAt,
            ))
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: lastMessageTimeNull ? 6 : 18,
              bottom: 6,
            ),
            child: Text(
              softWrap: true,
              Formatter.formatMessageTime(
                  widget.message.createdAt, context.locale.languageCode),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),

        /* Message */
        Align(
          alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => _isExpanded.value = !_isExpanded.value,
            child: Stack(
              alignment: AlignmentDirectional.centerStart,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(mine ? 1 : 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: 0.75.sw,
                  ),
                  margin: const EdgeInsets.only(left: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    widget.message.message ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (!mine)
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 11,
                    child: RemoteImage(
                      url: widget.memberAvatars[widget.message.senderId]
                              ?.fullPath ??
                          "",
                      isAvatar: true,
                    ),
                  ),
              ],
            ),
          ),
        ),

        /*  */
        ValueListenableBuilder(
          valueListenable: _isExpanded,
          builder: (context, value, child) => value
              ? AnimatedContainer(
                  duration: Durations.long2,
                  padding: mine
                      ? const EdgeInsets.only(right: 12.0, top: 2)
                      : const EdgeInsets.only(left: 12.0, top: 2),
                  alignment:
                      mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Text(
                    _getSeenText(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )
              : const SizedBox.shrink(),
        ),

        /* List avatar seen */
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 8),
          child: Wrap(
            spacing: 4,
            children: widget.message.seenIds
                .map<Widget>((id) =>
                    (id != widget.myId && widget.memberSeen[id] == widget.idx)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: CircleAvatar(
                              radius: 7,
                              child: AnimatedImage(
                                url: widget.memberAvatars[id]!.fullPath,
                                isAvatar: true,
                              ),
                            ),
                          )
                        : const SizedBox.shrink())
                .toList(),
          ),
        )
      ],
    );
  }
}
