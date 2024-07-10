import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/chat/chat.dart';

import '../../../../app/bloc/bloc.dart';

part 'my_conversations_event.dart';
part 'my_conversations_state.dart';

class MyConversationsBloc
    extends Bloc<MyConversationsEvent, MyConversationsState> {
  MyConversationUC myConversationUC;

  final AppBloc appBloc;

  MyConversationsBloc({
    required this.myConversationUC,
    required this.appBloc,
  }) : super(InitialState()) {
    on<GetMyConversations>(_onGetMyConversations);

    /* Events */
    on<ConversationLastestEvent>(_onConversationLastestEvent);
    on<ConversationNewEvent>(_onConversationNewEvent);
    on<ConversationUpdateEvent>(_onConversationUpdateEvent);
    on<ConversationLeaveEvent>(_onConversationLeaveEvent);
    on<ConversationAddMemberEvent>(_onConversationAddMemberEvent);
    on<ConversationRemoveEvent>(_onConversationRemoveEvent);
  }

  FutureOr<void> _onGetMyConversations(
    GetMyConversations event,
    Emitter<MyConversationsState> emit,
  ) async {
    emit(InProgressState());

    final result = await myConversationUC(MyConversationParams(
      size: event.size,
      page: event.page,
    ));

    result.fold(
      (failure) => emit(FailureState(failure.toString())),
      (conversations) {
        emit(SuccessfulState(conversations: conversations));
      },
    );
  }

  FutureOr<void> _onConversationLastestEvent(
    ConversationLastestEvent event,
    Emitter<MyConversationsState> emit,
  ) {
    if (state is SuccessfulState) {
      final int conversationId = int.parse("${event.data['conversationId']}");
      final MessageModel message = MessageModel.fromMap(event.data['message']);
      final String? lastMessageAt = event.data['lastMessageAt'];

      List<ConversationModel> updatedConversations = [];

      for (var conversation in (state as SuccessfulState).conversations) {
        if (conversation.id == conversationId) {
          ConversationModel _temp = conversation.copyWith(
            lastMessageAt: lastMessageAt,
            messages: [message, ...conversation.messages],
          );

          if (lastMessageAt != null) {
            updatedConversations.insert(0, _temp);
          } else {
            updatedConversations.add(_temp);
          }
        } else {
          updatedConversations.add(conversation);
        }
      }

      emit(SuccessfulState(
        conversations: updatedConversations,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  FutureOr<void> _onConversationNewEvent(
    ConversationNewEvent event,
    Emitter<MyConversationsState> emit,
  ) async {
    if (state is SuccessfulState) {
      final preState = state as SuccessfulState;

      emit(SuccessfulState(
        conversations: [event.conversation, ...preState.conversations],
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    } else {
      emit(SuccessfulState(
        conversations: [event.conversation],
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  FutureOr<void> _onConversationUpdateEvent(
    ConversationUpdateEvent event,
    Emitter<MyConversationsState> emit,
  ) async {
    if (state is SuccessfulState) {
      final int conversationId = int.parse("${event.data['conversationId']}");
      final MessageModel message = MessageModel.fromMap(event.data['message']);
      String lastMessageAt = event.data['lastMessageAt'];
      String name = event.data['name'];

      final preState = state as SuccessfulState;
      List<ConversationModel> updatedConversations = [];

      for (var conversation in preState.conversations) {
        if (conversation.id == conversationId) {
          ConversationModel _temp = conversation.copyWith(
            lastMessageAt: lastMessageAt,
            name: name,
            messages: [message, ...conversation.messages],
          );

          updatedConversations.insert(0, _temp);
        } else {
          updatedConversations.add(conversation);
        }
      }

      emit(SuccessfulState(
        conversations: updatedConversations,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  FutureOr<void> _onConversationLeaveEvent(
    ConversationLeaveEvent event,
    Emitter<MyConversationsState> emit,
  ) async {
    if (state is SuccessfulState) {
      final int conversationId = int.parse("${event.data['conversationId']}");
      final int memberId = int.parse("${event.data['memberId']}");
      final MessageModel message = MessageModel.fromMap(event.data['message']);
      String lastMessageAt = event.data['lastMessageAt'];

      final preState = state as SuccessfulState;

      if (appBloc.state.user!.id == memberId) {
        preState.conversations
            .removeWhere((element) => element.id == conversationId);

        emit(SuccessfulState(
          conversations: preState.conversations,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      } else {
        List<ConversationModel> updatedConversations = [];

        for (var conversation in preState.conversations) {
          if (conversation.id == conversationId) {
            ConversationModel _temp = conversation.copyWith(
              lastMessageAt: lastMessageAt,
              messages: [message, ...conversation.messages],
              members:
                  conversation.members.where((e) => e.id != memberId).toList(),
            );

            updatedConversations.insert(0, _temp);
          } else {
            updatedConversations.add(conversation);
          }
        }

        emit(SuccessfulState(
          conversations: updatedConversations,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      }
    }
  }

  FutureOr<void> _onConversationAddMemberEvent(
    ConversationAddMemberEvent event,
    Emitter<MyConversationsState> emit,
  ) async {
    if (state is SuccessfulState) {
      final int conversationId = int.parse("${event.data['conversationId']}");
      final List<int> memberIds = List<int>.from(event.data['memberIds']);

      final preState = state as SuccessfulState;

      // Người được mời --> New conversation
      if (memberIds.contains(appBloc.state.user!.id)) {
        Map<String, dynamic> conversationMap = event.data['conversation'];
        conversationMap.addAll({
          "messages": [event.data['message']],
        });

        ConversationModel conversation =
            ConversationModel.fromMap(conversationMap);

        emit(SuccessfulState(
          conversations: [conversation, ...preState.conversations],
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      } else {
        final MessageModel message =
            MessageModel.fromMap(event.data['message']);
        String lastMessageAt = event.data['lastMessageAt'];
        List<ConversationModel> updatedConversations = [];

        List<MemberModel> members = List<MemberModel>.from(event
            .data['conversation']['members']
            .map((e) => MemberModel.fromMap(e)));

        for (var conversation in preState.conversations) {
          if (conversation.id == conversationId) {
            ConversationModel _temp = conversation.copyWith(
              lastMessageAt: lastMessageAt,
              messages: [message, ...conversation.messages],
              members: members,
            );

            updatedConversations.insert(0, _temp);
          } else {
            updatedConversations.add(conversation);
          }
        }

        emit(SuccessfulState(
          conversations: updatedConversations,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      }
    }
  }

  FutureOr<void> _onConversationRemoveEvent(
    ConversationRemoveEvent event,
    Emitter<MyConversationsState> emit,
  ) async {
    if (state is SuccessfulState) {
      final preState = state as SuccessfulState;
      preState.conversations.removeWhere((element) => element.id == event.id);

      emit(SuccessfulState(
        conversations: preState.conversations,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }
}
