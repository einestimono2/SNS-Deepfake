import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/domain.dart';
import '../datasources/friend_remote_datasource.dart';
import '../models/friend.model.dart';

class FriendRepositoryImpl extends BaseRepositoryImpl
    implements FriendRepository {
  final FriendRemoteDataSource remote;

  FriendRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> getRequestedFriends({
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<FriendModel>>(
      () async {
        final requests = await remote.getRequestedFriends(
          page: page,
          size: size,
        );

        return Right(requests);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> getSuggestedFriends({
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<FriendModel>>(
      () async {
        final requests = await remote.getSuggestedFriends(
          page: page,
          size: size,
        );

        return Right(requests);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> getListFriends({
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<FriendModel>>(
      () async {
        final requests = await remote.getListFriend(
          page: page,
          size: size,
        );

        return Right(requests);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> acceptRequest(int targetId) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.acceptRequest(targetId);

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> refuseRequest(int targetId) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.refuseRequest(targetId);

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> sendRequest(int targetId) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.sendRequest(targetId);

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> unfriend(int targetId) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.unfriend(targetId);

        return Right(result);
      },
    );
  }
}
