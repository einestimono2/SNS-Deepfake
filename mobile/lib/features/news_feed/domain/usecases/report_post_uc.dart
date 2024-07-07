import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/post_repository.dart';

class ReportPostUC extends UseCase<bool, ReportPostParams> {
  final PostRepository repository;

  ReportPostUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.reportPost(
      postId: params.postId,
      subject: params.subject,
      content: params.content,
    );
  }
}

class ReportPostParams {
  final int postId;
  final String subject;
  final String content;

  const ReportPostParams({
    required this.postId,
    required this.subject,
    required this.content,
  });
}
