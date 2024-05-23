import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/features/news_feed/data/models/post_model.dart';

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
  Future<Either<Failure, BaseResponse>> createPost({
    required int groupId,
    String? description,
    String? status,
    required List<String> files,
  }) async {
    return await checkNetwork<BaseResponse>(
      () async {
        final data = await remote.createPost(
          groupId: groupId,
          description: description,
          status: status,
          files: files,
        );

        return Right(data);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<PostModel>>> getListPost({
    required int groupId,
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<PostModel>>(
      () async {
        final result = await remote.getListPost(
          groupId: groupId,
          page: page,
          size: size,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, String>> deletePost({
    required int groupId,
    required int postId,
  }) async {
    return await checkNetwork<String>(
      () async {
        final coins = await remote.deletePost(
          groupId: groupId,
          postId: postId,
        );

        return Right(coins);
      },
    );
  }

  @override
  Future<Either<Failure, PostModel>> getPostDetails(int postId) async {
    return await checkNetwork<PostModel>(
      () async {
        final coins = await remote.getPostDetails(postId);

        return Right(coins);
      },
    );
  }

  @override
  Future<Either<Failure, PostModel>> editPost({
    required int postId,
  }) async {
    return await checkNetwork<PostModel>(
      () async {
        final data = await remote.editPost(
          postId: postId,
        );

        return Right(data);
      },
    );
  }
}
