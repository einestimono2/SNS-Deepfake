part of 'my_posts_bloc.dart';

sealed class MyPostsState extends Equatable {
  const MyPostsState();

  @override
  List<Object?> get props => [];
}

final class MyPostsInitialState extends MyPostsState {}

final class MyPostsInProgressState extends MyPostsState {}

final class MyPostsSuccessfulState extends MyPostsState {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const MyPostsSuccessfulState({
    required this.posts,
    this.hasReachedMax = false,
    this.timestamp,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [
        totalCount,
        posts,
        timestamp,
        hasReachedMax,
      ];

  MyPostsSuccessfulState copyWith({
    int? totalCount,
    List<PostModel>? posts,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return MyPostsSuccessfulState(
      posts: posts ?? this.posts,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class MyPostsFailureState extends MyPostsState {
  final String message;

  const MyPostsFailureState(this.message);

  @override
  List<Object> get props => [message];
}
