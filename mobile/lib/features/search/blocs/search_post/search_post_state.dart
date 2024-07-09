part of 'search_post_bloc.dart';

sealed class SearchPostState extends Equatable {
  const SearchPostState();

  @override
  List<Object?> get props => [];
}

final class SearchPostInitialState extends SearchPostState {}

final class SearchPostInProgressState extends SearchPostState {}

final class SearchPostSuccessfulState extends SearchPostState {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final int totalCount;

  final int? timestamp;

  const SearchPostSuccessfulState({
    required this.posts,
    this.hasReachedMax = false,
    this.timestamp,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [posts, timestamp, hasReachedMax, totalCount];

  SearchPostSuccessfulState copyWith({
    int? totalCount,
    List<PostModel>? posts,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return SearchPostSuccessfulState(
      posts: posts ?? this.posts,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class SearchPostFailureState extends SearchPostState {
  final String message;

  const SearchPostFailureState(this.message);

  @override
  List<Object> get props => [message];
}
