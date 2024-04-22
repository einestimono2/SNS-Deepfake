part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

final class InitialState extends UserState {}

final class InProgressState extends UserState {}

final class SuccessfulState extends UserState {
  final String? type;

  const SuccessfulState({this.type});

  @override
  List<Object?> get props => [type];
}

final class FailureState extends UserState {
  final String message;
  final String? type;

  const FailureState({required this.message, this.type});

  @override
  List<Object?> get props => [message, type];
}
