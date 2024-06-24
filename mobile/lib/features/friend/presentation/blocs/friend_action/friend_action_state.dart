part of 'friend_action_bloc.dart';

sealed class FriendActionState extends Equatable {
  const FriendActionState();

  @override
  List<Object?> get props => [];
}

final class FAInitialState extends FriendActionState {}

final class FAInProgressState extends FriendActionState {}

class FASuccessfulState extends FriendActionState {}

final class FAFailureState extends FriendActionState {
  final String message;

  const FAFailureState(this.message);

  @override
  List<Object> get props => [message];
}
