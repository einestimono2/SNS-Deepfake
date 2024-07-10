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

class NewMessagesEvent extends ConversationDetailsEvent {
  final dynamic newMessages;

  const NewMessagesEvent({required this.newMessages});

  @override
  List<Object?> get props => [newMessages];
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

class GetSingleConversationByMembers extends ConversationDetailsEvent {
  final int targetId;
  final Function(int) onSuccess;
  final Function(String) onError;

  const GetSingleConversationByMembers({
    required this.targetId,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object> get props => [targetId];
}

class CreateGroupChatSubmit extends ConversationDetailsEvent {
  final String? name;
  final List<int> memberIds;
  final Function(int) onSuccess;
  final Function(String) onError;

  const CreateGroupChatSubmit({
    required this.name,
    required this.memberIds,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [memberIds, name];
}

class RenameConversationSubmit extends ConversationDetailsEvent {
  final int id;
  final String name;
  final Function(Map<String, dynamic>) onSuccess;
  final Function(String) onError;

  const RenameConversationSubmit({
    required this.id,
    required this.name,
    required this.onSuccess,
    required this.onError,
  });
}

class DeleteMemberSubmit extends ConversationDetailsEvent {
  final int id;
  final int memberId;
  final bool kick;
  final Function() onSuccess;
  final Function(String) onError;

  const DeleteMemberSubmit({
    required this.id,
    required this.kick,
    required this.memberId,
    required this.onSuccess,
    required this.onError,
  });
}

class AddMemberSubmit extends ConversationDetailsEvent {
  final int id;
  final List<int> memberIds;
  final Function(List<MemberModel>) onSuccess;
  final Function(String) onError;

  const AddMemberSubmit({
    required this.id,
    required this.memberIds,
    required this.onSuccess,
    required this.onError,
  });
}

class DeleteConversationSubmit extends ConversationDetailsEvent {
  final int id;
  final Function() onSuccess;
  final Function(String) onError;

  const DeleteConversationSubmit({
    required this.id,
    required this.onSuccess,
    required this.onError,
  });
}
