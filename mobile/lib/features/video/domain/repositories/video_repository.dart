import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';

abstract class VideoRepository {
  Future<Either<Failure, PaginationResult<VideoModel>>> getListVideo({
    int? page,
    int? size,
    required int groupId,
  });
}
