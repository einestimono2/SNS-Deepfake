import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class SetBlockUC extends UseCase<bool, IdParams> {
  final ProfileRepository repository;

  SetBlockUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.block(params.id);
  }
}
