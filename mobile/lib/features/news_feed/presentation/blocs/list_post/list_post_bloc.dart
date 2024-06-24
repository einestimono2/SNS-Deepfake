import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/post_model.dart';
import '../../../domain/domain.dart';

part 'list_post_event.dart';
part 'list_post_state.dart';

class ListPostBloc extends Bloc<ListPostEvent, ListPostState> {
  GetListPostUC getListPostUC;

  ListPostBloc({
    required this.getListPostUC,
  }) : super(ListPostInitialState()) {
    on<GetListPost>(_onGetListPost);
    on<LoadMoreListPost>(_onLoadMoreListPost);
    on<AddPost>(_onAddPost);
    on<DeletePost>(_onDeletePost);
    on<UpdateCommentSummary>(_onUpdateCommentSummary);
    on<UpdateFeelSummary>(_onUpdateFeelSummary);
  }

  FutureOr<void> _onGetListPost(
    GetListPost event,
    Emitter<ListPostState> emit,
  ) async {
    emit(ListPostInProgressState());

    final result = await getListPostUC(GetListPostParams(
      page: event.page,
      size: event.size,
      groupId: event.groupId,
    ));

    result.fold(
      (failure) => emit(ListPostFailureState(failure.toString())),
      (response) => emit(
        ListPostSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          posts: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreListPost(
    LoadMoreListPost event,
    Emitter<ListPostState> emit,
  ) async {
    if (state is ListPostInProgressState) return;

    // Previous value
    ListPostSuccessfulState preLoaded = state as ListPostSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getListPostUC(GetListPostParams(
      page: event.page,
      size: event.size,
      groupId: event.groupId,
    ));

    result.fold(
      (failure) => emit(ListPostFailureState(failure.toString())),
      (response) => emit(
        ListPostSuccessfulState(
          posts: [...preLoaded.posts, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onAddPost(
    AddPost event,
    Emitter<ListPostState> emit,
  ) async {
    if (state is! ListPostSuccessfulState) return;

    // Previous value
    ListPostSuccessfulState preLoaded = state as ListPostSuccessfulState;

    emit(ListPostSuccessfulState(
      posts: [event.post, ...preLoaded.posts],
      totalCount: preLoaded.totalCount + 1,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  FutureOr<void> _onDeletePost(
    DeletePost event,
    Emitter<ListPostState> emit,
  ) async {
    if (state is! ListPostSuccessfulState) return;

    // Previous value
    ListPostSuccessfulState preLoaded = state as ListPostSuccessfulState;

    int idx = preLoaded.posts.indexWhere((e) => e.id == event.postId);
    if (idx == -1) return;

    preLoaded.posts.removeAt(idx);

    emit(ListPostSuccessfulState(
      posts: preLoaded.posts,
      totalCount: preLoaded.totalCount - 1,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  FutureOr<void> _onUpdateCommentSummary(
    UpdateCommentSummary event,
    Emitter<ListPostState> emit,
  ) async {
    if (state is! ListPostSuccessfulState) return;

    // Previous value
    ListPostSuccessfulState preLoaded = state as ListPostSuccessfulState;

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

  FutureOr<void> _onUpdateFeelSummary(
    UpdateFeelSummary event,
    Emitter<ListPostState> emit,
  ) async {
    if (state is! ListPostSuccessfulState) return;

    // Previous value
    ListPostSuccessfulState preLoaded = state as ListPostSuccessfulState;

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
}
