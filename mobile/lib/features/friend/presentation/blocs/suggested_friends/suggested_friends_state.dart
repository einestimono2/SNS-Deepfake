part of 'suggested_friends_bloc.dart';

sealed class SuggestedFriendsState extends Equatable {
  const SuggestedFriendsState();
  
  @override
  List<Object?> get props => [];
}

final class SFInitialState extends SuggestedFriendsState {}

final class SFInProgressState extends SuggestedFriendsState {}

class SFSuccessfulState extends SuggestedFriendsState {
  final List<FriendModel> friends;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const SFSuccessfulState({
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

  SFSuccessfulState copyWith({
    int? totalCount,
    List<FriendModel>? friends,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return SFSuccessfulState(
      friends: friends ?? this.friends,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class SFFailureState extends SuggestedFriendsState {
  final String message;

  const SFFailureState(this.message);

  @override
  List<Object> get props => [message];
}
