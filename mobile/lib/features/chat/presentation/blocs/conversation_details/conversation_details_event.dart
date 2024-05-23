part of 'conversation_details_bloc.dart';

sealed class ConversationDetailsEvent extends Equatable {
  const ConversationDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetConversationDetails extends ConversationDetailsEvent {
  final int id;
  final int? page;
  final int? size;

  const GetConversationDetails({
    this.page,
    this.size,
    required this.id,
  });

  @override
  List<Object?> get props => [id, page, size];
}

class LoadMoreConversationDetails extends ConversationDetailsEvent {
  final int id;
  final int? page;
  final int? size;

  const LoadMoreConversationDetails({
    this.page,
    this.size,
    required this.id,
  });

  @override
  List<Object?> get props => [id, page, size];
}

class SeenConversation extends ConversationDetailsEvent {
  final int conversationId;

  const SeenConversation(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

class NewMessageEvent extends ConversationDetailsEvent {
  final dynamic newMessage;

  const NewMessageEvent({required this.newMessage});

  @override
  List<Object?> get props => [newMessage];
}

class FirstMessageEvent extends ConversationDetailsEvent {
  final MessageModel message;

  const FirstMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateMessageEvent extends ConversationDetailsEvent {
  final dynamic updatedMessage;

  const UpdateMessageEvent({required this.updatedMessage});

  @override
  List<Object?> get props => [updatedMessage];
}
