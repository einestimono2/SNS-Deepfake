import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/search/search.dart';

import '../../../../core/utils/utils.dart';
import '../../../friend/data/models/friend.model.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final SearchUserUC searchUserUC;
  final SearchHistoryBloc searchHistoryBloc;

  SearchUserBloc({
    required this.searchUserUC,
    required this.searchHistoryBloc,
  }) : super(SUInitialState()) {
    on<SearchUserSubmit>(_onSearchUserSubmit);
    on<ResetState>(_onResetState);
  }

  FutureOr<void> _onSearchUserSubmit(
    SearchUserSubmit event,
    Emitter<SearchUserState> emit,
  ) async {
    if (event.keyword.isEmpty) {
      emit(SUInitialState());
      return;
    }

    emit(SUInProgressState());

    final result = await searchUserUC(SearchUserParams(
      page: event.page,
      size: event.size,
      keyword: event.keyword,
      cache: event.saveHistory,
    ));

    result.fold(
      (failure) => emit(SUFailureState(failure.toString())),
      (response) {
        emit(SUSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          users: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));

        if (event.saveHistory) {
          searchHistoryBloc.add(AddSearchHistory(
            keyword: event.keyword,
            type: SearchHistoryType.user,
          ));
        }
      },
    );
  }

  FutureOr<void> _onResetState(
    ResetState event,
    Emitter<SearchUserState> emit,
  ) async {
    emit(SUInitialState());
  }
}
