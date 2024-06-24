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
