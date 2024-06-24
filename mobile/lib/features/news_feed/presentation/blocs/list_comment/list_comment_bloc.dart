import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';

part 'list_comment_event.dart';
part 'list_comment_state.dart';

class ListCommentBloc extends Bloc<ListCommentEvent, ListCommentState> {
  final GetListCommentUC getListCommentUC;

  ListCommentBloc({
    required this.getListCommentUC,
  }) : super(ListCommentInitialState()) {
    on<GetListComment>(_onGetListComment);
    on<LoadMoreListComment>(_onLoadMoreListComment);
    on<UpdateListComment>(_onUpdateListComment);
  }

  FutureOr<void> _onGetListComment(
    GetListComment event,
    Emitter<ListCommentState> emit,
  ) async {
    emit(ListCommentInProgressState());

    final result = await getListCommentUC(GetListCommentParams(
      page: event.page,
      size: event.size,
      postId: event.postId,
    ));

    result.fold(
      (failure) => emit(ListCommentFailureState(failure.toString())),
      (response) => emit(
        ListCommentSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          comments: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreListComment(
    LoadMoreListComment event,
    Emitter<ListCommentState> emit,
  ) async {
    if (state is ListCommentInProgressState) return;

    // Previous value
    ListCommentSuccessfulState preLoaded = state as ListCommentSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getListCommentUC(GetListCommentParams(
      page: event.page,
      size: event.size,
      postId: event.postId,
    ));

    result.fold(
      (failure) => emit(ListCommentFailureState(failure.toString())),
      (response) => emit(
        ListCommentSuccessfulState(
          comments: [...preLoaded.comments, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onUpdateListComment(
    UpdateListComment event,
    Emitter<ListCommentState> emit,
  ) async {
    if (state is! ListCommentSuccessfulState) return;

    emit(ListCommentSuccessfulState(
      comments: event.comments,
      totalCount: event.totalCount,
      hasReachedMax: event.hasReachedMax,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
  }
}
