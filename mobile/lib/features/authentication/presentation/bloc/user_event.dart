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

class SelectGroupSubmit extends UserEvent {
  final int id;

  const SelectGroupSubmit(this.id);

  @override
  List<Object> get props => [id];
}

class SignUpSubmit extends UserEvent {
  final String email;
  final String password;
  final int role;
  final String parentEmail;

  const SignUpSubmit({
    required this.email,
    required this.password,
    required this.role,
    required this.parentEmail,
  });

  @override
  List<Object> get props => [email, password, role, parentEmail];
}

class VerifyOTPSubmit extends UserEvent {
  final String email;
  final String otp;
  final Function() onSuccess;
  final Function(String) onError;

  const VerifyOTPSubmit({
    required this.onSuccess,
    required this.onError,
    required this.email,
    required this.otp,
  });

  @override
  List<Object> get props => [email, otp];
}

class ResendOTPSubmit extends UserEvent {
  final String email;
  final Function() onSuccess;
  final Function(String) onError;

  const ResendOTPSubmit({
    required this.onSuccess,
    required this.onError,
    required this.email,
  });

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

class LogoutSubmit extends UserEvent {
  final Function() onSuccess;

  const LogoutSubmit({required this.onSuccess});
}

class ForgotPasswordSubmit extends UserEvent {
  final String email;
  final Function() onSuccess;
  final Function(String) onError;

  const ForgotPasswordSubmit({
    required this.email,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [email];
}

class ResetPasswordSubmit extends UserEvent {
  final String email;
  final String password;
  final String otp;
  final Function() onSuccess;
  final Function(String) onError;

  const ResetPasswordSubmit({
    required this.email,
    required this.password,
    required this.otp,
    required this.onSuccess,
    required this.onError,
  });

  @override
  List<Object?> get props => [email, password, otp];
}
