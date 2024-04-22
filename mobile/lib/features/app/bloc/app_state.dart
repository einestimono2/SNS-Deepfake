part of 'app_bloc.dart';

class AppState extends Equatable {
  final AuthStatus authStatus;
  final UserModel? user;
  final ThemeMode theme;

  @override
  List<Object?> get props => [authStatus, user, theme];

  const AppState._({
    this.authStatus = AuthStatus.unknown,
    this.user,
    this.theme = ThemeMode.system,
  });

  factory AppState() => const AppState._();

  AppState copyWith({
    AuthStatus? authStatus,
    UserModel? user,
    ThemeMode? theme,
  }) =>
      AppState._(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        theme: theme ?? this.theme,
      );
}
