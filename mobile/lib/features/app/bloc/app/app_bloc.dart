import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/errors/failures.dart';

import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../../../../core/utils/utils.dart';
import '../../../authentication/authentication.dart';
import '../../../group/group.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final GetUserUC getUserUC;
  final LocalCache localCache;

  AppBloc({
    required this.getUserUC,
    required this.localCache,
  }) : super(AppState()) {
    on<AppStarted>(_onAppStarted);
    on<ChangeSelectedGroup>(_onChangeSelectedGroup);
    on<ChangeUser>(_onChangeUser);
    on<UpdateUserStatus>(_onUpdateUserStatus);
    on<ChangeTheme>(_onChangeTheme);
  }

  FutureOr<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    final themeModeStr = localCache.getValue<String>(AppStrings.themeModeKey) ??
        ThemeMode.system.name;
    final groupIdx = localCache.getValue<int>(AppStrings.selectedGroupKey) ?? 0;
    UserModel? user;
    List<GroupModel> groups = [];
    AuthStatus authStatus = AuthStatus.unauthenticated;

    /* ==================== VERIFY TOKEN ==================== */
    if (localCache.isKeyExists(AppStrings.accessTokenKey)) {
      final result = await getUserUC(NoParams());

      result.fold(
        (failure) {
          // Không xử lý nếu k có mạng
          if (failure is OfflineFailure) {
            authStatus = AuthStatus.unknown;
          }
        },
        (_map) {
          AppLogger.info('Access Token: ${_map['user'].token}');
          user = _map['user'];
          groups = _map['groups'];
          authStatus = AuthStatus.authenticated;

          // authStatus = AuthStatus.unauthenticated;
        },
      );
    }

    emit(state.copyWith(
      user: user,
      authStatus: authStatus,
      groupIdx: groupIdx,
      groups: groups,
      theme: ThemeMode.values.byName(themeModeStr),
    ));
  }

  FutureOr<void> _onChangeUser(ChangeUser event, Emitter<AppState> emit) async {
    emit(state.copyWith(
      user: event.user,
      groups: event.groups,
      groupIdx: event.groupIdx,
      authStatus: event.user == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated,
    ));

    if (event.groupIdx != null) {
      await localCache.putValue<int>(
        AppStrings.selectedGroupKey,
        event.groupIdx!,
      );

      final token = event.user?.token ?? state.user?.token;
      if (token != null) {
        await localCache.putValue(AppStrings.accessTokenKey, token);
        // await localCache.putValue(
        //   AppStrings.userKey,
        //   (event.user ?? state.user!).toJson(),
        // );
      }
    }
  }

  FutureOr<void> _onChangeTheme(
      ChangeTheme event, Emitter<AppState> emit) async {
    await localCache
        .putValue<String>(AppStrings.themeModeKey, event.theme.name)
        .whenComplete(
          () => emit(state.copyWith(user: state.user, theme: event.theme)),
        );
  }

  FutureOr<void> _onUpdateUserStatus(
    UpdateUserStatus event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(
      user: state.user?.copyWith(status: event.status),
    ));
  }

  FutureOr<void> _onChangeSelectedGroup(
    ChangeSelectedGroup event,
    Emitter<AppState> emit,
  ) async {
    await localCache
        .putValue<int>(AppStrings.selectedGroupKey, event.idx)
        .whenComplete(() => emit(
              state.copyWith(user: state.user, groupIdx: event.idx),
            ));
  }
}
