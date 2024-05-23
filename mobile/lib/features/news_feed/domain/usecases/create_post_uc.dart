import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/post_repository.dart';

class CreatePostUC extends UseCase<BaseResponse, CreatePostParams> {
  final PostRepository repository;

  CreatePostUC({required this.repository});

  @override
  Future<Either<Failure, BaseResponse>> call(params) async {
    return await repository.createPost(
      groupId: params.groupId,
      description: params.description,
      status: params.status,
      files: params.files,
    );
  }
}

class CreatePostParams {
  final int groupId;
  final String? description;
  final String? status;
  final List<String> files;

  const CreatePostParams({
    required this.groupId,
    this.description,
    this.status,
    required this.files,
  });
}
