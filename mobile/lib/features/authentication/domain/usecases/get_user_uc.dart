import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class GetUserUC extends UseCase<Map<String, dynamic>, NoParams> {
  final UserRepository repository;

  GetUserUC({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(params) async {
    return await repository.getUser();
  }
}
