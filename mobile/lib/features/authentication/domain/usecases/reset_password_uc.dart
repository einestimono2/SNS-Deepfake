import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class ResetPasswordUC extends UseCase<bool, ResetPasswordParams> {
  final UserRepository repository;

  ResetPasswordUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.resetPassword(
      email: params.email,
      password: params.password,
      otp: params.otp,
    );
  }
}

class ResetPasswordParams {
  final String email;
  final String password;
  final String otp;

  const ResetPasswordParams({
    required this.email,
    required this.otp,
    required this.password,
  });
}
