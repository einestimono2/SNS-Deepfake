part of 'requested_friends_bloc.dart';

sealed class RequestedFriendsState extends Equatable {
  const RequestedFriendsState();

  @override
  List<Object?> get props => [];
}

final class RFInitialState extends RequestedFriendsState {}

final class RFInProgressState extends RequestedFriendsState {}

class RFSuccessfulState extends RequestedFriendsState {
  final List<FriendModel> friends;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const RFSuccessfulState({
    required this.friends,
    this.hasReachedMax = false,
    this.timestamp,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [totalCount, friends, timestamp, hasReachedMax];

  RFSuccessfulState copyWith({
    int? totalCount,
    List<FriendModel>? friends,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return RFSuccessfulState(
      friends: friends ?? this.friends,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class RFFailureState extends RequestedFriendsState {
  final String message;

  const RFFailureState(this.message);

  @override
  List<Object> get props => [message];
}
