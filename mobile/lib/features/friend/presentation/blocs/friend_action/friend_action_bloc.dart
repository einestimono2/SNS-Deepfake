import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/friend/friend.dart';

import '../../../domain/domain.dart';

part 'friend_action_event.dart';
part 'friend_action_state.dart';

class FriendActionBloc extends Bloc<FriendActionEvent, FriendActionState> {
  final AcceptRequestUC acceptRequestUC;
  final RefuseRequestUC refuseRequestUC;
  final SendRequestUC sendRequestUC;
  final UnfriendUC unfriendUC;
  final UnsentRequestUC unsentRequestUC;

  FriendActionBloc({
    required this.acceptRequestUC,
    required this.refuseRequestUC,
    required this.sendRequestUC,
    required this.unfriendUC,
    required this.unsentRequestUC,
  }) : super(FAInitialState()) {
    on<AcceptRequestSubmit>(_onAcceptRequestSubmit);
    on<RefuseRequestSubmit>(_onRefuseRequestSubmit);
    on<SendRequestSubmit>(_onSendRequestSubmit);
    on<UnsentRequestSubmit>(_onUnsentRequestSubmit);
    on<UnfriendSubmit>(_onUnfriendSubmit);
  }

  FutureOr<void> _onAcceptRequestSubmit(
    AcceptRequestSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    final result = await acceptRequestUC(AcceptRequestParams(event.targetId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (success) => event.onSuccess(),
    );
  }

  FutureOr<void> _onRefuseRequestSubmit(
    RefuseRequestSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    final result = await refuseRequestUC(RefuseRequestParams(event.targetId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (success) => event.onSuccess(),
    );
  }

  FutureOr<void> _onSendRequestSubmit(
    SendRequestSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    final result = await sendRequestUC(SendRequestParams(event.targetId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (success) => event.onSuccess(),
    );
  }

  FutureOr<void> _onUnfriendSubmit(
    UnfriendSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    final result = await unfriendUC(UnfriendParams(event.targetId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (success) => event.onSuccess(),
    );
  }

  FutureOr<void> _onUnsentRequestSubmit(
    UnsentRequestSubmit event,
    Emitter<FriendActionState> emit,
  ) async {
    final result = await unsentRequestUC(UnsentRequestParams(event.targetId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (success) => event.onSuccess(),
    );
  }
}
