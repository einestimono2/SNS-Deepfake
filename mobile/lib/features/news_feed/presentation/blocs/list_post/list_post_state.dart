part of 'list_post_bloc.dart';

sealed class ListPostState extends Equatable {
  const ListPostState();
  
  @override
  List<Object?> get props => [];
}

final class ListPostInitialState extends ListPostState {}

final class ListPostInProgressState extends ListPostState {}

class ListPostSuccessfulState extends ListPostState {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const ListPostSuccessfulState({
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

  ListPostSuccessfulState copyWith({
    int? totalCount,
    List<PostModel>? posts,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return ListPostSuccessfulState(
      posts: posts ?? this.posts,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class ListPostFailureState extends ListPostState {
  final String message;

  const ListPostFailureState(this.message);

  @override
  List<Object> get props => [message];
}
