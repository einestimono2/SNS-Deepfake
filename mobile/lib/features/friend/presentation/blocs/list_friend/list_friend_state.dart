part of 'list_friend_bloc.dart';

sealed class ListFriendState extends Equatable {
  const ListFriendState();
  
  @override
  List<Object?> get props => [];
}


final class LFInitialState extends ListFriendState {}

final class LFInProgressState extends ListFriendState {}

class LFSuccessfulState extends ListFriendState {
  final List<FriendModel> friends;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const LFSuccessfulState({
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

  LFSuccessfulState copyWith({
    int? totalCount,
    List<FriendModel>? friends,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return LFSuccessfulState(
      friends: friends ?? this.friends,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class LFFailureState extends ListFriendState {
  final String message;

  const LFFailureState(this.message);

  @override
  List<Object> get props => [message];
}
