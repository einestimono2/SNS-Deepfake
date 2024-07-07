import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class SignUpUC extends UseCase<bool, SignUpParams> {
  final UserRepository repository;

  SignUpUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.register(
      email: params.email,
      password: params.password,
      role: params.role,
      parentEmail: params.parentEmail,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String parentEmail;
  final int role;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.role,
    required this.parentEmail,
  });
}
