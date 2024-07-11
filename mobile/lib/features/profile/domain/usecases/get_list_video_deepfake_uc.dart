import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/deepfake_repository.dart';

class GetListVideoDeepfakeUC extends UseCase<
    PaginationResult<VideoDeepfakeModel>, GetListVideoDeepfakeParams> {
  final DeepfakeRepository repository;

  GetListVideoDeepfakeUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<VideoDeepfakeModel>>> call(
      params) async {
    return await repository.getListVideoDeepfake(
      page: params.page,
      size: params.size,
      type: params.type,
    );
  }
}

class GetListVideoDeepfakeParams {
  final int? page;
  final int? size;
  final int type;

  GetListVideoDeepfakeParams({this.page, this.size, required this.type});
}
