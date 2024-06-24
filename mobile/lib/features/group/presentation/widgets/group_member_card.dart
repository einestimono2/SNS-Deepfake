import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/extensions/image_path.dart';
import 'package:sns_deepfake/core/utils/extensions/toast_notification.dart';

import '../../../../config/configs.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../chat/data/models/member_model.dart';
import '../blocs/blocs.dart';

class GroupMemberCard extends StatefulWidget {
  final MemberModel member;
  final int ownerId;
  final int groupId;
  final int myId;
  final bool isMyGroup;

  const GroupMemberCard({
    super.key,
    required this.member,
    required this.ownerId,
    required this.myId,
    required this.groupId,
    required this.isMyGroup,
  });

  @override
  State<GroupMemberCard> createState() => _GroupMemberCardState();
}

class _GroupMemberCardState extends State<GroupMemberCard> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);

  void _handleDelete() {
    if (_loading.value) return;

    _loading.value = true;
    context.read<GroupActionBloc>().add(DeleteMembersSubmit(
          groupId: widget.groupId,
          memberIds: [widget.member.id],
          onSuccess: () => _loading.value = false,
          onError: (msg) {
            _loading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    bool owner = widget.member.id == widget.ownerId;

    return ListTile(
      onTap: () => widget.member.id == widget.myId
          ? context.pushNamed(Routes.myProfile.name)
          : context.pushNamed(
              Routes.otherProfile.name,
              pathParameters: {"id": widget.member.id.toString()},
              extra: {'username': widget.member.username},
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      leading: AnimatedImage(
        url: widget.member.avatar?.fullPath ?? "",
        isAvatar: true,
        width: 0.125.sw,
        height: 0.125.sw,
      ),
      title: Text(
        widget.member.username ?? widget.member.email,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: owner
          ? Row(
              children: [
                const Icon(FontAwesomeIcons.shield, size: 12),
                const SizedBox(width: 4),
                Text(
                  "ADMIN_TEXT".tr(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            )
          : null,
      trailing: (widget.isMyGroup && !owner)
          ? IconButton(
              onPressed: _handleDelete,
              icon: ValueListenableBuilder(
                valueListenable: _loading,
                builder: (context, value, child) => value
                    ? const AppIndicator(size: 18)
                    : const Icon(
                        FontAwesomeIcons.rightFromBracket,
                        size: 16,
                        color: Colors.redAccent,
                      ),
              ),
            )
          : null,
    );
  }
}
