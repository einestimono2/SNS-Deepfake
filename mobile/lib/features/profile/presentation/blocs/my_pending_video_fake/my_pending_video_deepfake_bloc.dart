import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';

part 'my_pending_video_deepfake_event.dart';
part 'my_pending_video_deepfake_state.dart';

class MyPendingVideoDeepfakeBloc
    extends Bloc<MyPendingVideoDeepfakeEvent, MyPendingVideoDeepfakeState> {
  final GetListVideoDeepfakeUC getListVideoDeepfakeUC;

  MyPendingVideoDeepfakeBloc({
    required this.getListVideoDeepfakeUC,
  }) : super(MyPendingVideoDeepfakeInitialState()) {
    on<GetMyPendingVideoDeepfakes>(_onGetMyPendingVideoDeepfakes);
    on<LoadMoreMyPendingVideoDeepfakes>(_onLoadMoreMyPendingVideoDeepfakes);
    on<AddPendingVideo>(_onAddPendingVideo);
  }

  FutureOr<void> _onGetMyPendingVideoDeepfakes(
    GetMyPendingVideoDeepfakes event,
    Emitter<MyPendingVideoDeepfakeState> emit,
  ) async {
    emit(MyPendingVideoDeepfakeInProgressState());

    final result = await getListVideoDeepfakeUC(GetListVideoDeepfakeParams(
      page: event.page,
      size: event.size,
      type: 0,
    ));

    result.fold(
      (failure) => emit(MyPendingVideoDeepfakeFailureState(failure.toString())),
      (response) => emit(
        MyPendingVideoDeepfakeSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          videos: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreMyPendingVideoDeepfakes(
    LoadMoreMyPendingVideoDeepfakes event,
    Emitter<MyPendingVideoDeepfakeState> emit,
  ) async {
    if (state is MyPendingVideoDeepfakeInProgressState) return;

    // Previous value
    MyPendingVideoDeepfakeSuccessfulState preLoaded =
        state as MyPendingVideoDeepfakeSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getListVideoDeepfakeUC(GetListVideoDeepfakeParams(
      page: event.page,
      size: event.size,
      type: 0,
    ));

    result.fold(
      (failure) => emit(MyPendingVideoDeepfakeFailureState(failure.toString())),
      (response) => emit(
        MyPendingVideoDeepfakeSuccessfulState(
          videos: [...preLoaded.videos, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onAddPendingVideo(
    AddPendingVideo event,
    Emitter<MyPendingVideoDeepfakeState> emit,
  ) async {
    if (state is! MyPendingVideoDeepfakeSuccessfulState) {
      emit(MyPendingVideoDeepfakeSuccessfulState(
        totalCount: 1,
        hasReachedMax: true,
        videos: [event.video],
      ));

      return;
    }

    // Previous value
    final preLoaded = state as MyPendingVideoDeepfakeSuccessfulState;

    emit(preLoaded.copyWith(
      totalCount: preLoaded.totalCount + 1,
      videos: [event.video, ...preLoaded.videos],
    ));
  }
}
