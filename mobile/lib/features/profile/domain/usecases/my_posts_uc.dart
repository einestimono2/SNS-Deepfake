import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../../news_feed/data/data.dart';
import '../repositories/profile_repository.dart';

class MyPostsUC extends UseCase<PaginationResult<PostModel>, PaginationParams> {
  final ProfileRepository repository;

  MyPostsUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<PostModel>>> call(params) async {
    return await repository.getMyPosts(
      page: params.page,
      size: params.size,
    );
  }
}
