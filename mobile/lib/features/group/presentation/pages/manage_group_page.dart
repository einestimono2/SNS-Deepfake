import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/libs/libs.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../app/bloc/bloc.dart';
import '../blocs/blocs.dart';
import '../widgets/edit_group_form.dart';
import '../widgets/group_member_card.dart';

class ManageGroupPage extends StatefulWidget {
  final int id;
  final bool isMyGroup;

  const ManageGroupPage({
    super.key,
    required this.id,
    required this.isMyGroup,
  });

  @override
  State<ManageGroupPage> createState() => _ManageGroupPageState();
}

class _ManageGroupPageState extends State<ManageGroupPage> {
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  late int myId;

  @override
  void initState() { 
    myId = context.read<AppBloc>().state.user!.id!;
    super.initState();
  }

  void _handleEdit(BuildContext context, GroupActionState state) {
    bool successState = state is GroupActionSuccessfulState;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => EditGroupForm(
        groupName: successState ? state.group!.groupName ?? "" : "",
        description: successState ? state.group!.description ?? "" : "",
        id: widget.id,
      ),
    );
  }

  void _handleDeleteGroup(BuildContext context) async {
    if (_loading.value) return;

    bool? deleted = await showAppAlertDialog(
      context: context,
      title: "DELETE_GROUP_DIALOG_TITLE_TEXT".tr(),
      content: "DELETE_GROUP_DIALOG_CONTENT_TEXT".tr(),
      onOK: () => Navigator.of(context, rootNavigator: true).pop(true),
    );

    if (deleted == true) {
      _loading.value = true;

      // ignore: use_build_context_synchronously
      context.read<GroupActionBloc>().add(DeleteGroupSubmit(
            groupId: widget.id,
            onError: (msg) {
              _loading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () => context
              ..pop()
              ..pop(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupActionBloc, GroupActionState>(
      builder: (context, state) {
        bool success = state is GroupActionSuccessfulState;

        return SliverPage(
          title: success
              ? state.group!.groupName
              : "MANAGE_GROUP_PAGE_TITLE_TEXT".tr(),
          titleStyle: Theme.of(context).textTheme.headlineSmall?.sectionStyle,
          titleSpacing: 0,
          slivers: [
            SliverList.list(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        title: "ABOUT_TEXT".tr(),
                        onShowMore: widget.isMyGroup
                            ? () => _handleEdit(context, state)
                            : null,
                        showMoreText: "EDIT_TEXT".tr(),
                      ),

                      /*  */
                      if (success)
                        AnimatedSize(
                          duration: const Duration(milliseconds: 100),
                          alignment: Alignment.topCenter,
                          child: ReadMoreText(
                            state.group?.description ?? "",
                            trimMode: TrimMode.line,
                            trimLines: 4,
                            autoHandleOnClick: true,
                            trimExpandedText: "",
                            trimCollapsedText: "SEE_MORE_TEXT".tr(),
                            colorClickableText: Colors.grey,
                            style: const TextStyle(height: 1.15),
                          ),
                        )
                    ],
                  ),
                ),

                /*  */
                const SizedBox(height: 16),
                SectionTitle(
                  showTopSeparate: true,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  title: "GROUP_MEMBER_TEXT".tr(),
                ),
                if (success)
                  ListView.builder(
                    itemBuilder: (context, index) => GroupMemberCard(
                      member: state.group!.members[index],
                      ownerId: state.group!.creatorId,
                      groupId: state.group!.id,
                      myId: myId,
                      isMyGroup: widget.isMyGroup,
                    ),
                    itemCount: state.group!.members.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  ),

                /*  */
                const SizedBox(height: 32),
                if (widget.isMyGroup)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => _handleDeleteGroup(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.minBackgroundColor(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _loading,
                                builder: (context, value, child) => value
                                    ? const AppIndicator(size: 36)
                                    : const Icon(Icons.output, size: 36),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "DELETE_GROUP_DIALOG_TITLE_TEXT".tr(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
