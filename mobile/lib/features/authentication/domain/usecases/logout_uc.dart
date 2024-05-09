import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class LogoutUC extends UseCase<bool, NoParams> {
  final UserRepository repository;

  LogoutUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.logout();
  }
}
