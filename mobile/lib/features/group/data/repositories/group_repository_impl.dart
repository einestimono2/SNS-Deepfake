import 'package:dartz/dartz.dart';

import 'package:sns_deepfake/core/errors/failures.dart';
import 'package:sns_deepfake/features/group/data/models/group_model.dart';

import '../../../../core/base/base.dart';
import '../../domain/domain.dart';
import '../datasources/group_remote_datasource.dart';

class GroupRepositoryImpl extends BaseRepositoryImpl
    implements GroupRepository {
  final GroupRemoteDataSource remote;

  GroupRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, BaseResponse>> createGroup({
    required String name,
    String? description,
    required List<int> memberIds,
    String? coverPhoto,
  }) async {
    return await checkNetwork<BaseResponse>(
      () async {
        final request = await remote.createGroup(
          name: name,
          description: description,
          memberIds: memberIds,
          coverPhoto: coverPhoto,
        );

        return Right(request);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<GroupModel>>> myGroups({
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<GroupModel>>(
      () async {
        final request = await remote.myGroups(
          page: page,
          size: size,
        );

        return Right(request);
      },
    );
  }

  @override
  Future<Either<Failure, GroupModel>> getGroupDetails(int id) async {
    return await checkNetwork<GroupModel>(
      () async {
        final group = await remote.getGroupDetails(id);

        return Right(group);
      },
    );
  }

  @override
  Future<Either<Failure, GroupModel>> updateGroup({
    required int id,
    String? name,
    String? description,
    String? coverPhoto,
  }) async {
    return await checkNetwork<GroupModel>(
      () async {
        final updatedGroup = await remote.updateGroup(
          id: id,
          name: name,
          description: description,
          coverPhoto: coverPhoto,
        );

        return Right(updatedGroup);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> inviteMembers({
    required int groupId,
    required List<int> memberIds,
  }) async {
    return await checkNetwork<bool>(
      () async {
        final res = await remote.inviteMembers(
          groupId: groupId,
          memberIds: memberIds,
        );

        return Right(res);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteMembers({
    required int groupId,
    required List<int> memberIds,
  }) async {
    return await checkNetwork<bool>(
      () async {
        final res = await remote.deleteMembers(
          groupId: groupId,
          memberIds: memberIds,
        );

        return Right(res);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteGroup(int groupId) async {
    return await checkNetwork<bool>(
      () async {
        final res = await remote.deleteGroup(groupId);

        return Right(res);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> leaveGroup(int groupId) async {
    return await checkNetwork<bool>(
      () async {
        final res = await remote.leaveGroup(groupId);

        return Right(res);
      },
    );
  }
}
