part of 'my_posts_bloc.dart';

sealed class MyPostsEvent extends Equatable {
  const MyPostsEvent();

  @override
  List<Object?> get props => [];
}

class GetMyPosts extends MyPostsEvent {
  final int? page;
  final int? size;

  const GetMyPosts({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreMyPosts extends MyPostsEvent {
  final int? page;
  final int? size;

  const LoadMoreMyPosts({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class AddMyPost extends MyPostsEvent {
  final PostModel post;

  const AddMyPost(this.post);

  @override
  List<Object?> get props => [post];
}
