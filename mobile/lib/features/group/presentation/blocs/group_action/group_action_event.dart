part of 'group_action_bloc.dart';

sealed class GroupActionEvent extends Equatable {
  const GroupActionEvent();

  @override
  List<Object?> get props => [];
}

class CreateGroupSubmit extends GroupActionEvent {
  final String name;
  final String? description;
  final List<FriendModel> members;
  final List<int> memberIds;
  final String? coverPhoto;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const CreateGroupSubmit({
    required this.name,
    required this.onSuccess,
    required this.onError,
    this.description,
    this.members = const [],
    this.memberIds = const [],
    this.coverPhoto,
  });

  @override
  List<Object?> get props =>
      [name, description, memberIds, members, coverPhoto];
}

class GetGroupDetails extends GroupActionEvent {
  final int id;

  const GetGroupDetails(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateGroupSubmit extends GroupActionEvent {
  final int id;
  final String? name;
  final String? description;
  final String? coverPhoto;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const UpdateGroupSubmit({
    required this.id,
    this.name,
    this.description,
    this.coverPhoto,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [id, name, description, coverPhoto];
}

class InviteMembersSubmit extends GroupActionEvent {
  final List<FriendModel> members;
  final List<int> memberIds;
  final int groupId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const InviteMembersSubmit({
    this.members = const [],
    this.memberIds = const [],
    required this.groupId,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [memberIds, members, groupId];
}

class DeleteMembersSubmit extends GroupActionEvent {
  final List<int> memberIds;
  final int groupId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const DeleteMembersSubmit({
    this.memberIds = const [],
    required this.groupId,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [memberIds, groupId];
}

class LeaveGroupSubmit extends GroupActionEvent {
  final int groupId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const LeaveGroupSubmit({
    required this.groupId,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [groupId];
}

class DeleteGroupSubmit extends GroupActionEvent {
  final int groupId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const DeleteGroupSubmit({
    required this.groupId,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [groupId];
}
