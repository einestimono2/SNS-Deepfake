part of 'app_bloc.dart';

class AppState extends Equatable {
  final AuthStatus authStatus;
  final ThemeMode theme;
  final UserModel? user;
  final List<GroupModel> groups;
  final int? groupIdx;

  @override
  List<Object?> get props => [authStatus, user, theme, groups];

  const AppState._({
    this.authStatus = AuthStatus.unknown,
    this.user,
    this.groups = const [],
    this.groupIdx,
    this.theme = ThemeMode.system,
  });

  factory AppState() => const AppState._();

  AppState copyWith({
    AuthStatus? authStatus,
    UserModel? user,
    ThemeMode? theme,
    List<GroupModel>? groups,
    int? groupIdx,
  }) =>
      AppState._(
        authStatus: authStatus ?? this.authStatus,
        user: user,
        theme: theme ?? this.theme,
        groups: groups ?? this.groups,
        groupIdx: groupIdx ?? this.groupIdx,
      );
}
