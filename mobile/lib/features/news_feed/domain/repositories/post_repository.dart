import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/post_model.dart';

abstract class PostRepository {
  Future<Either<Failure, BaseResponse>> createPost({
    required int groupId,
    String? description,
    String? status,
    required List<String> files,
  });

  Future<Either<Failure, String>> deletePost({
    required int groupId,
    required int postId,
  });

  Future<Either<Failure, PostModel>> getPostDetails(int postId);

  Future<Either<Failure, PostModel>> editPost({
    required int postId,
  });

  Future<Either<Failure, PaginationResult<PostModel>>> getListPost({
    required int groupId,
    int? page,
    int? size,
  });
}
