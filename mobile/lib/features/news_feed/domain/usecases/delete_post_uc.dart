import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/post_repository.dart';

class DeletePostUC extends UseCase<String, DeletePostParams> {
  final PostRepository repository;

  DeletePostUC({required this.repository});

  @override
  Future<Either<Failure, String>> call(params) async {
    return await repository.deletePost(
      groupId: params.groupId,
      postId: params.postId,
    );
  }
}

class DeletePostParams {
  final int groupId;
  final int postId;

  const DeletePostParams({
    required this.groupId,
    required this.postId,
  });
}
