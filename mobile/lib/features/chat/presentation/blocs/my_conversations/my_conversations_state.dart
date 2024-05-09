part of 'my_conversations_bloc.dart';

sealed class MyConversationsState extends Equatable {
  const MyConversationsState();

  @override
  List<Object?> get props => [];
}

final class InitialState extends MyConversationsState {}

final class InProgressState extends MyConversationsState {}

final class SuccessfulState extends MyConversationsState {
  final List<ConversationModel> conversations;
  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const SuccessfulState({this.timestamp, required this.conversations});

  @override
  List<Object?> get props => [conversations, timestamp];
}

final class FailureState extends MyConversationsState {
  final String message;

  const FailureState(this.message);

  @override
  List<Object> get props => [message];
}
