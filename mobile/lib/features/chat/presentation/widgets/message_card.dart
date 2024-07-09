import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/data.dart';
import 'conversation_avatar.dart';

class MessageCard extends StatefulWidget {
  final MessageModel message;
  final String lastMessageTime;
  final int myId;
  final int idx;
  final Map<int, String> memberAvatars;
  final Map<int, String> memberNames;
  final Map<int, int> memberSeen;
  final Function(MessageModel) onReply;

  const MessageCard({
    super.key,
    required this.message,
    required this.myId,
    required this.lastMessageTime,
    required this.memberAvatars,
    required this.memberSeen,
    required this.memberNames,
    required this.idx,
    required this.onReply,
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
        if (widget.myId != id &&
            widget.memberSeen[id] != null &&
            widget.memberSeen[id]! <= widget.idx) {
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

    final bool isMediaMessage = widget.message.type == MessageType.media;
    final bool replying = widget.message.reply != null;

    return widget.message.type == MessageType.system
        ? Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                if (widget.message.message == "CREATED")
                  ConversationAvatar(
                    avatars: widget.memberAvatars.values
                        .map((e) => e.fullPath)
                        .toList(),
                    isOnline: false,
                  ),
                const SizedBox(height: 8),
                Text(
                  AppMappers.getSystemMessageWithInfo(
                    widget.message.message!,
                    widget.memberNames[widget.message.senderId] ?? "",
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          )
        : Column(
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
                  child: Dismissible(
                    key: ValueKey(widget.message.id),
                    confirmDismiss: (direction) {
                      widget.onReply(widget.message);
                      return Future.value(false);
                    },
                    background: Center(
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: context.minBackgroundColor(),
                        child: Icon(Icons.reply, color: context.minTextColor()),
                      ),
                    ),
                    direction: mine
                        ? DismissDirection.endToStart
                        : DismissDirection.startToEnd,
                    child: Stack(
                      alignment: mine
                          ? AlignmentDirectional.centerEnd
                          : AlignmentDirectional.centerStart,
                      children: [
                        if (replying)
                          Container(
                            decoration: BoxDecoration(
                              color: context.minBackgroundColor(),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: mine
                                    ? const Radius.circular(12)
                                    : Radius.zero,
                                bottomRight: !mine
                                    ? const Radius.circular(12)
                                    : Radius.zero,
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 18),
                            margin: EdgeInsets.only(
                              bottom: (8 + 8 + 13.sp),
                              left: 12,
                            ),
                            child: Text(
                              widget.message.reply!.message ?? "",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),

                        /*  */
                        Container(
                          decoration: isMediaMessage
                              ? null
                              : BoxDecoration(
                                  color: mine
                                      ? AppColors.kPrimaryColor
                                      : const Color.fromRGBO(48, 48, 48, 1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                          constraints: BoxConstraints(
                            maxWidth: 0.75.sw,
                          ),
                          margin: EdgeInsets.only(
                            left: 12,
                            top: replying ? (8 + 24 + 12.sp) / 2 : 0,
                          ),
                          padding: isMediaMessage
                              ? EdgeInsets.zero
                              : const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                          child: _mapMessageType(),
                        ),

                        /*  */
                        if (!mine)
                          Positioned(
                            bottom: replying ? 14 : 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 11,
                              child: RemoteImage(
                                url: widget
                                        .memberAvatars[widget.message.senderId]
                                        ?.fullPath ??
                                    "",
                                isAvatar: true,
                              ),
                            ),
                          ),
                      ],
                    ),
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
                      .map<Widget>((id) => (id != widget.myId &&
                              widget.memberSeen[id] == widget.idx)
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

  Widget _mapMessageType() {
    switch (widget.message.type) {
      case MessageType.text:
        return Text(
          widget.message.message ?? "",
          style: Theme.of(context).textTheme.bodyMedium,
        );
      case MessageType.media:
        return Wrap(
          children: widget.message.attachments.map((e) {
            if (fileIsVideo(e)) {
              return AppVideo(e.fullPath, isNetwork: true);
            } else {
              return AnimatedImage(url: e.fullPath, radius: 12);
            }
          }).toList(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
