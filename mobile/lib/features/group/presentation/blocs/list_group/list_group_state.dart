part of 'list_group_bloc.dart';

sealed class ListGroupState extends Equatable {
  const ListGroupState();

  @override
  List<Object> get props => [];
}

final class ListGroupInitialState extends ListGroupState {}

final class ListGroupInProgressState extends ListGroupState {}

class ListGroupSuccessfulState extends ListGroupState {}

class ListGroupFailureState extends ListGroupState {
  final String message;

  const ListGroupFailureState(this.message);

  @override
  List<Object> get props => [message];
}
