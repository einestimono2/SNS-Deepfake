import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/features/news_feed/data/models/comment_model.dart';
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
  Future<Either<Failure, String>> deletePost(int postId) async {
    return await checkNetwork<String>(
      () async {
        final coins = await remote.deletePost(postId);

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
  Future<Either<Failure, Map<String, dynamic>>> editPost({
    required int postId,
    List<String>? images,
    List<String>? videos,
    List<String>? imageDel,
    List<String>? videoDel,
    String? description,
    String? status,
    int? groupId,
  }) async {
    return await checkNetwork<Map<String, dynamic>>(
      () async {
        final data = await remote.editPost(
          postId: postId,
          images: images,
          videos: videos,
          imageDel: imageDel,
          videoDel: videoDel,
          description: description,
          status: status,
          groupId: groupId,
        );

        return Right(data);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<CommentModel>>> getListComment({
    required int postId,
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<CommentModel>>(
      () async {
        final result = await remote.getListComment(
          postId: postId,
          page: page,
          size: size,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createComment({
    required int postId,
    int? markId,
    int? page,
    int? size,
    required String content,
    required int type,
  }) async {
    return await checkNetwork<Map<String, dynamic>>(
      () async {
        final result = await remote.createComment(
          postId: postId,
          content: content,
          markId: markId,
          type: type,
          size: size,
          page: page,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, int>>> feelPost({
    required int postId,
    required int type,
  }) async {
    return await checkNetwork<Map<String, int>>(
      () async {
        final result = await remote.feelPost(
          postId: postId,
          type: type,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, int>>> unfeelPost(postId) async {
    return await checkNetwork<Map<String, int>>(
      () async {
        final result = await remote.unfeelPost(postId);

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> reportPost({
    required int postId,
    required String subject,
    required String content,
  }) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.reportPost(
          postId: postId,
          subject: subject,
          content: content,
        );

        return Right(result);
      },
    );
  }
}
