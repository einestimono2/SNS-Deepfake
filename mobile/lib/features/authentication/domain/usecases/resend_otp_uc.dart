import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class ResendOtpUC extends UseCase<bool, ResendOtpParams> {
  final UserRepository repository;

  ResendOtpUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.resendOtp(
      email: params.email,
    );
  }
}

class ResendOtpParams {
  final String email;

  const ResendOtpParams({required this.email});
}
