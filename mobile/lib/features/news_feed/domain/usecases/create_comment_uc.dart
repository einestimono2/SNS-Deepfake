import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/post_repository.dart';

class CreateCommentUC
    extends UseCase<Map<String, dynamic>, CreateCommentParams> {
  final PostRepository repository;

  CreateCommentUC({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(params) async {
    return await repository.createComment(
      postId: params.postId,
      content: params.content,
      markId: params.markId,
      type: params.type,
      page: params.page,
      size: params.size,
    );
  }
}

class CreateCommentParams {
  final int postId;
  final String content;
  final int? markId;
  final int? page;
  final int? size;
  final int type;

  const CreateCommentParams({
    required this.postId,
    this.markId,
    this.page,
    this.size,
    required this.content,
    required this.type,
  });
}
