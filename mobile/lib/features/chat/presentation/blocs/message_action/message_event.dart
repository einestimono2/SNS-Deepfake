part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageSubmit extends MessageEvent {
  final String? message;
  final int conversationId;
  final int? replyId;
  final MessageType type;
  final List<String> attachments;

  const SendMessageSubmit({
    required this.conversationId,
    required this.type,
    this.message,
    this.replyId,
    this.attachments = const [],
  });

  @override
  List<Object?> get props => [
        message,
        conversationId,
        replyId,
        type,
        attachments,
      ];
}

class SendFirstMessageSubmit extends MessageEvent {
  final String? message;
  final String? name;
  final List<int> memberIds;
  final int? replyId;
  final MessageType type;
  final List<String> attachments;
  final Function(ConversationModel conversation) onSuccess;

  const SendFirstMessageSubmit({
    required this.type,
    required this.memberIds,
    this.message,
    this.name,
    this.replyId,
    required this.onSuccess,
    this.attachments = const [],
  });

  @override
  List<Object?> get props => [
        message,
        replyId,
        type,
        onSuccess,
        attachments,
      ];
}

class TypingEvent extends MessageEvent {
  final bool isTyping;
  final dynamic data;

  const TypingEvent({required this.data, required this.isTyping});

  @override
  List<Object?> get props => [isTyping, data];
}
