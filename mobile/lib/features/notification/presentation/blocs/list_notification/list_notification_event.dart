part of 'list_notification_bloc.dart';

sealed class ListNotificationEvent extends Equatable {
  const ListNotificationEvent();

  @override
  List<Object?> get props => [];
}

class GetListNotification extends ListNotificationEvent {
  final int? page;
  final int? size;

  const GetListNotification({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}

class LoadMoreListNotification extends ListNotificationEvent {
  final int? page;
  final int? size;

  const LoadMoreListNotification({
    this.page,
    this.size,
  });

  @override
  List<Object?> get props => [page, size];
}
