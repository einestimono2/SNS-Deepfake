part of 'requested_friends_bloc.dart';

sealed class RequestedFriendsEvent extends Equatable {
  const RequestedFriendsEvent();

  @override
  List<Object?> get props => [];
}

class GetRequestedFriends extends RequestedFriendsEvent {
  final int? page;
  final int? size;

  const GetRequestedFriends({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreRequestedFriends extends RequestedFriendsEvent {
  final int? page;
  final int? size;

  const LoadMoreRequestedFriends({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}
