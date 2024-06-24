import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../../news_feed/data/data.dart';
import '../repositories/profile_repository.dart';

class GetUserPostsUC
    extends UseCase<PaginationResult<PostModel>, GetUserPostsParams> {
  final ProfileRepository repository;

  GetUserPostsUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<PostModel>>> call(params) async {
    return await repository.getUserPosts(
      page: params.page,
      size: params.size,
      id: params.id,
    );
  }
}

class GetUserPostsParams {
  final int? page;
  final int? size;
  final int id;

  GetUserPostsParams({this.page, this.size, required this.id});
}
