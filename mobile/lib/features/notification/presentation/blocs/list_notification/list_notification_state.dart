part of 'list_notification_bloc.dart';

sealed class ListNotificationState extends Equatable {
  const ListNotificationState();

  @override
  List<Object?> get props => [];
}

final class ListNotificationInitialState extends ListNotificationState {}

final class ListNotificationInProgressState extends ListNotificationState {}

class ListNotificationSuccessfulState extends ListNotificationState {
  final List<NotificationModel> notifications;
  final bool hasReachedMax;
  final int totalCount;

  /* Để rebuild bloc khi emit cùng state (vẫn conversation cũ nhưng trường list có phần tử thay đổi ) */
  final int? timestamp;

  const ListNotificationSuccessfulState({
    required this.notifications,
    required this.hasReachedMax,
    required this.totalCount,
    this.timestamp,
  });

  @override
  List<Object?> get props => [
        totalCount,
        notifications,
        timestamp,
        hasReachedMax,
      ];

  ListNotificationSuccessfulState copyWith({
    int? totalCount,
    List<NotificationModel>? notifications,
    bool? hasReachedMax,
    int? timestamp,
  }) {
    return ListNotificationSuccessfulState(
      notifications: notifications ?? this.notifications,
      totalCount: totalCount ?? this.totalCount,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class ListNotificationFailureState extends ListNotificationState {
  final String message;

  const ListNotificationFailureState(this.message);

  @override
  List<Object> get props => [message];
}
