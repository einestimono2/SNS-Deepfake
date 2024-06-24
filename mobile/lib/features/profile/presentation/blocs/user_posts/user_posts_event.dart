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
