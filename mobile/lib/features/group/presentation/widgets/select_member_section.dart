import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../friend/friend.dart';
import '../../../search/search.dart';

class SelectMemberSection extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final ValueNotifier<List<FriendModel>> members;
  final ValueNotifier<List<int>> memberIds;
  final FocusNode? focusNode;
  final bool initFocus;

  const SelectMemberSection({
    super.key,
    this.padding,
    this.focusNode,
    this.initFocus = false,
    required this.memberIds,
    required this.members,
  });

  @override
  State<SelectMemberSection> createState() => _SelectMemberSectionState();
}

class _SelectMemberSectionState extends State<SelectMemberSection> {
  Timer? _debounce;
  final ValueNotifier<bool> _isTyping = ValueNotifier(false);
  final TextEditingController _ctl = TextEditingController();

  @override
  void initState() {
    context.read<SearchUserBloc>().add(ResetState());
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _handleSearch(String keyword) {
    context
        .read<SearchUserBloc>()
        .add(SearchUserSubmit(keyword: keyword, saveHistory: false));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /* Search Box */
        Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: SearchBar(
            backgroundColor: MaterialStatePropertyAll<Color>(
              context.minBackgroundColor(),
            ),
            textInputAction: TextInputAction.search,
            focusNode: widget.focusNode,
            controller: _ctl,
            autoFocus: widget.initFocus && widget.focusNode != null,
            leading: const Icon(Icons.search),
            hintText: "SEARCH_USER_WITH_NAME_OR_EMAIL_TEXT".tr(),
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(Durations.medium2, () {
                _isTyping.value = _ctl.text.isNotEmpty;

                _handleSearch(value);
              });
            },
            onSubmitted: (_) => widget.focusNode?.unfocus(),
            trailing: [
              ValueListenableBuilder(
                valueListenable: _isTyping,
                builder: (context, value, child) {
                  return value
                      ? IconButton(
                          onPressed: () {
                            _ctl.clear();
                            _isTyping.value = false;
                            _handleSearch("");
                          },
                          icon: const Icon(Icons.close),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),

        /* Selected members */
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: widget.padding ?? EdgeInsets.zero,
          width: double.infinity,
          child: ValueListenableBuilder(
            valueListenable: widget.members,
            builder: (context, _members, child) {
              return Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  for (int idx = 0; idx < _members.length; idx++)
                    SelectedMemberCard(
                      member: _members[idx],
                      onDelete: () {
                        widget.members.value = widget.members.value.toList()
                          ..removeAt(idx);
                        widget.memberIds.value = widget.memberIds.value.toList()
                          ..removeAt(idx);
                      },
                    )
                ],
              );
            },
          ),
        ),

        /* Results */
        ValueListenableBuilder(
          valueListenable: widget.memberIds,
          builder: (context, ids, child) {
            return BlocBuilder<SearchUserBloc, SearchUserState>(
              builder: (context, state) {
                if (state is SUInitialState) {
                  return _listSuggest();
                }

                if (state is SUInProgressState) {
                  return const AppIndicator();
                }

                if (state is SUSuccessfulState && state.users.isNotEmpty) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: widget.padding ?? EdgeInsets.zero,
                        child: Divider(
                          color: context.minBackgroundColor(),
                        ),
                      ),

                      /*  */
                      for (int idx = 0; idx < state.users.length; idx++)
                        SelectingMemberCard(
                          member: state.users[idx],
                          isSelected: ids.contains(state.users[idx].id),
                          onClick: () {
                            int pos = ids.indexOf(state.users[idx].id);
                            if (pos == -1) {
                              widget.memberIds.value = widget.memberIds.value
                                  .toList()
                                ..add(state.users[idx].id);
                              widget.members.value = widget.members.value
                                  .toList()
                                ..add(state.users[idx]);
                            } else {
                              widget.memberIds.value = widget.memberIds.value
                                  .toList()
                                ..removeAt(pos);
                              widget.members.value =
                                  widget.members.value.toList()..removeAt(pos);
                            }
                          },
                        ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _listSuggest() {
    return BlocBuilder<ListFriendBloc, ListFriendState>(
      builder: (context, state) {
        if (state is LFSuccessfulState) {
          return Column(
            children: [
              ValueListenableBuilder(
                valueListenable: widget.memberIds,
                builder: (context, ids, child) => Column(
                  children: [
                    SectionTitle(
                      margin: widget.padding ?? EdgeInsets.zero,
                      title: "SUGGESTIONS_TEXT".tr(),
                    ),

                    /*  */
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.friends.length,
                      itemBuilder: (context, idx) => SelectingMemberCard(
                        member: state.friends[idx],
                        isSelected: ids.contains(state.friends[idx].id),
                        onClick: () {
                          int pos = ids.indexOf(state.friends[idx].id);
                          if (pos == -1) {
                            widget.memberIds.value = widget.memberIds.value
                                .toList()
                              ..add(state.friends[idx].id);
                            widget.members.value = widget.members.value.toList()
                              ..add(state.friends[idx]);
                          } else {
                            widget.memberIds.value =
                                widget.memberIds.value.toList()..removeAt(pos);
                            widget.members.value = widget.members.value.toList()
                              ..removeAt(pos);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class SelectingMemberCard extends StatelessWidget {
  final FriendModel member;
  final VoidCallback onClick;
  final bool isSelected;

  const SelectingMemberCard({
    super.key,
    required this.member,
    required this.onClick,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onClick,
      leading: AnimatedImage(
        isAvatar: true,
        url: member.avatar?.fullPath ?? "",
      ),
      title: Text(
        member.username ?? "",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: member.sameFriends > 0
          ? Text(
              "MUTUAL_FRIENDS_TEXT".plural(member.sameFriends),
              style: Theme.of(context).textTheme.labelMedium,
            )
          : null,
      trailing: Checkbox.adaptive(
        shape: const CircleBorder(),
        value: isSelected,
        onChanged: (_) => onClick.call(),
      ),
    );
  }
}

class SelectedMemberCard extends StatelessWidget {
  final FriendModel member;
  final VoidCallback onDelete;

  const SelectedMemberCard({
    super.key,
    required this.member,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.2.sw,
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedImage(
                url: member.avatar?.fullPath ?? "",
                isAvatar: true,
                width: 0.15.sw,
                height: 0.15.sw,
              ),
              const SizedBox(height: 6),
              Text(
                member.username ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(3),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: Colors.redAccent.withOpacity(0.85),
              ),
              onPressed: onDelete,
              icon: const Icon(Icons.close, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
