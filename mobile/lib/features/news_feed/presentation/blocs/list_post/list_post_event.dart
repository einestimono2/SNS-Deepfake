part of 'list_post_bloc.dart';

sealed class ListPostEvent extends Equatable {
  const ListPostEvent();

  @override
  List<Object?> get props => [];
}

class AddPost extends ListPostEvent {
  final PostModel post;

  const AddPost(this.post);

  @override
  List<Object?> get props => [post];
}

class DeletePost extends ListPostEvent {
  final int postId;

  const DeletePost(this.postId);

  @override
  List<Object?> get props => [postId];
}

class GetListPost extends ListPostEvent {
  final int? page;
  final int? size;
  final int groupId;

  const GetListPost({
    this.page,
    this.size,
    required this.groupId,
  });

  @override
  List<Object?> get props => [page, size, groupId];
}

class LoadMoreListPost extends ListPostEvent {
  final int? page;
  final int? size;
  final int groupId;

  const LoadMoreListPost({
    this.page,
    this.size,
    required this.groupId,
  });

  @override
  List<Object?> get props => [page, size, groupId];
}
