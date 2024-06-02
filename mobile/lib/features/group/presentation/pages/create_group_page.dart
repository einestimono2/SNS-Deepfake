import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_deepfake/core/utils/utils.dart';
import 'package:sns_deepfake/features/group/presentation/blocs/blocs.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../friend/data/models/friend.model.dart';
import '../widgets/select_member_section.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  final ValueNotifier<String?> _cover = ValueNotifier(null);
  final ValueNotifier<List<int>> _memberIds = ValueNotifier([]);
  final ValueNotifier<List<FriendModel>> _members = ValueNotifier([]);

  final FocusNode _nameFN = FocusNode();
  final FocusNode _descriptionFN = FocusNode();
  final FocusNode _searchFN = FocusNode();

  void _handleCreateGroup() {
    if (_loading.value) return;

    if (_formKey.currentState!.validate() && _name.text.isNotEmpty) {
      _loading.value = true;

      context.read<GroupActionBloc>().add(CreateGroupSubmit(
            name: _name.text,
            description: _description.text,
            coverPhoto: _cover.value,
            memberIds: _memberIds.value,
            members: _members.value,
            onError: (msg) {
              _loading.value = false;
              context.showError(message: msg);
            },
            onSuccess: () => context.pop(),
          ));
    }
  }

  @override
  void dispose() {
    _nameFN.dispose();
    _descriptionFN.dispose();
    _searchFN.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPage(
      title: "CREATE_GROUP_PAGE_TITLE_TEXT".tr(),
      physic: const NeverScrollableScrollPhysics(),
      centerTitle: true,
      slivers: [
        SliverFillRemaining(
          child: GestureDetector(
            onTap: () => _searchFN.unfocus(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: _content()),
                _btnCreateGroup(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* Cover photo */
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 0.25.sh,
                child: ValueListenableBuilder(
                  valueListenable: _cover,
                  builder: (context, coverImage, child) => coverImage != null
                      ? RemoteImage(url: coverImage.fullPath)
                      : const LocalImage(path: AppImages.imagePlaceholder),
                ),
              ),
              Positioned(
                right: 6.w,
                top: 0.25.sh - 16.r * 2 - 6.w,
                child: Row(
                  children: [
                    Text(
                      "GROUP_COVER_PHOTO_TEXT".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.black),
                    ),
                    const SizedBox(width: 8),
                    UploadButton(
                      size: 16.r,
                      id: "GROUP_COVER_PHOTO",
                      onCompleted: (url, id) =>
                          id == "GROUP_COVER_PHOTO" ? _cover.value = url : null,
                      icon: FontAwesomeIcons.camera,
                    ),
                  ],
                ),
              ),
            ],
          ),

          /* Group Name + Description  */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /* Tên nhóm */
                  SectionTitle(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    title: "* ${"GROUP_NAME_TEXT".tr()}",
                  ),
                  TextFormField(
                    onTap: () => _nameFN.requestFocus(),
                    onTapOutside: (_) => _nameFN.unfocus(),
                    textInputAction: TextInputAction.next,
                    focusNode: _nameFN,
                    controller: _name,
                    validator: AppValidations.validateGroupName,
                    onFieldSubmitted: (_) => _descriptionFN.requestFocus(),
                    decoration: InputDecoration(
                      hintText: "GROUP_NAME_HINT_TEXT".tr(),
                    ),
                  ),

                  /* Group Description  */
                  SectionTitle(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    title: "GROUP_DESCRIPTION_TEXT".tr(),
                  ),
                  TextFormField(
                    onTap: () => _descriptionFN.requestFocus(),
                    onTapOutside: (_) => _descriptionFN.unfocus(),
                    textInputAction: TextInputAction.next,
                    focusNode: _descriptionFN,
                    controller: _description,
                    minLines: 3,
                    maxLines: null,
                    onFieldSubmitted: (_) => _searchFN.requestFocus(),
                    decoration: InputDecoration(
                      hintText: "GROUP_DESCRIPTION_HINT_TEXT".tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /* Members */
          SectionTitle(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            title: "GROUP_MEMBER_TEXT".tr(),
          ),
          SelectMemberSection(
            memberIds: _memberIds,
            members: _members,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            focusNode: _searchFN,
          ),

          /*  */
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  InkWell _btnCreateGroup(BuildContext context) {
    return InkWell(
      onTap: _handleCreateGroup,
      child: Container(
        color: context.minBackgroundColor(),
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        alignment: Alignment.center,
        child: ValueListenableBuilder(
          valueListenable: _loading,
          builder: (context, value, child) => value
              ? AppIndicator(size: 19.sp)
              : Text(
                  "CREATE_GROUP_TEXT".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: context.minTextColor()),
                ),
        ),
      ),
    );
  }
}
