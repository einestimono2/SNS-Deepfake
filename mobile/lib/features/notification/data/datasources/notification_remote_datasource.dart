import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<PaginationResult<NotificationModel>> getListNotification({
    int? page,
    int? size,
  });
}

class NotificationRemoteDataSourceImpl extends NotificationRemoteDataSource {
  final ApiClient apiClient;

  NotificationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginationResult<NotificationModel>> getListNotification({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.listNotification,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => NotificationModel.fromMap(e),
    );
  }
}
