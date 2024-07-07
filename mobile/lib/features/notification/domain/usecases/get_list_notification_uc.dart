import 'package:dartz/dartz.dart';

import '../../../../core/base/base_result.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/notification_repository.dart';

class GetListNotificationUC
    extends UseCase<PaginationResult<NotificationModel>, PaginationParams> {
  final NotificationRepository repository;

  GetListNotificationUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<NotificationModel>>> call(
      params) async {
    return await repository.getListNotification(
      page: params.page,
      size: params.size,
    );
  }
}
