part of 'socket_bloc.dart';

sealed class SocketEvent extends Equatable {
  const SocketEvent();

  @override
  List<Object> get props => [];
}

class OpenConnection extends SocketEvent {
  final int userId;

  const OpenConnection({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CloseConnection extends SocketEvent {}

class UpdateUserOnline extends SocketEvent {
  final List<int> online;

  const UpdateUserOnline(this.online);

  @override
  List<Object> get props => [online];
}

class JoinConversation extends SocketEvent {
  final int conversationId;

  const JoinConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class LeaveConversation extends SocketEvent {
  final int conversationId;

  const LeaveConversation(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class TypingSubmit extends SocketEvent {
  final int conversationId;
  final List<int> members;
  final bool isTyping;

  const TypingSubmit({
    required this.conversationId,
    required this.members,
    required this.isTyping,
  });

  @override
  List<Object> get props => [conversationId, members, isTyping];
}

class SocketError extends SocketEvent {
  final dynamic error;
  final String type;

  const SocketError(this.error, [this.type = "unknown"]);

  @override
  List<Object> get props => [error, type];
}
