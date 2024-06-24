import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';

abstract class FriendRepository {
  Future<Either<Failure, PaginationResult<FriendModel>>> getRequestedFriends({
    int? page,
    int? size,
  });

  Future<Either<Failure, PaginationResult<FriendModel>>> getSuggestedFriends({
    int? page,
    int? size,
  });

  Future<Either<Failure, PaginationResult<FriendModel>>> getListFriends({
    int? page,
    int? size,
  });

  Future<Either<Failure, bool>> acceptRequest(int targetId);
  Future<Either<Failure, bool>> refuseRequest(int targetId);

  Future<Either<Failure, bool>> sendRequest(int targetId);
  Future<Either<Failure, bool>> unsentRequest(int targetId);

  Future<Either<Failure, bool>> unfriend(int targetId);
}
