import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/group_repository.dart';

class InviteMemberUC extends UseCase<bool, InviteMemberParams> {
  final GroupRepository repository;

  InviteMemberUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.inviteMembers(
      groupId: params.groupId,
      memberIds: params.memberIds,
    );
  }
}

class InviteMemberParams extends Equatable {
  final List<int> memberIds;
  final int groupId;

  const InviteMemberParams({
    required this.memberIds,
    required this.groupId,
  });

  @override
  List<Object?> get props => [memberIds, groupId];
}
