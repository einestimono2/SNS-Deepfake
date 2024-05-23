import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/post_repository.dart';

class GetPostDetailsUC extends UseCase<PostModel, GetPostDetailsParams> {
  final PostRepository repository;

  GetPostDetailsUC({required this.repository});

  @override
  Future<Either<Failure, PostModel>> call(params) async {
    return await repository.getPostDetails(params.postId);
  }
}

class GetPostDetailsParams {
  final int postId;

  const GetPostDetailsParams(this.postId);
}
