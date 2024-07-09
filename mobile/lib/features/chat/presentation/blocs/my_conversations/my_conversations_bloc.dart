import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/chat/chat.dart';

part 'my_conversations_event.dart';
part 'my_conversations_state.dart';

class MyConversationsBloc
    extends Bloc<MyConversationsEvent, MyConversationsState> {
  MyConversationUC myConversationUC;

  MyConversationsBloc({required this.myConversationUC})
      : super(InitialState()) {
    on<GetMyConversations>(_onGetMyConversations);

    /* Events */
    on<ConversationLastestEvent>(_onConversationLastestEvent);
    on<ConversationNewEvent>(_onConversationNewEvent);
    on<ConversationUpdateEvent>(_onConversationUpdateEvent);
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
}
