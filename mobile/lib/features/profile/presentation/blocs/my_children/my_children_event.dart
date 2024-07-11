part of 'my_children_bloc.dart';

sealed class MyChildrenEvent extends Equatable {
  const MyChildrenEvent();

  @override
  List<Object> get props => [];
}

class GetMyChildren extends MyChildrenEvent {}
