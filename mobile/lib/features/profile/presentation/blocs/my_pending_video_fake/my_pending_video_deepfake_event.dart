part of 'my_pending_video_deepfake_bloc.dart';

sealed class MyPendingVideoDeepfakeEvent extends Equatable {
  const MyPendingVideoDeepfakeEvent();

  @override
  List<Object?> get props => [];
}

class GetMyPendingVideoDeepfakes extends MyPendingVideoDeepfakeEvent {
  final int? page;
  final int? size;

  const GetMyPendingVideoDeepfakes({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreMyPendingVideoDeepfakes extends MyPendingVideoDeepfakeEvent {
  final int? page;
  final int? size;

  const LoadMoreMyPendingVideoDeepfakes({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class AddPendingVideo extends MyPendingVideoDeepfakeEvent {
  final VideoDeepfakeModel video;

  const AddPendingVideo(this.video);
}
