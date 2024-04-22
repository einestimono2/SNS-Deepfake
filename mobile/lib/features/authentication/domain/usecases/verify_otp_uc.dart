import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class VerifyOtpUC extends UseCase<int, VerifyOtpParams> {
  final UserRepository repository;

  VerifyOtpUC({required this.repository});

  @override
  Future<Either<Failure, int>> call(params) async {
    return await repository.verifyOtp(
      email: params.email,
      otp: params.otp,
    );
  }
}

class VerifyOtpParams {
  final String email;
  final String otp;

  const VerifyOtpParams({
    required this.email,
    required this.otp,
  });
}
