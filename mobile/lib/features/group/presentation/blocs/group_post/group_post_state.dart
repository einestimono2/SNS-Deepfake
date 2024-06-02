part of 'group_post_bloc.dart';

sealed class GroupPostState extends Equatable {
  const GroupPostState();

  @override
  List<Object?> get props => [];
}

final class GroupPostInitialState extends GroupPostState {}

final class GroupPostInProgressState extends GroupPostState {}

class GroupPostSuccessfulState extends GroupPostState {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const GroupPostSuccessfulState({
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

  GroupPostSuccessfulState copyWith({
    int? totalCount,
    List<PostModel>? posts,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return GroupPostSuccessfulState(
      posts: posts ?? this.posts,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class GroupPostFailureState extends GroupPostState {
  final String message;

  const GroupPostFailureState(this.message);

  @override
  List<Object> get props => [message];
}
