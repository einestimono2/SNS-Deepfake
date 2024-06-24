import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../news_feed/data/data.dart';
import '../../../domain/domain.dart';

part 'my_posts_event.dart';
part 'my_posts_state.dart';

class MyPostsBloc extends Bloc<MyPostsEvent, MyPostsState> {
  final MyPostsUC getMyPosts;

  MyPostsBloc({
    required this.getMyPosts,
  }) : super(MyPostsInitialState()) {
    on<GetMyPosts>(_onGetMyPosts);
    on<LoadMoreMyPosts>(_onLoadMoreMyPosts);
    on<AddMyPost>(_onAddMyPost);
  }

  FutureOr<void> _onGetMyPosts(
    GetMyPosts event,
    Emitter<MyPostsState> emit,
  ) async {
    emit(MyPostsInProgressState());

    final result = await getMyPosts(PaginationParams(
      page: event.page,
      size: event.size,
    ));

    result.fold(
      (failure) => emit(MyPostsFailureState(failure.toString())),
      (response) => emit(
        MyPostsSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          posts: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreMyPosts(
    LoadMoreMyPosts event,
    Emitter<MyPostsState> emit,
  ) async {
    if (state is MyPostsInProgressState) return;

    // Previous value
    MyPostsSuccessfulState preLoaded = state as MyPostsSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getMyPosts(PaginationParams(
      page: event.page,
      size: event.size,
    ));

    result.fold(
      (failure) => emit(MyPostsFailureState(failure.toString())),
      (response) => emit(
        MyPostsSuccessfulState(
          posts: [...preLoaded.posts, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onAddMyPost(
    AddMyPost event,
    Emitter<MyPostsState> emit,
  ) async {
    if (state is! MyPostsSuccessfulState) return;

    final preState = state as MyPostsSuccessfulState;

    emit(preState.copyWith(
      totalCount: preState.totalCount + 1,
      posts: [event.post, ...preState.posts],
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}
