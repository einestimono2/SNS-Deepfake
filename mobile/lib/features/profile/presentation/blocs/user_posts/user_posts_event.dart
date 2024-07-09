part of 'user_posts_bloc.dart';

sealed class UserPostsEvent extends Equatable {
  const UserPostsEvent();

  @override
  List<Object?> get props => [];
}

class GetUserPosts extends UserPostsEvent {
  final int? page;
  final int? size;
  final int id;

  const GetUserPosts({
    this.page,
    this.size,
    required this.id,
  });

  @override
  List<Object?> get props => [page, size, id];
}

class LoadMoreUserPosts extends UserPostsEvent {
  final int? page;
  final int? size;
  final int id;

  const LoadMoreUserPosts({
    this.page,
    this.size,
    required this.id,
  });

  @override
  List<Object?> get props => [page, size, id];
}

class UpdateUserPostsFeel extends UserPostsEvent {
  final int postId;
  final int kudosCount;
  final int disappointedCount;
  final int type;

  const UpdateUserPostsFeel({
    required this.postId,
    required this.kudosCount,
    required this.disappointedCount,
    required this.type,
  });
}

class UpdateUserPostsComment extends UserPostsEvent {
  final int postId;
  final int fakeCounts;
  final int trustCounts;

  const UpdateUserPostsComment({
    required this.postId,
    required this.fakeCounts,
    required this.trustCounts,
  });
}
