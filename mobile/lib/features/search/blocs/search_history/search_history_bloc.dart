import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/base.dart';
import '../../../../core/utils/utils.dart';
import '../../data/data.dart';
import '../../domain/domain.dart';

part 'search_history_event.dart';
part 'search_history_state.dart';

class SearchHistoryBloc extends Bloc<SearchHistoryEvent, SearchHistoryState> {
  GetSearchHistoryUC getSearchHistoryUC;
  DeleteSearchHistoryUC deleteSearchHistoryUC;

  SearchHistoryBloc({
    required this.getSearchHistoryUC,
    required this.deleteSearchHistoryUC,
  }) : super(SHInitialState()) {
    on<GetSearchHistory>(_onGetSearchHistory);
    on<AddSearchHistory>(_onAddSearchHistory);
    on<DeleteSearchHistory>(_onDeleteSearchHistory);
  }

  FutureOr<void> _onGetSearchHistory(
    GetSearchHistory event,
    Emitter<SearchHistoryState> emit,
  ) async {
    emit(SHInProgressState());

    final result = await getSearchHistoryUC(const PaginationParams());

    result.fold(
      (failure) => emit(SHFailureState(failure.toString())),
      (response) {
        List<SearchModel> users = [];
        List<SearchModel> posts = [];

        for (var e in response.data) {
          e.type == SearchHistoryType.user ? users.add(e) : posts.add(e);
        }

        emit(SHSuccessfulState(
          userHistories: users,
          postHistories: posts,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));
      },
    );
  }

  FutureOr<void> _onAddSearchHistory(
    AddSearchHistory event,
    Emitter<SearchHistoryState> emit,
  ) async {
    if (state is! SHSuccessfulState || event.keyword.isEmpty) return;

    SHSuccessfulState pre = state as SHSuccessfulState;
    if (event.type == SearchHistoryType.user) {
      if (pre.userHistories.indexWhere((e) => e.keyword == event.keyword) !=
          -1) {
        return;
      }

      SearchModel newSearch = SearchModel(
        keyword: event.keyword,
        type: event.type,
      );

      emit(pre.copyWith(userHistories: [newSearch, ...pre.userHistories]));
    } else {
      if (pre.postHistories.indexWhere((e) => e.keyword == event.keyword) !=
          -1) {
        return;
      }

      SearchModel newSearch = SearchModel(
        keyword: event.keyword,
        type: event.type,
      );

      emit(pre.copyWith(postHistories: [newSearch, ...pre.postHistories]));
    }
  }

  FutureOr<void> _onDeleteSearchHistory(
    DeleteSearchHistory event,
    Emitter<SearchHistoryState> emit,
  ) async {
    if (state is! SHSuccessfulState) return;

    SHSuccessfulState pre = state as SHSuccessfulState;

    if (event.all) {
      event.type == SearchHistoryType.user
          ? emit(pre.copyWith(
              userHistories: const [],
              timestamp: DateTime.now().millisecondsSinceEpoch,
            ))
          : emit(pre.copyWith(
              postHistories: const [],
              timestamp: DateTime.now().millisecondsSinceEpoch,
            ));
    } else if (event.type == SearchHistoryType.user) {
      int idx = pre.userHistories.indexWhere((e) => e.keyword == event.keyword);
      if (idx == -1) return;

      final list = pre.userHistories;
      list.removeAt(idx);

      emit(pre.copyWith(
        userHistories: list,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    } else {
      int idx = pre.postHistories.indexWhere((e) => e.keyword == event.keyword);
      if (idx == -1) return;

      final list = pre.postHistories;
      list.removeAt(idx);

      emit(pre.copyWith(
        postHistories: list,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      ));
    }

    await deleteSearchHistoryUC(DeleteSearchHistoryParams(
      keyword: event.keyword,
      type: event.type,
      all: event.all,
    ));
  }
}
