import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/domain.dart';

part 'friend_action_event.dart';
part 'friend_action_state.dart';

const acceptRequestType = "FA_ACCEPT_REQUEST";
const refuseRequestType = "FA_REFUSE_REQUEST";
const sendRequestType = "FA_SEND_REQUEST";
const unfriendType = "FA_UNFRIEND";

class FriendActionBloc extends Bloc<FriendActionEvent, FriendActionState> {
  final AcceptRequestUC acceptRequestUC;
  final RefuseRequestUC refuseRequestUC;
  final SendRequestUC sendRequestUC;
  final UnfriendUC unfriendUC;

  FriendActionBloc({
    required this.acceptRequestUC,
    required this.refuseRequestUC,
    required this.sendRequestUC,
    required this.unfriendUC,
  }) : super(FAInitialState()) {
    on<AcceptRequestSubmit>(_onAcceptRequestSubmit);
    on<RefuseRequestSubmit>(_onRefuseRequestSubmit);
    on<SendRequestSubmit>(_onSendRequestSubmit);
    on<UnfriendSubmit>(_onUnfriendSubmit);
  }

  FutureOr<void> _onAcceptRequestSubmit(
    AcceptRequestSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    emit(FAInProgressState());

    final result = await acceptRequestUC(AcceptRequestParams(event.targetId));

    result.fold(
      (failure) => emit(FAFailureState(
        message: failure.toString(),
        type: acceptRequestType,
        id: event.targetId,
      )),
      (success) => emit(FASuccessfulState(
        type: acceptRequestType,
        id: event.targetId,
      )),
    );
  }

  FutureOr<void> _onRefuseRequestSubmit(
    RefuseRequestSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    emit(FAInProgressState());

    final result = await refuseRequestUC(RefuseRequestParams(event.targetId));

    result.fold(
      (failure) => emit(FAFailureState(
        message: failure.toString(),
        type: refuseRequestType,
        id: event.targetId,
      )),
      (success) => emit(FASuccessfulState(
        type: refuseRequestType,
        id: event.targetId,
      )),
    );
  }

  FutureOr<void> _onSendRequestSubmit(
    SendRequestSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    emit(FAInProgressState());

    final result = await sendRequestUC(SendRequestParams(event.targetId));

    result.fold(
      (failure) => emit(FAFailureState(
        message: failure.toString(),
        type: sendRequestType,
        id: event.targetId,
      )),
      (success) => emit(FASuccessfulState(
        type: sendRequestType,
        id: event.targetId,
      )),
    );
  }

  FutureOr<void> _onUnfriendSubmit(
    UnfriendSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    emit(FAInProgressState());

    final result = await unfriendUC(UnfriendParams(event.targetId));

    result.fold(
      (failure) => emit(FAFailureState(
        message: failure.toString(),
        type: unfriendType,
        id: event.targetId,
      )),
      (success) => emit(FASuccessfulState(
        type: unfriendType,
        id: event.targetId,
      )),
    );
  }
}
