import 'package:dartz/dartz.dart';

import '../../../../core/base/base_result.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/models/post_model.dart';
import '../repositories/post_repository.dart';

class GetListPostUC extends UseCase<PaginationResult<PostModel>, GetListPostParams> {
  final PostRepository repository;

  GetListPostUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<PostModel>>> call(params) async {
    return await repository.getListPost(
      groupId: params.groupId,
      page: params.page,
      size: params.size,
    );
  }
}

class GetListPostParams {
  final int groupId;
  final int? page;
  final int? size;

  const GetListPostParams({
    required this.groupId,
    this.page,
    this.size,
  });
}
