part of 'user_friends_bloc.dart';

sealed class UserFriendsEvent extends Equatable {
  const UserFriendsEvent();

  @override
  List<Object?> get props => [];
}

class GetUserFriends extends UserFriendsEvent {
  final int? page;
  final int? size;
  final int id;

  const GetUserFriends({
    this.page,
    this.size,
    required this.id,
  });

  @override
  List<Object?> get props => [page, size, id];
}

class LoadMoreUserFriends extends UserFriendsEvent {
  final int? page;
  final int? size;
  final int id;

  const LoadMoreUserFriends({
    this.page,
    this.size,
    required this.id,
  });

  @override
  List<Object?> get props => [page, size, id];
}
