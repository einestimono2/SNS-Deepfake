import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/core/base/base_usecase.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

part 'list_schedule_event.dart';
part 'list_schedule_state.dart';

class ListScheduleBloc extends Bloc<ListScheduleEvent, ListScheduleState> {
  final GetListScheduleUC getListScheduleUC;
  final CreateScheduleUC createScheduleUC;
  final DeleteScheduleUC deleteScheduleUC;

  ListScheduleBloc({
    required this.getListScheduleUC,
    required this.createScheduleUC,
    required this.deleteScheduleUC,
  }) : super(ListScheduleInitialState()) {
    on<GetListSchedule>(_onGetListSchedule);
    on<LoadMoreListSchedule>(_onLoadMoreListSchedule);
    on<CreateScheduleSubmit>(_onCreateScheduleSubmit);
    on<DeleteScheduleSubmit>(_onDeleteScheduleSubmit);
  }

  FutureOr<void> _onGetListSchedule(
    GetListSchedule event,
    Emitter<ListScheduleState> emit,
  ) async {
    emit(ListScheduleInProgressState());

    final result = await getListScheduleUC(PaginationParams(
      page: event.page,
      size: event.size,
    ));

    result.fold(
      (failure) => emit(ListScheduleFailureState(failure.toString())),
      (response) => emit(
        ListScheduleSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          schedules: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreListSchedule(
    LoadMoreListSchedule event,
    Emitter<ListScheduleState> emit,
  ) async {
    if (state is ListScheduleInProgressState) return;

    // Previous value
    ListScheduleSuccessfulState preLoaded =
        state as ListScheduleSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getListScheduleUC(PaginationParams(
      page: event.page,
      size: event.size,
    ));

    result.fold(
      (failure) => emit(ListScheduleFailureState(failure.toString())),
      (response) => emit(
        ListScheduleSuccessfulState(
          schedules: [...preLoaded.schedules, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onCreateScheduleSubmit(
    CreateScheduleSubmit event,
    Emitter<ListScheduleState> emit,
  ) async {
    final result = await createScheduleUC(CreateScheduleParams(
      videoId: event.videoId,
      time: event.time,
      childId: event.childId,
      frequency: event.frequency,
    ));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (response) {
        event.onSuccess();
      },
    );
  }

  FutureOr<void> _onDeleteScheduleSubmit(
    DeleteScheduleSubmit event,
    Emitter<ListScheduleState> emit,
  ) async {
    final result = await deleteScheduleUC(IdParams(event.videoId));

    result.fold(
      (failure) => event.onError(failure.toString()),
      (response) {
        if (state is ListScheduleSuccessfulState) {
          ListScheduleSuccessfulState prestate =
              state as ListScheduleSuccessfulState;

          final data = prestate.schedules
              .where((element) => element.id != event.videoId)
              .toList();

          emit(prestate.copyWith(
            schedules: data,
            totalCount: data.length,
          ));
        }

        event.onSuccess();
      },
    );
  }
}
