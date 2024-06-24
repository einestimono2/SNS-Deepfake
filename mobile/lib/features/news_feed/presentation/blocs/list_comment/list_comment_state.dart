part of 'list_comment_bloc.dart';

sealed class ListCommentState extends Equatable {
  const ListCommentState();

  @override
  List<Object?> get props => [];
}

final class ListCommentInitialState extends ListCommentState {}

final class ListCommentInProgressState extends ListCommentState {}

final class ListCommentSuccessfulState extends ListCommentState {
  final List<CommentModel> comments;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const ListCommentSuccessfulState({
    required this.comments,
    this.hasReachedMax = false,
    this.timestamp,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [
        totalCount,
        comments,
        timestamp,
        hasReachedMax,
      ];

  ListCommentSuccessfulState copyWith({
    int? totalCount,
    List<CommentModel>? comments,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return ListCommentSuccessfulState(
      comments: comments ?? this.comments,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class ListCommentFailureState extends ListCommentState {
  final String message;

  const ListCommentFailureState(this.message);

  @override
  List<Object> get props => [message];
}
