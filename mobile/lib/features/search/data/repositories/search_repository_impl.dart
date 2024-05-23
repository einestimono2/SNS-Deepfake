import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/features/search/data/models/search_model.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/utils.dart';
import '../../../friend/friend.dart';
import '../../domain/domain.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl extends BaseRepositoryImpl
    implements SearchRepository {
  final SearchRemoteDataSource remote;

  SearchRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> searchUser({
    int? page,
    int? size,
    required String keyword,
  }) async {
    return await checkNetwork<PaginationResult<FriendModel>>(
      () async {
        final users = await remote.searchUser(
          page: page,
          size: size,
          keyword: keyword,
        );

        return Right(users);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<SearchModel>>> getHistory({
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<SearchModel>>(
      () async {
        final users = await remote.getHistory(
          page: page,
          size: size,
        );

        return Right(users);
      },
    );
  }
  
  @override
  Future<Either<Failure, bool>> deleteHistory({
    String? keyword,
    required SearchHistoryType type,
    required bool all,
  }) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.deleteHistory(
          keyword: keyword,
          type: type,
          all: all,
        );

        return Right(result);
      },
    );
  }
}
