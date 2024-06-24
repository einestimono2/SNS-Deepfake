import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UnBlockUC extends UseCase<bool, IdParams> {
  final ProfileRepository repository;

  UnBlockUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.unblock(params.id);
  }
}
