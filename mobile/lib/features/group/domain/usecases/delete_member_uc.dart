import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/group_repository.dart';

class DeleteMemberUC extends UseCase<bool, DeleteMemberParams> {
  final GroupRepository repository;

  DeleteMemberUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.deleteMembers(
      groupId: params.groupId,
      memberIds: params.memberIds,
    );
  }
}

class DeleteMemberParams extends Equatable {
  final List<int> memberIds;
  final int groupId;

  const DeleteMemberParams({
    required this.memberIds,
    required this.groupId,
  });

  @override
  List<Object?> get props => [memberIds, groupId];
}
