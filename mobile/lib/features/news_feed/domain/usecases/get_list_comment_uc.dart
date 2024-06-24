import 'package:dartz/dartz.dart';

import '../../../../core/base/base_result.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/post_repository.dart';

class GetListCommentUC
    extends UseCase<PaginationResult<CommentModel>, GetListCommentParams> {
  final PostRepository repository;

  GetListCommentUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<CommentModel>>> call(params) async {
    return await repository.getListComment(
      postId: params.postId,
      page: params.page,
      size: params.size,
    );
  }
}

class GetListCommentParams {
  final int postId;
  final int? page;
  final int? size;

  const GetListCommentParams({
    required this.postId,
    this.page,
    this.size,
  });
}
