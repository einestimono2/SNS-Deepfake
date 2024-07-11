part of 'list_schedule_bloc.dart';

sealed class ListScheduleEvent extends Equatable {
  const ListScheduleEvent();

  @override
  List<Object?> get props => [];
}

class GetListSchedule extends ListScheduleEvent {
  final int? page;
  final int? size;

  const GetListSchedule({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreListSchedule extends ListScheduleEvent {
  final int? page;
  final int? size;

  const LoadMoreListSchedule({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class CreateScheduleSubmit extends ListScheduleEvent {
  final int videoId;
  final int childId;
  final int frequency;
  final String time;
  final Function() onSuccess;
  final Function(String) onError;

  const CreateScheduleSubmit({
    required this.videoId,
    required this.childId,
    required this.frequency,
    required this.time,
    required this.onSuccess,
    required this.onError,
  });
}

class DeleteScheduleSubmit extends ListScheduleEvent {
  final int videoId;
  final Function() onSuccess;
  final Function(String) onError;

  const DeleteScheduleSubmit({
    required this.videoId,
    required this.onSuccess,
    required this.onError,
  });
}
