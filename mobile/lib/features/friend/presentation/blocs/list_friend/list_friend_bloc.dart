import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/base/base.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';

part 'list_friend_event.dart';
part 'list_friend_state.dart';

class ListFriendBloc extends Bloc<ListFriendEvent, ListFriendState> {
  GetListFriendUC getListFriendUC;

  ListFriendBloc({
    required this.getListFriendUC,
  }) : super(LFInProgressState()) {
    on<GetListFriend>(_onGetListFriend);
    on<LoadMoreListFriend>(_onLoadMoreListFriend);
  }

  FutureOr<void> _onGetListFriend(
    GetListFriend event,
    Emitter<ListFriendState> emit,
  ) async {
    emit(LFInProgressState());

    final result = await getListFriendUC(
      PaginationParams(page: event.page, size: event.size),
    );

    result.fold(
      (failure) => emit(LFFailureState(failure.toString())),
      (response) => emit(
        LFSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          friends: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreListFriend(
    LoadMoreListFriend event,
    Emitter<ListFriendState> emit,
  ) async {
    if (state is LFInProgressState) return;

    // Previous value
    LFSuccessfulState preLoaded = state as LFSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getListFriendUC(
      PaginationParams(page: event.page, size: event.size),
    );

    result.fold(
      (failure) => emit(LFFailureState(failure.toString())),
      (response) => emit(
        LFSuccessfulState(
          friends: [...preLoaded.friends, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }
}
