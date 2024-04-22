import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';
import '../repositories/user_repository.dart';

class LoginUC extends UseCase<UserModel, LoginParams> {
  final UserRepository repository;

  LoginUC({required this.repository});

  @override
  Future<Either<Failure, UserModel>> call(params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });
}
