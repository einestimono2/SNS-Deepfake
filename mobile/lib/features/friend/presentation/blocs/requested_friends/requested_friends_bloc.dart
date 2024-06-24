import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/core/base/base_usecase.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';

part 'requested_friends_event.dart';
part 'requested_friends_state.dart';

class RequestedFriendsBloc
    extends Bloc<RequestedFriendsEvent, RequestedFriendsState> {
  GetRequestedFriendsUC getRequestedFriendsUC;

  RequestedFriendsBloc({
    required this.getRequestedFriendsUC,
  }) : super(RFInitialState()) {
    on<GetRequestedFriends>(_onGetRequestedFriends);
    on<LoadMoreRequestedFriends>(_onLoadMoreRequestedFriends);
    on<DeleteRequest>(_onDeleteRequest);
  }

  FutureOr<void> _onGetRequestedFriends(
    GetRequestedFriends event,
    Emitter<RequestedFriendsState> emit,
  ) async {
    emit(RFInProgressState());

    final result = await getRequestedFriendsUC(
      PaginationParams(page: event.page, size: event.size),
    );

    result.fold(
      (failure) => emit(RFFailureState(failure.toString())),
      (response) => emit(
        RFSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          friends: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreRequestedFriends(
    LoadMoreRequestedFriends event,
    Emitter<RequestedFriendsState> emit,
  ) async {
    if (state is RFInProgressState) return;

    // Previous value
    RFSuccessfulState preLoaded = state as RFSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getRequestedFriendsUC(
      PaginationParams(page: event.page, size: event.size),
    );

    result.fold(
      (failure) => emit(RFFailureState(failure.toString())),
      (response) => emit(
        RFSuccessfulState(
          friends: [...preLoaded.friends, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onDeleteRequest(
    DeleteRequest event,
    Emitter<RequestedFriendsState> emit,
  ) async {
    if (state is! RFSuccessfulState) return;

    RFSuccessfulState preLoaded = state as RFSuccessfulState;
    final _request = preLoaded.friends.where((e) => e.id != event.id).toList();
    emit(preLoaded.copyWith(
      friends: _request,
      totalCount: _request.length,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}
