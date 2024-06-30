import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../../chat.dart';
import 'conversation_avatar.dart';

class ConversationCard extends StatelessWidget {
  final ConversationModel conversation;
  final int myId;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.myId,
  });

  bool isOnline(List<int> listOnline) {
    if (listOnline.isEmpty) return false;

    final others =
        conversation.members.where((member) => member.id != myId).toList();
    if (conversation.type == ConversationType.group) {
      return others.any((user) => listOnline.contains(user.id));
    } else {
      return listOnline.contains(others.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = conversation.isReadNewestMessage(myId);
    final avatars = conversation.getConversationAvatar(myId);

    return InkWell(
      onTap: () => context.goNamed(
        Routes.conversation.name,
        pathParameters: {"id": conversation.id.toString()},
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            /* Avatar */
            BlocBuilder<SocketBloc, SocketState>(
              builder: (context, state) {
                return ConversationAvatar(
                  avatars: avatars,
                  isOnline: isOnline(state.online),
                );
              },
            ),

            /* Info */
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    conversation.getConversationName(myId),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 1),
                  BlocBuilder<MessageBloc, MessageState>(
                    builder: (context, state) {
                      return state.isTyping &&
                              state.conversationId == conversation.id
                          ? _typingStatus(context, state.members)
                          : Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    conversation.getNewestMessage(myId),
                                    style: isRead
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: context.minTextColor(),
                                            )
                                        : Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.color,
                                            ),
                                  ),
                                ),
                                Text(
                                  " ${AppTexts.appSeparateIcon} ${conversation.getConversationTime(context.locale.languageCode)}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            );
                    },
                  ),
                ],
              ),
            ),

            /* Avatar Seen - Trường hợp chat riêng*/
            if (!isRead)
              const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.blueAccent,
              )
            else if (conversation.isReadNewestMessageByOther(myId))
              CircleAvatar(
                radius: 7,
                child: AnimatedImage(url: avatars[0], isAvatar: true),
              )
          ],
        ),
      ),
    );
  }

  Row _typingStatus(BuildContext context, Set<int> members) {
    return Row(
      children: [
        ...conversation.members.map((e) {
          return (e.id == myId || !members.contains(e.id))
              ? const SizedBox.shrink()
              : Align(
                  widthFactor: 0.5,
                  child: AnimatedImage(
                    width: 14,
                    height: 14,
                    isAvatar: true,
                    url: e.avatar?.fullPath ?? "",
                  ),
                );
        }),
        const SizedBox(width: 8),
        Text("TYPING_WITH_DOTS_TEXT".plural(members.length),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                )),
      ],
    );
  }
}

class ShimmerConversationCard extends StatelessWidget {
  const ShimmerConversationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: AppColors.shimmerGradient,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => SizedBox(height: 3.h),
        itemCount: 10,
        itemBuilder: (_, i) => _shimmerCard(),
      ),
    );
  }

  Widget _shimmerCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Skeleton(
            width: 0.165.sw,
            height: 0.165.sw,
            isAvatar: true,
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Skeleton(height: 16.sp, width: 0.35.sw),
              const SizedBox(height: 3),
              Row(
                children: [
                  Skeleton(height: 14.sp, width: 0.5.sw),
                  const SizedBox(width: 3),
                  Skeleton(height: 14.sp, width: 0.1.sw),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
