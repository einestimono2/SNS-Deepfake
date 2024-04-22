import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';
import '../repositories/user_repository.dart';

class GetUserUC extends UseCase<UserModel?, NoParams> {
  final UserRepository repository;

  GetUserUC({required this.repository});

  @override
  Future<Either<Failure, UserModel?>> call(params) async {
    return await repository.getUser();
  }
}
