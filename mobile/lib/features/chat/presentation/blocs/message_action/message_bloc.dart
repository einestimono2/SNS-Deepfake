import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/chat/chat.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../app/app.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final AppBloc appBloc;

  final SendMessageUC sendMessageUC;
  final CreateConversationUC createConversationUC;

  MessageBloc({
    required this.appBloc,
    required this.sendMessageUC,
    required this.createConversationUC,
  }) : super(const MessageState()) {
    on<SendMessageSubmit>(_onSendMessageSubmit);
    on<SendFirstMessageSubmit>(_onSendFirstMessageSubmit);
    on<TypingEvent>(_onTypingEvent);
  }

  FutureOr<void> _onSendMessageSubmit(
    SendMessageSubmit event,
    Emitter<MessageState> emit,
  ) async {
    final result = await sendMessageUC(
      SendMessageParams(
        conversationId: event.conversationId,
        replyId: event.replyId,
        message: event.message,
        attachments: event.attachments,
        type: event.type,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: MessageStatus.failure,
        errorMsg: failure.toString(),
      )),
      (message) => emit(state.copyWith(status: MessageStatus.success)),
    );
  }

  FutureOr<void> _onTypingEvent(TypingEvent event, Emitter<MessageState> emit) {
    final int conversationId = event.data["conversationId"];
    final int target = event.data["userId"];
    if (target == (appBloc.state.user?.id ?? -1)) return null;

    Set<int> members = Set.from(state.members);

    // Thêm ptu đã có
    if (event.isTyping && members.add(target) == false) {
      return null;
    }

    if (!event.isTyping && members.remove(target) == false) {
      return null;
    }

    emit(state.copyWith(
      isTyping: members.isNotEmpty,
      conversationId: conversationId,
      members: members,
    ));
    // }
  }

  FutureOr<void> _onSendFirstMessageSubmit(
    SendFirstMessageSubmit event,
    Emitter<MessageState> emit,
  ) async {
    final result = await createConversationUC(
      CreateConversationParams(
        name: event.name,
        memberIds: event.memberIds,
        replyId: event.replyId,
        message: event.message,
        attachments: event.attachments,
        type: event.type,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: MessageStatus.failure,
        errorMsg: failure.toString(),
      )),
      (conversation) {
        emit(state.copyWith(status: MessageStatus.success));
        event.onSuccess.call(conversation);
      },
    );
  }
}
