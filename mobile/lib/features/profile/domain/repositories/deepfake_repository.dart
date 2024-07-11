import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';

abstract class DeepfakeRepository {
  Future<Either<Failure, PaginationResult<VideoDeepfakeModel>>>
      getListVideoDeepfake({
    int? page,
    int? size,
    required int type,
  });

  Future<Either<Failure, PaginationResult<VideoScheduleModel>>>
      getListSchedule({
    int? page,
    int? size,
  });

  Future<Either<Failure, VideoDeepfakeModel>> createVideoDeepfake({
    required String title,
    required String video,
    required String image,
    required List<String> audios,
  });

  Future<Either<Failure, bool>> createSchedule({
    required int videoId,
    required int childId,
    required int frequency,
    required String time,
  });

  Future<Either<Failure, bool>> deleteSchedule(int id);
}
