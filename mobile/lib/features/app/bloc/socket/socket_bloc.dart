import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/chat/presentation/blocs/bloc.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../../config/configs.dart';
import '../../../../core/utils/utils.dart';
import '../../../chat/chat.dart';

part 'socket_event.dart';
part 'socket_state.dart';

class SocketBloc extends Bloc<SocketEvent, SocketState> {
  late final Socket _socket;
  final ConversationDetailsBloc conversationDetailsBloc;
  final MyConversationsBloc myConversationsBloc;
  final MessageBloc messageBloc;

  SocketBloc({
    required this.conversationDetailsBloc,
    required this.myConversationsBloc,
    required this.messageBloc,
  }) : super(SocketState.initial()) {
    _initSocket();

    on<OpenConnection>(_onOpenConnection);
    on<CloseConnection>(_onCloseConnection);
    on<SocketError>(_onSocketError);
    on<UpdateUserOnline>(_onUpdateUserOnline);
    on<JoinConversation>(_onJoinConversation);
    on<LeaveConversation>(_onLeaveConversation);
    on<TypingSubmit>(_onTypingSubmit);
  }

  void _initSocket() {
    _socket = io(
      FlavorConfig.instance.socketUrl,
      OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .disableAutoConnect() // disable auto-connection
          // .setQuery({"userId": event.userId})
          .enableReconnection()
          .setTimeout(3000)
          .build(),
    );

    _socket.onConnect((_) => log(
          "[SOCKET STATUS] Connected to socket server ${FlavorConfig.instance.socketUrl}",
        ));
    _socket.onDisconnect((_) => log(
          "[SOCKET STATUS] Disconnected to socket server ${FlavorConfig.instance.socketUrl}",
        ));
    // _socket.onConnectError((error) => add(SocketError(error, 'ConnectError')));
    _socket
        .onConnectTimeout((error) => add(SocketError(error, 'ConnectTimeout')));
    _socket.onError((data) => add(SocketError(data)));

    // My Events
    _socket.on(SocketEvents.USER_ONLINE, (data) {
      add(UpdateUserOnline(List<int>.from(data)));
    });
    _socket.on(
      SocketEvents.TYPING_START,
      (data) => messageBloc.add(TypingEvent(isTyping: true, data: data)),
    );
    _socket.on(
      SocketEvents.TYPING_END,
      (data) => messageBloc.add(TypingEvent(isTyping: false, data: data)),
    );
    _socket.on(
      SocketEvents.MESSAGE_NEW,
      (data) => conversationDetailsBloc.add(NewMessageEvent(newMessage: data)),
    );
    _socket.on(
      SocketEvents.MESSAGE_NEWS,
      (data) =>
          conversationDetailsBloc.add(NewMessagesEvent(newMessages: data)),
    );
    _socket.on(
      SocketEvents.MESSAGE_UPDATE,
      (data) =>
          conversationDetailsBloc.add(UpdateMessageEvent(updatedMessage: data)),
    );
    _socket.on(
      SocketEvents.CONVERSATION_LASTEST,
      (data) => myConversationsBloc.add(ConversationLastestEvent(data)),
    );
    _socket.on(
      SocketEvents.CONVERSATION_NEW,
      (data) {
        Map<String, dynamic> conversationMap = data['conversation'];
        conversationMap.addAll({
          "members": data['members'],
          "messages": [data['message']],
        });

        ConversationModel conversation =
            ConversationModel.fromMap(conversationMap);

        myConversationsBloc.add(ConversationNewEvent(conversation));
        conversationDetailsBloc
            .add(FirstMessageEvent(conversation.messages.first));
      },
    );
    _socket.on(
      SocketEvents.CONVERSATION_UPDATE,
      (data) {
        myConversationsBloc.add(ConversationUpdateEvent(data));
      },
    );
    _socket.on(
      SocketEvents.CONVERSATION_REMOVE,
      (data) {
        myConversationsBloc.add(ConversationRemoveEvent(
          int.parse("${data['conversationId']}"),
        ));
      },
    );
    _socket.on(
      SocketEvents.CONVERSATION_LEAVE,
      (data) {
        myConversationsBloc.add(ConversationLeaveEvent(data));
      },
    );
    _socket.on(
      SocketEvents.CONVERSATION_ADD_MEMBER,
      (data) {
        myConversationsBloc.add(ConversationAddMemberEvent(data));
      },
    );
  }

  @override
  Future<void> close() {
    _socket.dispose();
    return super.close();
  }

  FutureOr<void> _onOpenConnection(
    OpenConnection event,
    Emitter<SocketState> emit,
  ) {
    // Set query
    _socket.opts?['query'] = {"userId": event.userId};

    _socket.connect();

    emit(SocketState.connected());
  }

  FutureOr<void> _onCloseConnection(
    CloseConnection event,
    Emitter<SocketState> emit,
  ) {
    _socket.close();
    emit(SocketState.disconnected());
  }

  FutureOr<void> _onSocketError(
    SocketError event,
    Emitter<SocketState> emit,
  ) async {
    String msg = event.error.message ?? event.error.toString();

    if (event.type == state.errorMsg || msg == state.errorMsg) return;

    switch (event.type) {
      case "ConnectError":
        emit(state.copyWith(errorMsg: "ConnectError"));
        break;
      case "ConnectTimeout":
        emit(state.copyWith(errorMsg: "ConnectTimeout"));
        break;
      default:
        emit(state.copyWith(errorMsg: msg));
    }
  }

  FutureOr<void> _onUpdateUserOnline(
    UpdateUserOnline event,
    Emitter<SocketState> emit,
  ) {
    AppLogger.info("USER ONLINE: ${event.online}");
    emit(state.copyWith(online: event.online));
  }

  FutureOr<void> _onJoinConversation(
      JoinConversation event, Emitter<SocketState> emit) {
    _socket.emit(SocketEvents.CONVERSATION_JOIN, {
      "conversationId": event.conversationId,
    });
  }

  FutureOr<void> _onLeaveConversation(
      LeaveConversation event, Emitter<SocketState> emit) {
    _socket.emit(SocketEvents.CONVERSATION_LEAVE, {
      "conversationId": event.conversationId,
    });
  }

  FutureOr<void> _onTypingSubmit(
      TypingSubmit event, Emitter<SocketState> emit) {
    _socket.emit(
      event.isTyping ? SocketEvents.TYPING_START : SocketEvents.TYPING_END,
      {"members": event.members, "conversationId": event.conversationId},
    );
  }
}
