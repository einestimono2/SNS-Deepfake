import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/post_repository.dart';

class EditPostUC extends UseCase<PostModel, EditPostParams> {
  final PostRepository repository;

  EditPostUC({required this.repository});

  @override
  Future<Either<Failure, PostModel>> call(params) async {
    return await repository.editPost(
      postId: params.postId,
    );
  }
}

class EditPostParams {
  final int postId;

  const EditPostParams({
    required this.postId,
  });
}
