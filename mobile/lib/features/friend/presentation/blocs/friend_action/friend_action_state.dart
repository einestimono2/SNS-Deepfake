part of 'friend_action_bloc.dart';

sealed class FriendActionState extends Equatable {
  const FriendActionState();

  @override
  List<Object?> get props => [];
}

final class FAInitialState extends FriendActionState {}

final class FAInProgressState extends FriendActionState {}

class FASuccessfulState extends FriendActionState {
  final int id;
  final String type;

  const FASuccessfulState({
    required this.id,
    required this.type,
  });

  @override
  List<Object?> get props => [id, type];
}

final class FAFailureState extends FriendActionState {
  final String message;
  final int id;
  final String type;

  const FAFailureState({
    required this.message,
    required this.id,
    required this.type,
  });

  @override
  List<Object> get props => [message, id, type];
}
