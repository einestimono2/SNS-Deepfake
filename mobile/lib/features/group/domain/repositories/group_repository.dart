import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';

abstract class GroupRepository {
  Future<Either<Failure, BaseResponse>> createGroup({
    required String name,
    String? description,
    required List<int> memberIds,
    String? coverPhoto,
  });

  Future<Either<Failure, bool>> inviteMembers({
    required int groupId,
    required List<int> memberIds,
  });

  Future<Either<Failure, bool>> deleteMembers({
    required int groupId,
    required List<int> memberIds,
  });

  Future<Either<Failure, bool>> deleteGroup(int groupId);
  Future<Either<Failure, bool>> leaveGroup(int groupId);

  Future<Either<Failure, PaginationResult<GroupModel>>> myGroups({
    int? page,
    int? size,
  });

  Future<Either<Failure, GroupModel>> getGroupDetails(int id);

  Future<Either<Failure, GroupModel>> updateGroup({
    required int id,
    String? name,
    String? description,
    String? coverPhoto,
  });
}
