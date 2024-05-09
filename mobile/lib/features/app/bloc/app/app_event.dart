part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AppEvent {}

class ChangeUser extends AppEvent {
  final UserModel? user;

  const ChangeUser({this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserStatus extends AppEvent {
  final int status;

  const UpdateUserStatus({required this.status});

  @override
  List<Object?> get props => [status];
}

class ChangeTheme extends AppEvent {
  final ThemeMode theme;

  const ChangeTheme({required this.theme});

  @override
  List<Object?> get props => [theme];
}
