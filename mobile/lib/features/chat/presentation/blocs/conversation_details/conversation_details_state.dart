part of 'conversation_details_bloc.dart';

sealed class ConversationDetailsState extends Equatable {
  const ConversationDetailsState();

  @override
  List<Object?> get props => [];
}

final class CDInitialState extends ConversationDetailsState {}

final class CDInProgressState extends ConversationDetailsState {}

class CDSuccessfulState extends ConversationDetailsState {
  final int conversationId;
  final List<MessageModel> messages;
  final bool hasReachedMax;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const CDSuccessfulState({
    required this.messages,
    required this.conversationId,
    this.hasReachedMax = false,
    this.timestamp,
  });

  @override
  List<Object?> get props => [
        messages,
        conversationId,
        timestamp,
        hasReachedMax,
      ];

  CDSuccessfulState copyWith({
    int? conversationId,
    List<MessageModel>? messages,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return CDSuccessfulState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class CDEmptySuccessfulState extends ConversationDetailsState {}

final class CDFailureState extends ConversationDetailsState {
  final String message;
  final String fromTarget;

  const CDFailureState(this.message, [this.fromTarget = ""]);

  @override
  List<Object> get props => [message, fromTarget];
}
