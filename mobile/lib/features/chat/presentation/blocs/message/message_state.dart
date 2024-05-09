part of 'message_bloc.dart';

enum MessageStatus { initial, success, failure }

class MessageState extends Equatable {
  final MessageStatus status;
  final String? errorMsg;

  final bool isTyping;
  final int conversationId;
  final Set<int> members;

  const MessageState({
    this.status = MessageStatus.initial,
    this.isTyping = false,
    this.errorMsg,
    this.conversationId = -1,
    this.members = const <int>{},
  });

  @override
  List<Object?> get props =>
      [status, isTyping, errorMsg, conversationId, members];

  MessageState copyWith({
    MessageStatus? status,
    String? errorMsg,
    bool? isTyping,
    int? conversationId,
    Set<int>? members,
  }) {
    return MessageState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      isTyping: isTyping ?? this.isTyping,
      conversationId: conversationId ?? this.conversationId,
      members: members ?? this.members,
    );
  }
}
