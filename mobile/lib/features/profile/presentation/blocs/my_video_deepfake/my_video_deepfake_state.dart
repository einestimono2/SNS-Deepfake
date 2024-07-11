part of 'my_video_deepfake_bloc.dart';

sealed class MyVideoDeepfakeState extends Equatable {
  const MyVideoDeepfakeState();

  @override
  List<Object?> get props => [];
}

final class MyVideoDeepfakeInitialState extends MyVideoDeepfakeState {}

final class MyVideoDeepfakeInProgressState extends MyVideoDeepfakeState {}

final class MyVideoDeepfakeSuccessfulState extends MyVideoDeepfakeState {
  final List<VideoDeepfakeModel> videos;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const MyVideoDeepfakeSuccessfulState({
    required this.videos,
    this.hasReachedMax = false,
    this.timestamp,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [
        totalCount,
        videos,
        timestamp,
        hasReachedMax,
      ];

  MyVideoDeepfakeSuccessfulState copyWith({
    int? totalCount,
    List<VideoDeepfakeModel>? videos,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return MyVideoDeepfakeSuccessfulState(
      videos: videos ?? this.videos,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class MyVideoDeepfakeFailureState extends MyVideoDeepfakeState {
  final String message;

  const MyVideoDeepfakeFailureState(this.message);

  @override
  List<Object> get props => [message];
}
