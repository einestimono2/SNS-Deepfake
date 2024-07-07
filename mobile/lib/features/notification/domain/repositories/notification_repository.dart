import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';

abstract class NotificationRepository {
  Future<Either<Failure, PaginationResult<NotificationModel>>> getListNotification({
    int? page,
    int? size,
  });
}
