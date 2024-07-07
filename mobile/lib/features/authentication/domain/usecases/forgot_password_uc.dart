import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class ForgotPasswordUC extends UseCase<bool, ForgotPasswordParams> {
  final UserRepository repository;

  ForgotPasswordUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams(this.email);
}
