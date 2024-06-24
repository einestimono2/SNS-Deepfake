import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/profile/domain/usecases/get_user_posts_uc.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../news_feed/data/data.dart';
import '../../../domain/domain.dart';

part 'user_posts_event.dart';
part 'user_posts_state.dart';

class UserPostsBloc extends Bloc<UserPostsEvent, UserPostsState> {
  final GetUserPostsUC getUserPostsUC;

  UserPostsBloc({
    required this.getUserPostsUC,
  }) : super(UserPostsInitialState()) {
    on<GetUserPosts>(_onGetUserPosts);
    on<LoadMoreUserPosts>(_onLoadMoreUserPosts);
  }

  FutureOr<void> _onGetUserPosts(
    GetUserPosts event,
    Emitter<UserPostsState> emit,
  ) async {
    emit(UserPostsInProgressState());

    final result = await getUserPostsUC(GetUserPostsParams(
      page: event.page,
      size: event.size,
      id: event.id,
    ));

    result.fold(
      (failure) => emit(UserPostsFailureState(failure.toString())),
      (response) => emit(
        UserPostsSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          posts: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreUserPosts(
    LoadMoreUserPosts event,
    Emitter<UserPostsState> emit,
  ) async {
    if (state is! UserPostsSuccessfulState) return;

    // Previous value
    UserPostsSuccessfulState preLoaded = state as UserPostsSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getUserPostsUC(GetUserPostsParams(
      page: event.page,
      size: event.size,
      id: event.id,
    ));

    result.fold(
      (failure) => emit(UserPostsFailureState(failure.toString())),
      (response) => emit(
        UserPostsSuccessfulState(
          posts: [...preLoaded.posts, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }
}
