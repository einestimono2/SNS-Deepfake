part of 'suggested_friends_bloc.dart';

sealed class SuggestedFriendsEvent extends Equatable {
  const SuggestedFriendsEvent();

  @override
  List<Object?> get props => [];
}

class GetSuggestedFriends extends SuggestedFriendsEvent {
  final int? page;
  final int? size;

  const GetSuggestedFriends({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreSuggestedFriends extends SuggestedFriendsEvent {
  final int? page;
  final int? size;

  const LoadMoreSuggestedFriends({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class RemoveSuggestedFriend extends SuggestedFriendsEvent {
  final int id;

  const RemoveSuggestedFriend(this.id);

  @override
  List<Object?> get props => [id];
}
