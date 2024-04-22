import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sns_deepfake/features/app/bloc/app_bloc.dart';
import 'package:sns_deepfake/features/authentication/authentication.dart';

import '../../../app/app.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final LoginUC loginUC;
  final SignUpUC signUpUC;
  final VerifyOtpUC verifyOtpUC;
  final ResendOtpUC resendOtpUC;
  final FinishProfileUC finishProfileUC;

  final AppBloc appBloc;

  UserBloc({
    required this.signUpUC,
    required this.loginUC,
    required this.appBloc,
    required this.verifyOtpUC,
    required this.resendOtpUC,
    required this.finishProfileUC,
  }) : super(InitialState()) {
    on<ResetState>(_onResetState);
    on<LoginSubmit>(_onLoginSubmit);
    on<SignUpSubmit>(_onSignUpSubmit);
    on<VerifyOTPSubmit>(_onVerifyOTPSubmit);
    on<ResendOTPSubmit>(_onResendOTPSubmit);
    on<FinishProfileSubmit>(_onFinishProfileSubmit);
  }

  FutureOr<void> _onLoginSubmit(
    LoginSubmit event,
    Emitter<UserState> emit,
  ) async {
    emit(InProgressState());

    final result = await loginUC(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(FailureState(
        message: failure.toString(),
        type: "LOGIN",
      )),
      (user) {
        emit(const SuccessfulState(type: "LOGIN"));
        appBloc.add(ChangeUser(user: user));
      },
    );
  }

  FutureOr<void> _onResetState(ResetState event, Emitter<UserState> emit) {
    emit(InitialState());
  }

  FutureOr<void> _onSignUpSubmit(
    SignUpSubmit event,
    Emitter<UserState> emit,
  ) async {
    emit(InProgressState());

    final result = await signUpUC(SignUpParams(
      email: event.email,
      password: event.password,
      role: event.role,
    ));

    result.fold(
      (failure) => emit(FailureState(
        message: failure.toString(),
        type: "SIGN_UP",
      )),
      (user) {
        emit(const SuccessfulState(type: "SIGN_UP"));

        appBloc.add(ChangeUser(
          user: UserModel(
            email: event.email,
            status: 0,
            role: event.role,
          ),
        ));
      },
    );
  }

  FutureOr<void> _onVerifyOTPSubmit(
    VerifyOTPSubmit event,
    Emitter<UserState> emit,
  ) async {
    emit(InProgressState());

    // Test
    if (event.email.isEmpty) {
      await Future.delayed(const Duration(seconds: 3));
      emit(const FailureState(message: "Email trống", type: "VERIFY_OTP"));
      return;
    }

    final result = await verifyOtpUC(VerifyOtpParams(
      email: event.email,
      otp: event.otp,
    ));

    result.fold(
      (failure) => emit(FailureState(
        message: failure.toString(),
        type: "VERIFY_OTP",
      )),
      (status) {
        emit(const SuccessfulState(type: "VERIFY_OTP"));
        appBloc.add(UpdateUserStatus(status: status));
      },
    );
  }

  FutureOr<void> _onResendOTPSubmit(
    ResendOTPSubmit event,
    Emitter<UserState> emit,
  ) async {
    emit(InProgressState());

    // Test
    if (event.email == "") {
      await Future.delayed(const Duration(seconds: 3));
      emit(const FailureState(message: "Email trống", type: "RESEND_OTP"));
      return;
    }

    final result = await resendOtpUC(ResendOtpParams(
      email: event.email,
    ));

    result.fold(
      (failure) => emit(FailureState(
        message: failure.toString(),
        type: "RESEND_OTP",
      )),
      (user) {
        emit(const SuccessfulState(type: "RESEND_OTP"));
      },
    );
  }

  FutureOr<void> _onFinishProfileSubmit(
    FinishProfileSubmit event,
    Emitter<UserState> emit,
  ) async {
    emit(InProgressState());

    final response = await finishProfileUC(FinishProfileParams(
      email: event.email,
      username: event.username,
      phoneNumber: event.phoneNumber,
      avatar: event.avatar,
      coverImage: event.coverImage,
    ));

    response.fold(
      (failure) => emit(FailureState(
        message: failure.toString(),
        type: "FINISH_PROFILE",
      )),
      (user) {
        emit(const SuccessfulState(type: "FINISH_PROFILE"));
        appBloc.add(ChangeUser(user: user));
      },
    );
  }
}
