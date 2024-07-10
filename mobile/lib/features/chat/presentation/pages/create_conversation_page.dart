import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/core/widgets/widgets.dart';
import 'package:sns_deepfake/features/chat/chat.dart';
import 'package:sns_deepfake/features/chat/presentation/presentation.dart';

import '../../../../config/configs.dart';
import '../../../friend/friend.dart';
import '../../../group/presentation/widgets/select_member_section.dart';

class CreateConversationPage extends StatefulWidget {
  const CreateConversationPage({super.key});

  @override
  State<CreateConversationPage> createState() => _CreateConversationPageState();
}

class _CreateConversationPageState extends State<CreateConversationPage> {
  final FocusNode _nameFN = FocusNode();
  final TextEditingController _nameController = TextEditingController();

  final FocusNode _searchFN = FocusNode();
  final ValueNotifier<List<int>> _memberIds = ValueNotifier([]);
  final ValueNotifier<List<FriendModel>> _members = ValueNotifier([]);

  final btnController = AnimatedButtonController();

  @override
  void dispose() {
    _nameFN.dispose();
    _searchFN.dispose();
    super.dispose();
  }

  void _handleCreate() {
    btnController.play();

    if (_memberIds.value.length == 1) {
      context
          .read<ConversationDetailsBloc>()
          .add(GetSingleConversationByMembers(
            targetId: _memberIds.value.first,
            onSuccess: (id) => context
              ..pop()
              ..goNamed(
                Routes.conversation.name,
                pathParameters: {"id": id.toString()},
                extra: {
                  "id": _members.value.first.id,
                  "avatar": _members.value.first.avatar,
                  "username": _members.value.first.username,
                },
              ),
            onError: (msg) {
              context.showError(message: msg);
              btnController.reverse();
            },
          ));
    } else {
      context.read<ConversationDetailsBloc>().add(CreateGroupChatSubmit(
            name: _nameController.text,
            memberIds: _memberIds.value,
            onSuccess: (id) =>
                // Delay thêm tý sợ trường hợp chưa handle socket event kịp
                Future.delayed(Durations.long4).then((_) => context
                  ..pop()
                  ..goNamed(
                    Routes.conversation.name,
                    pathParameters: {"id": id.toString()},
                  )),
            onError: (msg) {
              context.showError(message: msg);
              btnController.reverse();
            },
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _searchFN.unfocus(),
      child: Scaffold(
        body: SliverPage(
          title: "CREATE_CONVERSATION_TITLE_TEXT".tr(),
          centerTitle: true,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.list(
                children: [
                  /* Members */
                  SectionTitle(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    title: "CONVERSATION_MEMBERS_TEXT".tr(),
                  ),
                  SelectMemberSection(
                    memberIds: _memberIds,
                    members: _members,
                    focusNode: _searchFN,
                    initFocus: true,
                  ),

                  /*  */
                  ValueListenableBuilder(
                    valueListenable: _memberIds,
                    builder: (context, value, child) => Column(
                      children: [
                        if (value.length > 1)
                          /* Tên nhóm */
                          SectionTitle(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            title: "CONVERSATION_NAME_TEXT".tr(),
                          ),
                        if (value.length > 1)
                          TextFormField(
                            onTap: () => _nameFN.requestFocus(),
                            onTapOutside: (_) => _nameFN.unfocus(),
                            textInputAction: TextInputAction.next,
                            focusNode: _nameFN,
                            controller: _nameController,
                            onFieldSubmitted: (_) => _nameFN.unfocus(),
                            decoration: InputDecoration(
                              hintText: "CONVERSATION_NAME_HINT_TEXT".tr(),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),

                        /*  */
                        const SizedBox(height: 36),
                        if (value.isNotEmpty)
                          AnimatedButton(
                            height: 36.h,
                            title: "CREATE_TEXT".tr(),
                            onPressed: _handleCreate,
                            controller: btnController,
                          ),
                      ],
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
}
