part of 'user_friends_bloc.dart';

sealed class UserFriendsState extends Equatable {
  const UserFriendsState();

  @override
  List<Object?> get props => [];
}

final class UserFriendsInitialState extends UserFriendsState {}

final class UserFriendsInProgressState extends UserFriendsState {}

final class UserFriendsSuccessfulState extends UserFriendsState {
  final List<FriendModel> friends;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const UserFriendsSuccessfulState({
    required this.friends,
    this.hasReachedMax = false,
    this.timestamp,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [
        totalCount,
        friends,
        timestamp,
        hasReachedMax,
      ];

  UserFriendsSuccessfulState copyWith({
    int? totalCount,
    List<FriendModel>? friends,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return UserFriendsSuccessfulState(
      friends: friends ?? this.friends,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class UserFriendsFailureState extends UserFriendsState {
  final String message;

  const UserFriendsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
