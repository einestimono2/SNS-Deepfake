part of 'post_action_bloc.dart';

sealed class PostActionState extends Equatable {
  const PostActionState();

  @override
  List<Object?> get props => [];
}

final class PAInitialState extends PostActionState {}

final class PAInProgressState extends PostActionState {}

class PASuccessfulState extends PostActionState {
  final PostModel post;
  final int? timestamp;

  const PASuccessfulState({required this.post, this.timestamp});

  @override
  List<Object?> get props => [post, timestamp];
}

final class PAFailureState extends PostActionState {
  final String message;

  const PAFailureState(this.message);

  @override
  List<Object> get props => [message];
}
