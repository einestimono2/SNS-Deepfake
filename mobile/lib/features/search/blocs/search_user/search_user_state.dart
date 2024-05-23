part of 'search_user_bloc.dart';

sealed class SearchUserState extends Equatable {
  const SearchUserState();

  @override
  List<Object?> get props => [];
}

final class SUInitialState extends SearchUserState {}

final class SUInProgressState extends SearchUserState {}

class SUSuccessfulState extends SearchUserState {
  final List<FriendModel> users;
  final bool hasReachedMax;
  final int totalCount;

  final int? timestamp;

  const SUSuccessfulState({
    required this.users,
    this.hasReachedMax = false,
    this.timestamp,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [users, timestamp, hasReachedMax, totalCount];
}

final class SUFailureState extends SearchUserState {
  final String message;

  const SUFailureState(this.message);

  @override
  List<Object> get props => [message];
}
