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
}
