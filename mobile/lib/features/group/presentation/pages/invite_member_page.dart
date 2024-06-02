import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../friend/friend.dart';
import '../blocs/blocs.dart';
import '../widgets/select_member_section.dart';

class InviteMemberPage extends StatefulWidget {
  final int id;

  const InviteMemberPage({super.key, required this.id});

  @override
  State<InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends State<InviteMemberPage> {
  ValueNotifier<List<int>> memberIds = ValueNotifier([]);
  ValueNotifier<List<FriendModel>> members = ValueNotifier([]);

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  void _handleInvite() {
    if (_loading.value) return;

    _loading.value = true;
    context.read<GroupActionBloc>().add(InviteMembersSubmit(
          groupId: widget.id,
          memberIds: memberIds.value,
          members: members.value,
          onError: (msg) {
            _loading.value = false;
            context.showError(message: msg);
          },
          onSuccess: () => Navigator.of(context).pop(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "INVITE_MEMBER_PAGE_TITLE_TEXT".tr(),
      titleStyle: Theme.of(context).textTheme.headlineSmall?.sectionStyle,
      titleSpacing: 0,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: _handleInvite,
          child: ValueListenableBuilder(
            valueListenable: _loading,
            builder: (context, value, child) => value
                ? const AppIndicator(size: 20)
                : Text(
                    "INVITE_TEXT".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  ),
          ),
        ),
        const SizedBox(width: 6),
      ],
      slivers: [
        SliverToBoxAdapter(
          child: SelectMemberSection(
            memberIds: memberIds,
            members: members,
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
      ],
    );
  }
}
