part of 'my_video_deepfake_bloc.dart';

sealed class MyVideoDeepfakeEvent extends Equatable {
  const MyVideoDeepfakeEvent();

  @override
  List<Object?> get props => [];
}

class GetMyVideoDeepfakes extends MyVideoDeepfakeEvent {
  final int? page;
  final int? size;

  const GetMyVideoDeepfakes({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreMyVideoDeepfakes extends MyVideoDeepfakeEvent {
  final int? page;
  final int? size;

  const LoadMoreMyVideoDeepfakes({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}
