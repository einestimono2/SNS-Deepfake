import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

part 'my_video_deepfake_event.dart';
part 'my_video_deepfake_state.dart';

class MyVideoDeepfakeBloc
    extends Bloc<MyVideoDeepfakeEvent, MyVideoDeepfakeState> {
  final GetListVideoDeepfakeUC getListVideoDeepfakeUC;

  MyVideoDeepfakeBloc({
    required this.getListVideoDeepfakeUC,
  }) : super(MyVideoDeepfakeInitialState()) {
    on<GetMyVideoDeepfakes>(_onGetMyVideoDeepfakes);
    on<LoadMoreMyVideoDeepfakes>(_onLoadMoreMyVideoDeepfakes);
  }

  FutureOr<void> _onGetMyVideoDeepfakes(
    GetMyVideoDeepfakes event,
    Emitter<MyVideoDeepfakeState> emit,
  ) async {
    emit(MyVideoDeepfakeInProgressState());

    final result = await getListVideoDeepfakeUC(GetListVideoDeepfakeParams(
      page: event.page,
      size: event.size,
      type: 1,
    ));

    result.fold(
      (failure) => emit(MyVideoDeepfakeFailureState(failure.toString())),
      (response) => emit(
        MyVideoDeepfakeSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          videos: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreMyVideoDeepfakes(
    LoadMoreMyVideoDeepfakes event,
    Emitter<MyVideoDeepfakeState> emit,
  ) async {
    if (state is MyVideoDeepfakeInProgressState) return;

    // Previous value
    MyVideoDeepfakeSuccessfulState preLoaded =
        state as MyVideoDeepfakeSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getListVideoDeepfakeUC(GetListVideoDeepfakeParams(
      page: event.page,
      size: event.size,
      type: 1,
    ));

    result.fold(
      (failure) => emit(MyVideoDeepfakeFailureState(failure.toString())),
      (response) => emit(
        MyVideoDeepfakeSuccessfulState(
          videos: [...preLoaded.videos, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }
}
