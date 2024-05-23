import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/friend/friend.dart';

import '../../../../../core/base/base.dart';

part 'suggested_friends_event.dart';
part 'suggested_friends_state.dart';

class SuggestedFriendsBloc
    extends Bloc<SuggestedFriendsEvent, SuggestedFriendsState> {
  GetSuggestedFriendsUC getSuggestedFriendsUC;

  SuggestedFriendsBloc({
    required this.getSuggestedFriendsUC,
  }) : super(SFInitialState()) {
    on<GetSuggestedFriends>(_onGetSuggestedFriends);
    on<LoadMoreSuggestedFriends>(_onLoadMoreSuggestedFriends);
    on<RemoveSuggestedFriend>(_onRemoveSuggestedFriend);
  }

  FutureOr<void> _onGetSuggestedFriends(
    GetSuggestedFriends event,
    Emitter<SuggestedFriendsState> emit,
  ) async {
    emit(SFInProgressState());

    final result = await getSuggestedFriendsUC(
      PaginationParams(page: event.page, size: event.size),
    );

    result.fold(
      (failure) => emit(SFFailureState(failure.toString())),
      (response) => emit(
        SFSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          friends: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreSuggestedFriends(
    LoadMoreSuggestedFriends event,
    Emitter<SuggestedFriendsState> emit,
  ) async {
    if (state is SFInProgressState) return;

    // Previous value
    SFSuccessfulState preLoaded = state as SFSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getSuggestedFriendsUC(
      PaginationParams(page: event.page, size: event.size),
    );

    result.fold(
      (failure) => emit(SFFailureState(failure.toString())),
      (response) => emit(
        SFSuccessfulState(
          friends: [...preLoaded.friends, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onRemoveSuggestedFriend(
    RemoveSuggestedFriend event,
    Emitter<SuggestedFriendsState> emit,
  ) async {
    if (state is! SFSuccessfulState) return;

    final pre = state as SFSuccessfulState;
    pre.friends.removeWhere((element) => element.id == event.id);

    emit(pre.copyWith(friends: pre.friends, totalCount: pre.friends.length));
  }
}
