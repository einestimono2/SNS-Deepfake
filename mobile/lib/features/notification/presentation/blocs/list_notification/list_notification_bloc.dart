import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/core/base/base_usecase.dart';

import '../../../data/data.dart';
import '../../../domain/domain.dart';

part 'list_notification_event.dart';
part 'list_notification_state.dart';

class ListNotificationBloc
    extends Bloc<ListNotificationEvent, ListNotificationState> {
  final GetListNotificationUC getListNotificationUC;

  ListNotificationBloc({
    required this.getListNotificationUC,
  }) : super(ListNotificationInitialState()) {
    on<GetListNotification>(_onGetListNotification);
    on<LoadMoreListNotification>(_onLoadMoreListNotification);
  }

  FutureOr<void> _onGetListNotification(
    GetListNotification event,
    Emitter<ListNotificationState> emit,
  ) async {
    emit(ListNotificationInProgressState());

    final result = await getListNotificationUC(PaginationParams(
      page: event.page,
      size: event.size,
    ));

    result.fold(
      (failure) => emit(ListNotificationFailureState(failure.toString())),
      (response) => emit(
        ListNotificationSuccessfulState(
          hasReachedMax: response.pageIndex == response.totalPages,
          notifications: response.data,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }

  FutureOr<void> _onLoadMoreListNotification(
    LoadMoreListNotification event,
    Emitter<ListNotificationState> emit,
  ) async {
    if (state is ListNotificationInProgressState) return;

    // Previous value
    ListNotificationSuccessfulState preLoaded =
        state as ListNotificationSuccessfulState;
    if (preLoaded.hasReachedMax) return;

    final result = await getListNotificationUC(PaginationParams(
      page: event.page,
      size: event.size,
    ));

    result.fold(
      (failure) => emit(ListNotificationFailureState(failure.toString())),
      (response) => emit(
        ListNotificationSuccessfulState(
          notifications: [...preLoaded.notifications, ...response.data],
          hasReachedMax: response.pageIndex == response.totalPages,
          totalCount: response.totalCount,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ),
    );
  }
}
