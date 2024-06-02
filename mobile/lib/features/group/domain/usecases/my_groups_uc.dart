import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/group_repository.dart';

class MyGroupsUC
    extends UseCase<PaginationResult<GroupModel>, PaginationParams> {
  final GroupRepository repository;

  MyGroupsUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<GroupModel>>> call(params) async {
    return await repository.myGroups(page: params.page, size: params.size);
  }
}
