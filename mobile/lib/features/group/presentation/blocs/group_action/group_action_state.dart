part of 'group_action_bloc.dart';

sealed class GroupActionState extends Equatable {
  const GroupActionState();

  @override
  List<Object?> get props => [];
}

final class GroupActionInitialState extends GroupActionState {}

final class GroupActionInProgressState extends GroupActionState {}

class GroupActionSuccessfulState extends GroupActionState {
  final GroupModel? group;

  final int? timestamp;

  const GroupActionSuccessfulState({
    this.group,
    this.timestamp,
  });

  @override
  List<Object?> get props => [group, timestamp];

  GroupActionSuccessfulState copyWith({
    GroupModel? group,
    int? timestamp,
  }) {
    return GroupActionSuccessfulState(
      group: group ?? this.group,
      timestamp: timestamp,
    );
  }
}

final class GroupActionFailureState extends GroupActionState {
  final String message;

  const GroupActionFailureState(this.message);

  @override
  List<Object> get props => [message];
}
