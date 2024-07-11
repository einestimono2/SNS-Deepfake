part of 'my_pending_video_deepfake_bloc.dart';

sealed class MyPendingVideoDeepfakeState extends Equatable {
  const MyPendingVideoDeepfakeState();

  @override
  List<Object?> get props => [];
}

final class MyPendingVideoDeepfakeInitialState
    extends MyPendingVideoDeepfakeState {}

final class MyPendingVideoDeepfakeInProgressState
    extends MyPendingVideoDeepfakeState {}

final class MyPendingVideoDeepfakeSuccessfulState
    extends MyPendingVideoDeepfakeState {
  final List<VideoDeepfakeModel> videos;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const MyPendingVideoDeepfakeSuccessfulState({
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

  MyPendingVideoDeepfakeSuccessfulState copyWith({
    int? totalCount,
    List<VideoDeepfakeModel>? videos,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return MyPendingVideoDeepfakeSuccessfulState(
      videos: videos ?? this.videos,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class MyPendingVideoDeepfakeFailureState
    extends MyPendingVideoDeepfakeState {
  final String message;

  const MyPendingVideoDeepfakeFailureState(this.message);

  @override
  List<Object> get props => [message];
}
