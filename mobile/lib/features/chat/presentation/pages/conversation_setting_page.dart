import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/app/app.dart';
import 'package:sns_deepfake/features/chat/presentation/widgets/conversation_avatar.dart';
import 'package:sns_deepfake/features/news_feed/presentation/widgets/color_separate.dart';

import '../../../../core/utils/utils.dart';
import '../../data/data.dart';
import '../blocs/bloc.dart';
import '../widgets/rename_conversation_form.dart';

class ConversationSettingPage extends StatefulWidget {
  final int id;
  const ConversationSettingPage({super.key, required this.id});

  @override
  State<ConversationSettingPage> createState() =>
      _ConversationSettingPageState();
}

class _ConversationSettingPageState extends State<ConversationSettingPage> {
  late ConversationModel conversation;
  late int myId;

  final ValueNotifier<bool> _deleting = ValueNotifier(false);

  @override
  void initState() {
    myId = context.read<AppBloc>().state.user!.id!;

    conversation =
        (context.read<MyConversationsBloc>().state as SuccessfulState)
            .conversations
            .firstWhere((e) => e.id == widget.id);

    super.initState();
  }

  void _handleDelete() {
    _deleting.value = !_deleting.value;
  }

  void _handleRename() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => RenameConversationForm(
        oldName: conversation.name ?? "",
        id: widget.id,
      ),
    ).then((data) {
      if (data != null) {
        setState(() {
          if (mounted) {
            conversation = conversation.copyWith(
              name: data['name'],
              lastMessageAt: data['lastMessageAt'],
            );
          }
        });
      }
    });
  }

  void _handleSeeMembers() {
    //
  }

  @override
  Widget build(BuildContext context) {
    final isSingle = conversation.type == ConversationType.single;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: isSingle ? _buildSingle() : _buildGroup(),
        ),
      ),
    );
  }

  Widget _buildSingle() {
    final other = conversation.members.firstWhere((e) => e.id != myId);

    return Column(
      children: [
        Center(
          child: BlocBuilder<SocketBloc, SocketState>(
            builder: (context, state) {
              final bool _online = state.online.contains(other.id);
              return ConversationAvatar(
                avatars: [other.avatar?.fullPath ?? ""],
                isOnline: _online,
              );
            },
          ),
        ),

        /*  */
        const SizedBox(height: 16),
        Text(
          other.username ?? other.email,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 22),
        if (conversation.lastMessageAt != null)
          Text(
            DateHelper.isToday(conversation.lastMessageAt!)
                ? "ACTIVE_TODAY_TEXT".tr()
                : "LAST_ACTIVE_TIME_TEXT".tr(namedArgs: {
                    "time": Formatter.formatMessageTime(
                      conversation.lastMessageAt!,
                      context.locale.languageCode,
                    )
                  }),
            style: Theme.of(context).textTheme.labelMedium,
          ),

        /*  */
        const SizedBox(height: 28),
        const ColorSeparate(
          isSliverType: false,
          paddingVertical: 0,
          thickness: 8,
        ),
        ListTile(
          onTap: _handleDelete,
          contentPadding: const EdgeInsets.symmetric(horizontal: 22),
          title: Text(
            "DELETE_CONVERSATION_TEXT".tr(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.redAccent),
          ),
          leading: ValueListenableBuilder(
            valueListenable: _deleting,
            builder: (context, value, child) => value
                ? const AppIndicator(size: 24, color: Colors.redAccent)
                : const Icon(Icons.logout, color: Colors.redAccent, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildGroup() {
    final isOwner = conversation.creatorId == myId;

    return Column(
      children: [
        Center(
          child: BlocBuilder<SocketBloc, SocketState>(
            builder: (context, state) {
              return ConversationAvatar(
                avatars: conversation.getConversationAvatar(myId),
                isOnline: conversation.members
                    .where((member) => member.id != myId)
                    .any((e) => state.online.contains(e.id)),
              );
            },
          ),
        ),

        /*  */
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.15.sw),
          child: Text(
            conversation.getConversationName(myId),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),

        /*  */
        const SizedBox(height: 22),
        if (conversation.lastMessageAt != null)
          Text(
            DateHelper.isToday(conversation.lastMessageAt!)
                ? "ACTIVE_TODAY_TEXT".tr()
                : "LAST_ACTIVE_TIME_TEXT".tr(namedArgs: {
                    "time": Formatter.formatMessageTime(
                      conversation.lastMessageAt!,
                      context.locale.languageCode,
                    )
                  }),
            style: Theme.of(context).textTheme.labelMedium,
          ),

        /*  */
        const SizedBox(height: 22),
        Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade700,
                ),
                padding: const EdgeInsets.all(6),
                child: const Icon(Icons.person_add),
              ),
              const SizedBox(height: 3),
              Text(
                "ADD_MEMBER_TEXT".tr(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),

        /*  */
        const SizedBox(height: 22),
        const ColorSeparate(
          isSliverType: false,
          paddingVertical: 0,
          thickness: 8,
        ),
        /* Rename */
        ListTile(
          onTap: _handleRename,
          contentPadding: const EdgeInsets.symmetric(horizontal: 22),
          title: Text(
            "RENAME_CONVERSATION_TEXT".tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          leading: const Icon(Icons.edit),
        ),
        /* Members */
        ListTile(
          onTap: _handleSeeMembers,
          contentPadding: const EdgeInsets.symmetric(horizontal: 22),
          title: Text(
            "SEE_MEMBER_LIST_TEXT".tr(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          leading: const Icon(Icons.group_sharp),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        /* Delete */
        ListTile(
          onTap: _handleDelete,
          contentPadding: const EdgeInsets.symmetric(horizontal: 22),
          title: Text(
            isOwner
                ? "DISPERSE_CONVERSATION_TEXT".tr()
                : "LEAVE_CONVERSATION_TEXT".tr(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.redAccent),
          ),
          leading: ValueListenableBuilder(
            valueListenable: _deleting,
            builder: (context, value, child) => value
                ? const AppIndicator(size: 24, color: Colors.redAccent)
                : const Icon(Icons.logout, color: Colors.redAccent, size: 24),
          ),
        ),
      ],
    );
  }
}
