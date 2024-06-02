import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/group_repository.dart';

class CreateGroupUC extends UseCase<BaseResponse, CreateGroupParams> {
  final GroupRepository repository;

  CreateGroupUC({required this.repository});

  @override
  Future<Either<Failure, BaseResponse>> call(params) async {
    return await repository.createGroup(
      name: params.name,
      description: params.description,
      memberIds: params.memberIds,
      coverPhoto: params.coverPhoto,
    );
  }
}

class CreateGroupParams extends Equatable {
  final String name;
  final String? description;
  final List<int> memberIds;
  final String? coverPhoto;

  const CreateGroupParams({
    required this.name,
    this.description,
    required this.memberIds,
    this.coverPhoto,
  });

  @override
  List<Object?> get props => [name, description, memberIds, coverPhoto];
}
