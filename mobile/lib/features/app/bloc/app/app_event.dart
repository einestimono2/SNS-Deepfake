part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AppEvent {}

class ChangeUser extends AppEvent {
  final UserModel? user;
  final List<GroupModel>? groups;
  final int? groupIdx;

  const ChangeUser({
    this.user,
    this.groups,
    this.groupIdx,
  });

  @override
  List<Object?> get props => [user, groups, groupIdx];
}

class UpdateUserStatus extends AppEvent {
  final int status;

  const UpdateUserStatus({required this.status});

  @override
  List<Object?> get props => [status];
}

class UpdateCoin extends AppEvent {
  final int coin;

  const UpdateCoin(this.coin);

  @override
  List<Object?> get props => [coin];
}

class ChangeTheme extends AppEvent {
  final ThemeMode theme;

  const ChangeTheme({required this.theme});

  @override
  List<Object?> get props => [theme];
}

class ChangeSelectedGroup extends AppEvent {
  final int idx;

  const ChangeSelectedGroup({required this.idx});

  @override
  List<Object?> get props => [idx];
}
