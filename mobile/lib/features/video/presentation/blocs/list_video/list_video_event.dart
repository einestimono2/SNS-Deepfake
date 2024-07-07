part of 'list_video_bloc.dart';

sealed class ListVideoEvent extends Equatable {
  const ListVideoEvent();

  @override
  List<Object?> get props => [];
}

class GetListVideo extends ListVideoEvent {
  final int? size;
  final int groupId;

  const GetListVideo({
    this.size,
    this.groupId = 0,
  });

  @override
  List<Object?> get props => [size, groupId];
}

class LoadMoreListVideo extends ListVideoEvent {
  final int? size;
  final int groupId;

  const LoadMoreListVideo({
    this.size,
    this.groupId = 0,
  });

  @override
  List<Object?> get props => [size, groupId];
}

class SetLoading extends ListVideoEvent {}

class VideoIndexChanged extends ListVideoEvent {
  final int index;

  const VideoIndexChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class UpdateListVideo extends ListVideoEvent {
  final PaginationResult<VideoModel> videos;

  const UpdateListVideo(this.videos);

  @override
  List<Object?> get props => [videos];
}

class UpdateMyFeel extends ListVideoEvent {
  final int feel;
  final int videoId;
  final Function(int, int, int) onSuccess;
  final Function(String) onError;

  const UpdateMyFeel({
    required this.feel,
    required this.videoId,
    required this.onSuccess,
    required this.onError,
  });
}

class CreateCommentSubmit extends ListVideoEvent {
  final int postId;
  final String content;
  final int? markId;
  final int? page;
  final int? size;
  final int type;
  final Function(int, int) onSuccess;
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
