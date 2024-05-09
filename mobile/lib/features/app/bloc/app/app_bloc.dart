import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/errors/failures.dart';

import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../../../../core/utils/utils.dart';
import '../../../authentication/authentication.dart';

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
    on<ChangeUser>(_onChangeUser);
    on<UpdateUserStatus>(_onUpdateUserStatus);
    on<ChangeTheme>(_onChangeTheme);
  }

  FutureOr<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    final themeModeStr =
        localCache.getString(AppStrings.themeModeKey) ?? ThemeMode.system.name;
    UserModel? user;
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
        (_user) {
          AppLogger.info('Access Token: ${_user!.token}\nUser: $_user');
          user = _user;
          authStatus = AuthStatus.authenticated;
          // authStatus = AuthStatus.unauthenticated;
        },
      );
    }

    emit(state.copyWith(
      user: user,
      authStatus: authStatus,
      theme: ThemeMode.values.byName(themeModeStr),
    ));
  }

  FutureOr<void> _onChangeUser(ChangeUser event, Emitter<AppState> emit) {
    emit(state.copyWith(
      user: event.user,
      authStatus: event.user == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated,
    ));
  }

  FutureOr<void> _onChangeTheme(
      ChangeTheme event, Emitter<AppState> emit) async {
    await localCache
        .putString(AppStrings.themeModeKey, event.theme.name)
        .whenComplete(() => emit(state.copyWith(theme: event.theme)));
  }

  FutureOr<void> _onUpdateUserStatus(
    UpdateUserStatus event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(
      user: state.user?.copyWith(status: event.status),
    ));
  }
}
