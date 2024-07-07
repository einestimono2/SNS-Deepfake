import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/errors/failures.dart';
import 'package:sns_deepfake/features/notification/data/models/notification_model.dart';

import '../../../../core/base/base.dart';
import '../../domain/domain.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl extends BaseRepositoryImpl
    implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, PaginationResult<NotificationModel>>>
      getListNotification({int? page, int? size}) async {
    return await checkNetwork<PaginationResult<NotificationModel>>(
      () async {
        final result = await remote.getListNotification(
          page: page,
          size: size,
        );

        return Right(result);
      },
    );
  }
}
