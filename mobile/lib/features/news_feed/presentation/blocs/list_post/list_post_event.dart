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

class UpdateCommentSummary extends ListPostEvent {
  final int postId;
  final int fakeCounts;
  final int trustCounts;

  const UpdateCommentSummary({
    required this.postId,
    required this.fakeCounts,
    required this.trustCounts,
  });
}

class UpdateFeelSummary extends ListPostEvent {
  final int postId;
  final int kudosCount;
  final int disappointedCount;
  final int type;

  const UpdateFeelSummary({
    required this.postId,
    required this.kudosCount,
    required this.disappointedCount,
    required this.type,
  });
}

class UpdatePost extends ListPostEvent {
  final int postId;
  final List<String>? images;
  final List<String>? videos;
  final int? groupId;
  final String? description;

  const UpdatePost({
    required this.postId,
    this.images,
    this.videos,
    this.groupId,
    this.description,
  });
}
