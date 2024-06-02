import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/group_repository.dart';

class GetGroupDetailsUC extends UseCase<GroupModel, GetGroupDetailsParams> {
  final GroupRepository repository;

  GetGroupDetailsUC({required this.repository});

  @override
  Future<Either<Failure, GroupModel>> call(params) async {
    return await repository.getGroupDetails(params.id);
  }
}

class GetGroupDetailsParams {
  final int id;

  const GetGroupDetailsParams(this.id);
}
