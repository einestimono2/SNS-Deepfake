import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/utils.dart';
import '../../../friend/friend.dart';
import '../../data/data.dart';

abstract class SearchRepository {
  Future<Either<Failure, PaginationResult<FriendModel>>> searchUser({
    int? page,
    int? size,
    required String keyword,
  });

  Future<Either<Failure, PaginationResult<SearchModel>>> getHistory({
    int? page,
    int? size,
  });
  
  Future<Either<Failure, bool>> deleteHistory({
    String? keyword,
    required SearchHistoryType type,
    required bool all,
  });
}
