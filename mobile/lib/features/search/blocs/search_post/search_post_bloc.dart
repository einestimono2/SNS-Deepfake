import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils.dart';
import '../../../news_feed/data/data.dart';
import '../../domain/domain.dart';
import '../search_history/search_history_bloc.dart';

part 'search_post_event.dart';
part 'search_post_state.dart';

class SearchPostBloc extends Bloc<SearchPostEvent, SearchPostState> {
  final SearchPostUC searchPostUC;
  final SearchHistoryBloc searchHistoryBloc;

  SearchPostBloc({
    required this.searchPostUC,
    required this.searchHistoryBloc,
  }) : super(SearchPostInitialState()) {
    on<SearchPostSubmit>(_onSearchPostSubmit);
  }

  FutureOr<void> _onSearchPostSubmit(
    SearchPostSubmit event,
    Emitter<SearchPostState> emit,
  ) async {
    if (event.keyword.isEmpty) {
      emit(SearchPostInitialState());
      return;
    }

    emit(SearchPostInProgressState());

    final result = await searchPostUC(SearchPostParams(
      page: event.page,
      size: event.size,
      keyword: event.keyword,
      cache: event.saveHistory,
    ));

    result.fold(
      (failure) => emit(SearchPostFailureState(failure.toString())),
      (response) {
        emit(SearchPostSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          posts: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ));

        if (event.saveHistory) {
          searchHistoryBloc.add(AddSearchHistory(
            keyword: event.keyword,
            type: SearchHistoryType.post,
          ));
        }
      },
    );
  }
}
