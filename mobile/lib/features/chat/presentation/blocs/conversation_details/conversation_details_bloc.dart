import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/chat/chat.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../app/app.dart';

part 'conversation_details_event.dart';
part 'conversation_details_state.dart';

class ConversationDetailsBloc
    extends Bloc<ConversationDetailsEvent, ConversationDetailsState> {
  final GetConversationIdUC getConversationIdUC;
  final GetConversationDetailsUC getConversationDetailsUC;
  final GetConversationMessagesUC getConversationMessagesUC;
  final SeenConversationUC seenConversationUC;
  final CreateConversationUC createConversationUC;

  final AppBloc appBloc;
  final MyConversationsBloc myConversationsBloc;

  ConversationDetailsBloc({
    required this.myConversationsBloc,
    required this.appBloc,
    required this.getConversationDetailsUC,
    required this.getConversationMessagesUC,
    required this.createConversationUC,
    required this.seenConversationUC,
    required this.getConversationIdUC,
  }) : super(CDInitialState()) {
    on<GetConversationDetails>(_onGetConversationDetails);
    on<NewMessageEvent>(_onNewMessageEvent);
    on<FirstMessageEvent>(_onFirstMessageEvent);
    on<UpdateMessageEvent>(_onUpdateMessageEvent);
    on<SeenConversation>(_onSeenConversation);
    on<LoadMoreConversationDetails>(_onLoadMoreConversationDetails);
    on<GetSingleConversationByMembers>(_onGetSingleConversationByMembers);
    on<CreateGroupChatSubmit>(_onCreateGroupChatSubmit);
  }

  FutureOr<void> _onGetConversationDetails(
    GetConversationDetails event,
    Emitter<ConversationDetailsState> emit,
  ) async {
    emit(CDInProgressState());

    // int idx = -1;
    // if (myConversationsBloc.state is SuccessfulState) {
    //   idx = (myConversationsBloc.state as SuccessfulState)
    //       .conversations
    //       .indexWhere((e) => e.id == event.id);
    // }

    // late ConversationModel conversation;
    // if (idx == -1) {
    //   final result = await getConversationDetailsUC(
    //     GetConversationDetailsParams(id: event.id),
    //   );

    //   // if (result.isLeft()) {
    //   //   emit(CDFailureState((result as Left).value.toString()));
    //   //   return;
    //   // }
    //   result.fold(
    //     (failure) {
    //       (failure is HttpFailure && failure.ec == 404)
    //           ? emit(CDEmptySuccessfulState())
    //           : emit(CDFailureState(failure.toString()));

    //       return;
    //     },
    //     (_conversation) {
    //       conversation = _conversation;
    //     },
    //   );
    // } else {
    //   conversation =
    //       (myConversationsBloc.state as SuccessfulState).conversations[idx];
    // }

    final result = await getConversationMessagesUC(
      GetConversationMessagesParams(
        id: event.id,
        page: event.page,
        size: event.size,
      ),
    );

    result.fold(
      (failure) => emit(CDFailureState(failure.toString())),
      (response) => emit(
        CDSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          messages: response.data,
          conversationId: event.id,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onNewMessageEvent(
    NewMessageEvent event,
    Emitter<ConversationDetailsState> emit,
  ) {
    if (state is CDSuccessfulState &&
        (state as CDSuccessfulState).conversationId ==
            event.newMessage['conversationId']) {
      MessageModel msg = MessageModel.fromMap(event.newMessage);
      final oldState = (state as CDSuccessfulState);

      emit(oldState.copyWith(
        messages: [msg, ...(oldState.messages)],
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));

      // Seen message đó luôn nếu  chưa có
      if (appBloc.state.user != null &&
          !msg.seenIds.contains(appBloc.state.user!.id)) {
        add(SeenConversation(oldState.conversationId));
      }
    }
  }

  FutureOr<void> _onSeenConversation(
    SeenConversation event,
    Emitter<ConversationDetailsState> emit,
  ) async {
    final result = await seenConversationUC(
      SeenConversationParams(id: event.conversationId),
    );

    result.fold(
      (failure) => AppLogger.error(
        "Seen Conversation '${event.conversationId}; Failure: ${failure.toString()}",
      ),
      (success) {},
    );
  }

  FutureOr<void> _onUpdateMessageEvent(
    UpdateMessageEvent event,
    Emitter<ConversationDetailsState> emit,
  ) {
    if (state is CDSuccessfulState &&
        (state as CDSuccessfulState).conversationId ==
            event.updatedMessage['message']['conversationId']) {
      MessageModel msg = MessageModel.fromMap(event.updatedMessage['message']);
      final oldState = (state as CDSuccessfulState);

      List<MessageModel> _temp = [];
      for (var e in oldState.messages) {
        _temp.add(e.id == msg.id ? msg : e);
      }

      emit(oldState.copyWith(
        messages: _temp,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }
  }

  FutureOr<void> _onLoadMoreConversationDetails(
    LoadMoreConversationDetails event,
    Emitter<ConversationDetailsState> emit,
  ) async {
    if (state is CDInProgressState) return;

    // Previous value
    CDSuccessfulState preLoaded = state as CDSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getConversationMessagesUC(
      GetConversationMessagesParams(
        id: event.id,
        page: event.page,
        size: event.size,
      ),
    );

    result.fold(
      (failure) => emit(CDFailureState(failure.toString())),
      (response) => emit(preLoaded.copyWith(
        messages: [...preLoaded.messages, ...response.data],
        conversationId: event.id,
        hasReachedMax: response.pageIndex == response.totalPages,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      )),
    );
  }

  FutureOr<void> _onFirstMessageEvent(
    FirstMessageEvent event,
    Emitter<ConversationDetailsState> emit,
  ) async {
    emit(CDSuccessfulState(
      messages: [event.message],
      conversationId: event.message.conversationId,
      hasReachedMax: true,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));

    // Seen message đó luôn nếu  chưa có
    // if (appBloc.state.user != null &&
    //     !msg.seenIds.contains(appBloc.state.user!.id)) {
    //   add(SeenConversation(msg.conversationId));
    // }
  }

  FutureOr<void> _onGetSingleConversationByMembers(
    GetSingleConversationByMembers event,
    Emitter<ConversationDetailsState> emit,
  ) async {
    final result = await getConversationIdUC(
      GetConversationIdParams(event.targetId),
    );

    result.fold(
      (failure) => event.onError(failure.toString()),
      (response) => event.onSuccess(response),
    );
  }

  FutureOr<void> _onCreateGroupChatSubmit(
    CreateGroupChatSubmit event,
    Emitter<ConversationDetailsState> emit,
  ) async {
    final result = await createConversationUC(
      CreateConversationParams(
        name: event.name,
        memberIds: event.memberIds,
        message: "",
        attachments: [],
        type: MessageType.system,
      ),
    );

    result.fold(
      (failure) => event.onError(failure.toString()),
      (conversation) => event.onSuccess(conversation.id),
    );
  }
}
