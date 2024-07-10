import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/extensions/toast_notification.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/chat/chat.dart';

import '../../../friend/data/data.dart';
import '../../../group/presentation/widgets/select_member_section.dart';

class ModalAddConversationMember extends StatefulWidget {
  final int id;

  const ModalAddConversationMember({super.key, required this.id});

  @override
  State<ModalAddConversationMember> createState() =>
      _ModalAddConversationMemberState();
}

class _ModalAddConversationMemberState
    extends State<ModalAddConversationMember> {
  final FocusNode _searchFN = FocusNode();
  final ValueNotifier<List<int>> _memberIds = ValueNotifier([]);
  final ValueNotifier<List<FriendModel>> _members = ValueNotifier([]);

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  @override
  void dispose() {
    _searchFN.dispose();
    super.dispose();
  }

  void _handleAdd() {
    _searchFN.unfocus();
    if (_loading.value) return;

    _loading.value = true;
    context.read<ConversationDetailsBloc>().add(AddMemberSubmit(
          id: widget.id,
          memberIds: _memberIds.value,
          onSuccess: (members) {
            _loading.value = false;
            Navigator.of(context, rootNavigator: true).pop(members);
          },
          onError: (msg) {
            _loading.value = false;
            context.showError(message: msg);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    final btnWidth = (1.sw - 16 * 2) / 2 - 6;

    return GestureDetector(
      onTap: () => _searchFN.unfocus(),
      child: Container(
        constraints: BoxConstraints(
          // minHeight: 0.5.sh,
          maxHeight: 0.85.sh,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*  */
            SingleChildScrollView(
              child: SelectMemberSection(
                memberIds: _memberIds,
                members: _members,
                focusNode: _searchFN,
              ),
            ),

            /*  */
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _loading.value
                      ? null
                      : Navigator.of(context, rootNavigator: true).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent.shade200,
                    side: BorderSide.none,
                    fixedSize: Size(btnWidth, 54),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "CANCEL_TEXT".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ),

                /*  */
                ValueListenableBuilder(
                  valueListenable: _memberIds,
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: value.isEmpty ? null : _handleAdd,
                    style: ElevatedButton.styleFrom(
                      side: BorderSide.none,
                      fixedSize: Size(btnWidth, 54),
                      padding: EdgeInsets.zero,
                    ),
                    child: ValueListenableBuilder(
                      valueListenable: _loading,
                      builder: (context, value, child) => value
                          ? const AppIndicator(size: 24)
                          : Text(
                              "ADD_MEMBER_TEXT".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),

            /*  */
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
