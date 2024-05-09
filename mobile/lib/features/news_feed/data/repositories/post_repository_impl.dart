import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/domain.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl extends BaseRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;

  PostRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, String>> createPost({
    int? groupId,
    String? description,
    String? status,
    required List<String> files,
  }) async {
    return await checkNetwork<String>(
      () async {
        final remainingCoins = await remote.createPost(
          groupId: groupId,
          description: description,
          status: status,
          files: files,
        );

        return Right(remainingCoins);
      },
    );
  }
}
