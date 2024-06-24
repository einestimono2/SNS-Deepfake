// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/group/group.dart';

import '../../../../../core/base/base.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../app/bloc/bloc.dart';
import '../../../../chat/data/data.dart';
import '../../../../friend/data/data.dart';

part 'group_action_event.dart';
part 'group_action_state.dart';

class GroupActionBloc extends Bloc<GroupActionEvent, GroupActionState> {
  final CreateGroupUC createGroupUC;
  final UpdateGroupUC updateGroupUC;
  final GetGroupDetailsUC getGroupDetailsUC;
  final InviteMemberUC inviteMemberUC;
  final DeleteMemberUC deleteMemberUC;
  final DeleteGroupUC deleteGroupUC;
  final LeaveGroupUC leaveGroupUC;

  final AppBloc appBloc;
  final GroupPostBloc groupPostBloc;

  GroupActionBloc({
    required this.createGroupUC,
    required this.updateGroupUC,
    required this.getGroupDetailsUC,
    required this.inviteMemberUC,
    required this.deleteMemberUC,
    required this.deleteGroupUC,
    required this.leaveGroupUC,
    required this.appBloc,
    required this.groupPostBloc,
  }) : super(GroupActionInitialState()) {
    on<CreateGroupSubmit>(_onCreateGroupSubmit);
    on<InviteMembersSubmit>(_onInviteMembersSubmit);
    on<DeleteMembersSubmit>(_onDeleteMembersSubmit);
    on<LeaveGroupSubmit>(_onLeaveGroupSubmit);
    on<DeleteGroupSubmit>(_onDeleteGroupSubmit);
    on<GetGroupDetails>(_onGetGroupDetails);
    on<UpdateGroupSubmit>(_onUpdateGroupSubmit);
  }

  FutureOr<void> _onCreateGroupSubmit(
    CreateGroupSubmit event,
    Emitter<GroupActionState> emit,
  ) async {
    final result = await createGroupUC(
      CreateGroupParams(
        name: event.name,
        description: event.description,
        memberIds: event.memberIds,
        coverPhoto: event.coverPhoto,
      ),
    );

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        List<GroupModel> groups = appBloc.state.groups;

        groups.insert(
          0,
          GroupModel(
            id: data.data["id"],
            creatorId: int.parse(data.data["creatorId"].toString()),
            createdAt: data.data['createdAt'],
            groupName: data.data['groupName'],
            description: data.data['description'],
            coverPhoto: data.data['coverPhoto'],
            members: event.members
                .map((e) => MemberModel.fromFriendModel(e))
                .toList(),
          ),
        );

        appBloc.state.copyWith(user: appBloc.state.user, groups: groups);

        event.onSuccess.call();
      },
    );
  }

  FutureOr<void> _onGetGroupDetails(
    GetGroupDetails event,
    Emitter<GroupActionState> emit,
  ) async {
    emit(GroupActionInProgressState());

    final result = await getGroupDetailsUC(GetGroupDetailsParams(event.id));

    result.fold(
      (failure) => emit(GroupActionFailureState(failure.toString())),
      (data) {
        emit(GroupActionSuccessfulState(group: data));

        groupPostBloc.add(GetListPost(
          groupId: event.id,
          page: 1,
          size: AppStrings.listPostPageSize,
        ));
      },
    );
  }

  FutureOr<void> _onUpdateGroupSubmit(
    UpdateGroupSubmit event,
    Emitter<GroupActionState> emit,
  ) async {
    if (state is! GroupActionSuccessfulState ||
        (event.coverPhoto == null &&
            event.name == null &&
            event.description == null)) {
      return;
    }

    final preState = state as GroupActionSuccessfulState;

    final result = await updateGroupUC(UpdateGroupParams(
      id: event.id,
      name: event.name,
      description: event.description,
      coverPhoto: event.coverPhoto,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        GroupModel updatedGroup = preState.group!.copyWith(
          groupName: event.name,
          description: event.description,
          coverPhoto: data.coverPhoto,
        );

        emit(preState.copyWith(
          timestamp: DateTime.now().millisecondsSinceEpoch,
          group: updatedGroup,
        ));

        event.onSuccess();

        appBloc.emit(appBloc.state.copyWith(
          timestamp: DateTime.now().millisecondsSinceEpoch,
          user: appBloc.state.user,
          groups: appBloc.state.groups
              .map((e) => e.id == event.id ? updatedGroup : e)
              .toList(),
        ));
      },
    );
  }

  FutureOr<void> _onInviteMembersSubmit(
    InviteMembersSubmit event,
    Emitter<GroupActionState> emit,
  ) async {
    if (state is! GroupActionSuccessfulState) return;

    final preState = state as GroupActionSuccessfulState;

    final result = await inviteMemberUC(InviteMemberParams(
      memberIds: event.memberIds,
      groupId: event.groupId,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        List<MemberModel> _members = [
          ...preState.group!.members,
          ...event.members.map((e) => MemberModel.fromFriendModel(e))
        ];

        emit(preState.copyWith(
          timestamp: DateTime.now().millisecondsSinceEpoch,
          group: preState.group!.copyWith(members: _members),
        ));

        event.onSuccess();

        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user,
          groups: appBloc.state.groups
              .map((e) =>
                  e.id == event.groupId ? e.copyWith(members: _members) : e)
              .toList(),
        ));
      },
    );
  }

  FutureOr<void> _onDeleteMembersSubmit(
    DeleteMembersSubmit event,
    Emitter<GroupActionState> emit,
  ) async {
    if (state is! GroupActionSuccessfulState) return;

    final preState = state as GroupActionSuccessfulState;

    final result = await deleteMemberUC(DeleteMemberParams(
      memberIds: event.memberIds,
      groupId: event.groupId,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        List<MemberModel> _members = preState.group!.members;

        _members.removeWhere((e) => event.memberIds.contains(e.id));

        emit(preState.copyWith(
          timestamp: DateTime.now().millisecondsSinceEpoch,
          group: preState.group!.copyWith(members: _members),
        ));

        event.onSuccess.call();

        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user,
          groups: appBloc.state.groups
              .map((e) =>
                  e.id == event.groupId ? e.copyWith(members: _members) : e)
              .toList(),
        ));
      },
    );
  }

  FutureOr<void> _onDeleteGroupSubmit(
    DeleteGroupSubmit event,
    Emitter<GroupActionState> emit,
  ) async {
    if (state is! GroupActionSuccessfulState) return;

    final result = await deleteGroupUC(IdParams(event.groupId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        final _groups = appBloc.state.groups;
        _groups.removeWhere((e) => e.id == event.groupId);

        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user,
          groups: _groups,
        ));

        event.onSuccess.call();
        emit(GroupActionInitialState());
      },
    );
  }

  FutureOr<void> _onLeaveGroupSubmit(
    LeaveGroupSubmit event,
    Emitter<GroupActionState> emit,
  ) async {
    if (state is! GroupActionSuccessfulState) return;

    final result = await leaveGroupUC(IdParams(event.groupId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (data) {
        final _groups = appBloc.state.groups;
        _groups.removeWhere((e) => e.id == event.groupId);

        appBloc.emit(appBloc.state.copyWith(
          user: appBloc.state.user,
          groups: _groups,
        ));

        event.onSuccess.call();
        emit(GroupActionInitialState());
      },
    );
  }
}
