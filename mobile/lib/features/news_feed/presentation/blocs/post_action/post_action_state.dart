part of 'post_action_bloc.dart';

sealed class PostActionState extends Equatable {
  const PostActionState();

  @override
  List<Object?> get props => [];
}

final class PAInitialState extends PostActionState {}

final class PAInProgressState extends PostActionState {}

class PASuccessfulState extends PostActionState {
  final String type;

  const PASuccessfulState({this.type = ""});

  @override
  List<Object?> get props => [type];
}

final class PAFailureState extends PostActionState {
  final String message;
  final String type;

  const PAFailureState({required this.message, this.type = ""});

  @override
  List<Object> get props => [message, type];
}
