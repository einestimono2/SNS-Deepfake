part of 'post_action_bloc.dart';

sealed class PostActionEvent extends Equatable {
  const PostActionEvent();

  @override
  List<Object?> get props => [];
}

class ResetState extends PostActionEvent {}

class CreatePostSubmit extends PostActionEvent {
  final int groupId;
  final String? description;
  final String? status;
  final List<String> files;

  const CreatePostSubmit({
    required this.groupId,
    this.description,
    this.status,
    required this.files,
  });

  @override
  List<Object?> get props => [groupId, description, status, files];
}

class DeletePostSubmit extends PostActionEvent {
  final int postId;
  final int groupId;

  const DeletePostSubmit({required this.postId, required this.groupId});

  @override
  List<Object?> get props => [postId, groupId];
}

class EditPostSubmit extends PostActionEvent {
  final int postId;
  // final List<String> images;
  // image_sort
  // image_del
  // description
  // status
  // video

  const EditPostSubmit(this.postId);

  @override
  List<Object?> get props => [postId];
}

class GetPostDetails extends PostActionEvent {
  final int postId;

  const GetPostDetails(this.postId);

  @override
  List<Object> get props => [postId];
}
