import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../friend/data/data.dart';
import '../../../domain/domain.dart';

part 'user_friends_event.dart';
part 'user_friends_state.dart';

class UserFriendsBloc extends Bloc<UserFriendsEvent, UserFriendsState> {
  final GetUserFriendsUC getUserFriendsUC;

  UserFriendsBloc({
    required this.getUserFriendsUC,
  }) : super(UserFriendsInitialState()) {
    on<GetUserFriends>(_onGetUserFriends);
    on<LoadMoreUserFriends>(_onLoadMoreUserFriends);
  }

  FutureOr<void> _onGetUserFriends(
    GetUserFriends event,
    Emitter<UserFriendsState> emit,
  ) async {
    emit(UserFriendsInProgressState());

    final result = await getUserFriendsUC(GetUserFriendsParams(
      page: event.page,
      size: event.size,
      id: event.id,
    ));

    result.fold(
      (failure) => emit(UserFriendsFailureState(failure.toString())),
      (response) => emit(
        UserFriendsSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          friends: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreUserFriends(
    LoadMoreUserFriends event,
    Emitter<UserFriendsState> emit,
  ) async {
    if (state is UserFriendsInProgressState) return;

    // Previous value
    UserFriendsSuccessfulState preLoaded = state as UserFriendsSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getUserFriendsUC(GetUserFriendsParams(
      page: event.page,
      size: event.size,
      id: event.id,
    ));

    result.fold(
      (failure) => emit(UserFriendsFailureState(failure.toString())),
      (response) => emit(
        UserFriendsSuccessfulState(
          friends: [...preLoaded.friends, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }
}
