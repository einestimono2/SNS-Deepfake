part of 'my_children_bloc.dart';

sealed class MyChildrenState extends Equatable {
  const MyChildrenState();

  @override
  List<Object> get props => [];
}

final class MyChildrenInitialState extends MyChildrenState {}

final class MyChildrenInProgressState extends MyChildrenState {}

final class MyChildrenSuccessfulState extends MyChildrenState {
  final List<ShortUserModel> children;

  const MyChildrenSuccessfulState(this.children);

  @override
  List<Object> get props => [children];
}

final class MyChildrenFailureState extends MyChildrenState {
  final String message;

  const MyChildrenFailureState(this.message);

  @override
  List<Object> get props => [message];
}
