part of 'list_schedule_bloc.dart';

sealed class ListScheduleState extends Equatable {
  const ListScheduleState();

  @override
  List<Object?> get props => [];
}

final class ListScheduleInitialState extends ListScheduleState {}

final class ListScheduleInProgressState extends ListScheduleState {}

final class ListScheduleSuccessfulState extends ListScheduleState {
  final List<VideoScheduleModel> schedules;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const ListScheduleSuccessfulState({
    required this.schedules,
    this.hasReachedMax = false,
    this.timestamp,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [
        totalCount,
        schedules,
        timestamp,
        hasReachedMax,
      ];

  ListScheduleSuccessfulState copyWith({
    int? totalCount,
    List<VideoScheduleModel>? schedules,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return ListScheduleSuccessfulState(
      schedules: schedules ?? this.schedules,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

final class ListScheduleFailureState extends ListScheduleState {
  final String message;

  const ListScheduleFailureState(this.message);

  @override
  List<Object> get props => [message];
}
