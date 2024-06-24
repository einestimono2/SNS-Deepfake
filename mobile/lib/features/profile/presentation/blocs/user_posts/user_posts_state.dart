part of 'user_posts_bloc.dart';

sealed class UserPostsState extends Equatable {
  const UserPostsState();

  @override
  List<Object?> get props => [];
}

final class UserPostsInitialState extends UserPostsState {}

final class UserPostsInProgressState extends UserPostsState {}

final class UserPostsSuccessfulState extends UserPostsState {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const UserPostsSuccessfulState({
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

  UserPostsSuccessfulState copyWith({
    int? totalCount,
    List<PostModel>? posts,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return UserPostsSuccessfulState(
      posts: posts ?? this.posts,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class UserPostsFailureState extends UserPostsState {
  final String message;

  const UserPostsFailureState(this.message);

  @override
  List<Object> get props => [message];
}
