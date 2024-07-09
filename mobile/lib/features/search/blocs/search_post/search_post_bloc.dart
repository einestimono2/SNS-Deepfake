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
    on<UpdateSearchPostFeel>(_onUpdateSearchPostFeel);
    on<UpdateSearchPostComment>(_onUpdateSearchPostComment);
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

  FutureOr<void> _onUpdateSearchPostFeel(
    UpdateSearchPostFeel event,
    Emitter<SearchPostState> emit,
  ) async {
    if (state is! SearchPostSuccessfulState) return;

    // Previous value
    SearchPostSuccessfulState preLoaded = state as SearchPostSuccessfulState;

    int idx = preLoaded.posts.indexWhere((e) => e.id == event.postId);
    if (idx == -1) return;

    emit(preLoaded.copyWith(
      posts: preLoaded.posts.map((e) {
        if (e.id == event.postId) {
          return e.copyWith(
            kudosCount: event.kudosCount,
            disappointedCount: event.disappointedCount,
            myFeel: event.type,
          );
        } else {
          return e;
        }
      }).toList(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  FutureOr<void> _onUpdateSearchPostComment(
    UpdateSearchPostComment event,
    Emitter<SearchPostState> emit,
  ) async {
    if (state is! SearchPostSuccessfulState) return;

    // Previous value
    SearchPostSuccessfulState preLoaded = state as SearchPostSuccessfulState;

    int idx = preLoaded.posts.indexWhere((e) => e.id == event.postId);
    if (idx == -1 ||
        (preLoaded.posts[idx].fakeCount == event.fakeCounts &&
            preLoaded.posts[idx].trustCount == event.trustCounts)) return;

    emit(preLoaded.copyWith(
      posts: preLoaded.posts.map((e) {
        if (e.id == event.postId) {
          return e.copyWith(
            fakeCount: event.fakeCounts,
            trustCount: event.trustCounts,
          );
        } else {
          return e;
        }
      }).toList(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}
