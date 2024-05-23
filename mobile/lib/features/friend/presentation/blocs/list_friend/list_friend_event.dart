part of 'list_friend_bloc.dart';

sealed class ListFriendEvent extends Equatable {
  const ListFriendEvent();

  @override
  List<Object?> get props => [];
}


class GetListFriend extends ListFriendEvent {
  final int? page;
  final int? size;

  const GetListFriend({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreListFriend extends ListFriendEvent {
  final int? page;
  final int? size;

  const LoadMoreListFriend({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}
