part of 'group_post_bloc.dart';

sealed class GroupPostEvent extends Equatable {
  const GroupPostEvent();

  @override
  List<Object?> get props => [];
}

class GetListPost extends GroupPostEvent {
  final int? page;
  final int? size;
  final int groupId;

  const GetListPost({
    this.page,
    this.size,
    required this.groupId,
  });

  @override
  List<Object?> get props => [page, size, groupId];
}

class LoadMoreListPost extends GroupPostEvent {
  final int? page;
  final int? size;
  final int groupId;

  const LoadMoreListPost({
    this.page,
    this.size,
    required this.groupId,
  });

  @override
  List<Object?> get props => [page, size, groupId];
}

class CreateGroupPostSubmit extends GroupPostEvent {
  final GroupModel group;
  final String? description;
  final String? status;
  final List<String> files;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const CreateGroupPostSubmit({
    required this.group,
    this.description,
    this.status,
    required this.files,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [group, description, status, files];
}

class UpdateGroupPostFeel extends GroupPostEvent {
  final int postId;
  final int kudosCount;
  final int disappointedCount;
  final int type;

  const UpdateGroupPostFeel({
    required this.postId,
    required this.kudosCount,
    required this.disappointedCount,
    required this.type,
  });
}

class UpdateGroupPostComment extends GroupPostEvent {
  final int postId;
  final int fakeCounts;
  final int trustCounts;

  const UpdateGroupPostComment({
    required this.postId,
    required this.fakeCounts,
    required this.trustCounts,
  });
}
