part of 'my_conversations_bloc.dart';

sealed class MyConversationsEvent extends Equatable {
  const MyConversationsEvent();

  @override
  List<Object?> get props => [];
}

class GetMyConversations extends MyConversationsEvent {
  final int? page;
  final int? size;

  const GetMyConversations({this.page, this.size});

  @override
  List<Object?> get props => [page, size];
}

class ConversationLastestEvent extends MyConversationsEvent {
  final dynamic data;

  const ConversationLastestEvent(this.data);

  @override
  List<Object> get props => [data];
}

class ConversationNewEvent extends MyConversationsEvent {
  final ConversationModel conversation;

  const ConversationNewEvent(this.conversation);

  @override
  List<Object> get props => [conversation];
}

class ConversationUpdateEvent extends MyConversationsEvent {
  final dynamic data;

  const ConversationUpdateEvent(this.data);

  @override
  List<Object> get props => [data];
}

class ConversationRemoveEvent extends MyConversationsEvent {
  final int id;

  const ConversationRemoveEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ConversationLeaveEvent extends MyConversationsEvent {
  final dynamic data;

  const ConversationLeaveEvent(this.data);

  @override
  List<Object> get props => [data];
}

class ConversationAddMemberEvent extends MyConversationsEvent {
  final dynamic data;

  const ConversationAddMemberEvent(this.data);

  @override
  List<Object> get props => [data];
}
