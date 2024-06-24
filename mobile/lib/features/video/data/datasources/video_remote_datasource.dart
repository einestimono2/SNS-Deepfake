import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../data.dart';

abstract class VideoRemoteDataSource {
  Future<PaginationResult<VideoModel>> getListVideo({
    int? page,
    int? size,
    required int groupId,
  });
}

class VideoRemoteDataSourceImpl extends VideoRemoteDataSource {
  final ApiClient apiClient;

  VideoRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginationResult<VideoModel>> getListVideo({
    int? page,
    int? size,
    required int groupId,
  }) async {
    final response = await apiClient.get(
      Endpoints.listVideo.replaceFirst(":groupId", groupId.toString()),
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => VideoModel.fromMap(e),
    );
  }
}
