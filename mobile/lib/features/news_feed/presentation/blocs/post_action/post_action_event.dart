part of 'post_action_bloc.dart';

sealed class PostActionEvent extends Equatable {
  const PostActionEvent();

  @override
  List<Object?> get props => [];
}

class CreateCommentSubmit extends PostActionEvent {
  final int postId;
  final String content;
  final int? markId;
  final int? page;
  final int? size;
  final int type;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const CreateCommentSubmit({
    required this.postId,
    this.markId,
    this.page,
    this.size,
    required this.content,
    required this.type,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [postId, markId, page, size, content, type];
}

class CreatePostSubmit extends PostActionEvent {
  final int groupId;
  final String? description;
  final String? status;
  final List<String> files;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const CreatePostSubmit({
    required this.groupId,
    this.description,
    this.status,
    required this.files,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [groupId, description, status, files];
}

class DeletePostSubmit extends PostActionEvent {
  final int postId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const DeletePostSubmit({
    required this.postId,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [postId, onError, onSuccess];
}

class EditPostSubmit extends PostActionEvent {
  final int postId;
  final List<String>? images;
  final List<String>? videos;
  final List<String>? imageDel;
  final List<String>? videoDel;
  final String? description;
  final String? status;
  final VoidCallback onSuccess;
  final Function(String) onError;
  final int? groupId;

  const EditPostSubmit({
    required this.postId,
    this.images,
    this.groupId,
    this.videos,
    this.imageDel,
    this.videoDel,
    this.description,
    this.status,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [
        postId,
        images,
        videos,
        imageDel,
        videoDel,
        description,
        status,
      ];
}

class GetPostDetails extends PostActionEvent {
  final int postId;

  const GetPostDetails(this.postId);

  @override
  List<Object> get props => [postId];
}

class FeelPost extends PostActionEvent {
  final int postId;
  final int type;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const FeelPost({
    required this.postId,
    required this.type,
    required this.onError,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [postId, type];
}

class UnfeelPost extends PostActionEvent {
  final int postId;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const UnfeelPost({
    required this.postId,
    required this.onError,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [postId];
}

class ReportPostSubmit extends PostActionEvent {
  final int postId;
  final String subject;
  final String content;
  final VoidCallback onSuccess;
  final Function(String) onError;

  const ReportPostSubmit({
    required this.postId,
    required this.subject,
    required this.content,
    required this.onError,
    required this.onSuccess,
  });

  @override
  List<Object> get props => [postId, subject, content];
}
