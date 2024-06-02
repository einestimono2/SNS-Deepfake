import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/group_repository.dart';

class LeaveGroupUC extends UseCase<bool, IdParams> {
  final GroupRepository repository;

  LeaveGroupUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.leaveGroup(params.id);
  }
}
