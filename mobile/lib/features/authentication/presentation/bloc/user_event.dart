part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class ResetState extends UserEvent {}

class LoginSubmit extends UserEvent {
  final String email;
  final String password;

  const LoginSubmit({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpSubmit extends UserEvent {
  final String email;
  final String password;
  final int role;

  const SignUpSubmit({
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object> get props => [email, password, role];
}

class VerifyOTPSubmit extends UserEvent {
  final String email;
  final String otp;

  const VerifyOTPSubmit({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

class ResendOTPSubmit extends UserEvent {
  final String email;

  const ResendOTPSubmit({required this.email});

  @override
  List<Object> get props => [email];
}

class FinishProfileSubmit extends UserEvent {
  final String email;
  final String username;
  final String phoneNumber;
  final String? avatar;
  final String? coverImage;

  const FinishProfileSubmit({
    required this.username,
    required this.phoneNumber,
    this.avatar,
    this.coverImage,
    required this.email,
  });

  @override
  List<Object?> get props => [email, username, phoneNumber, coverImage, avatar];
}

class LogoutSubmit extends UserEvent {}
