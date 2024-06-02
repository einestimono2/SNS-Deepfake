import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/group_repository.dart';

class DeleteGroupUC extends UseCase<bool, IdParams> {
  final GroupRepository repository;

  DeleteGroupUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.deleteGroup(params.id);
  }
}
