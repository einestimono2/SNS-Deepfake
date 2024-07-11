import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/deepfake_repository.dart';

class GetListScheduleUC
    extends UseCase<PaginationResult<VideoScheduleModel>, PaginationParams> {
  final DeepfakeRepository repository;

  GetListScheduleUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<VideoScheduleModel>>> call(
      params) async {
    return await repository.getListSchedule(
      page: params.page,
      size: params.size,
    );
  }
}
