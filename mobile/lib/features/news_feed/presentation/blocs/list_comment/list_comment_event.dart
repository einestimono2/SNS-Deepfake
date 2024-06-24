part of 'list_comment_bloc.dart';

sealed class ListCommentEvent extends Equatable {
  const ListCommentEvent();

  @override
  List<Object?> get props => [];
}

class GetListComment extends ListCommentEvent {
  final int? page;
  final int? size;
  final int postId;

  const GetListComment({
    this.page,
    this.size,
    required this.postId,
  });

  @override
  List<Object?> get props => [page, size, postId];
}

class LoadMoreListComment extends ListCommentEvent {
  final int? page;
  final int? size;
  final int postId;

  const LoadMoreListComment({
    this.page,
    this.size,
    required this.postId,
  });

  @override
  List<Object?> get props => [page, size, postId];
}

class UpdateListComment extends ListCommentEvent {
  final List<CommentModel> comments;
  final bool hasReachedMax;
  final int totalCount;

  const UpdateListComment({
    required this.comments,
    required this.hasReachedMax,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [comments, hasReachedMax, totalCount];
}
