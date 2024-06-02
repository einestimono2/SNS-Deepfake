import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/group_repository.dart';

class UpdateGroupUC extends UseCase<GroupModel, UpdateGroupParams> {
  final GroupRepository repository;

  UpdateGroupUC({required this.repository});

  @override
  Future<Either<Failure, GroupModel>> call(params) async {
    return await repository.updateGroup(
      name: params.name,
      description: params.description,
      id: params.id,
      coverPhoto: params.coverPhoto,
    );
  }
}

class UpdateGroupParams {
  final int id;
  final String? description;
  final String? name;
  final String? coverPhoto;

  const UpdateGroupParams({
    required this.id,
    this.description,
    this.name,
    this.coverPhoto,
  });
}
