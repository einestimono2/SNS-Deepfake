import 'package:sns_deepfake/features/profile/profile.dart';
import 'package:sns_deepfake/features/upload/upload.dart';

import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';

abstract class DeepfakeRemoteDataSource {
  Future<PaginationResult<VideoDeepfakeModel>> getListVideoDeepfake({
    int? page,
    int? size,
    required int type,
  });

  Future<PaginationResult<VideoScheduleModel>> getListSchedule({
    int? page,
    int? size,
  });

  Future<VideoDeepfakeModel> createVideoDeepfake({
    required String title,
    required String video,
    required String image,
    required List<String> audios,
  });

  Future<bool> createSchedule({
    required int videoId,
    required int childId,
    required int frequency,
    required String time,
  });

  Future<bool> deleteSchedule(int id);
}

class DeepfakeRemoteDataSourceImpl extends DeepfakeRemoteDataSource {
  final ApiClient apiClient;
  final UploadRemoteDataSource uploadRemote;

  DeepfakeRemoteDataSourceImpl({
    required this.uploadRemote,
    required this.apiClient,
  });

  @override
  Future<PaginationResult<VideoDeepfakeModel>> getListVideoDeepfake({
    int? page,
    int? size,
    required int type,
  }) async {
    final response = await apiClient.get(
      Endpoints.listVideoDeepfake,
      queryParameters: {
        "page": page,
        "size": size,
        "type": type,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => VideoDeepfakeModel.fromMap(e),
    );
  }

  @override
  Future<VideoDeepfakeModel> createVideoDeepfake({
    required String title,
    required String video,
    required String image,
    required List<String> audios,
  }) async {
    List<String>? uploadAudios;
    if (audios.isNotEmpty) {
      uploadAudios = await uploadRemote.uploadAudios(audios);
    }

    final uploadVideo = await uploadRemote.uploadVideo(video);
    final uploadImage = await uploadRemote.uploadImage(image);

    final response = await apiClient.post(Endpoints.createVideoDeepfake, data: {
      "title": title,
      "image": uploadImage,
      "video": uploadVideo,
      "audios": uploadAudios,
    });

    return VideoDeepfakeModel.fromMap(response.data);
  }

  @override
  Future<bool> createSchedule({
    required int videoId,
    required int childId,
    required int frequency,
    required String time,
  }) async {
    await apiClient.post(
      Endpoints.createSchedule,
      data: {
        "receiverId": childId,
        "videoId": videoId,
        "time": time,
        "repeat": frequency,
      },
    );

    return true;
  }

  @override
  Future<PaginationResult<VideoScheduleModel>> getListSchedule({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.listSchedule,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => VideoScheduleModel.fromMap(e),
    );
  }

  @override
  Future<bool> deleteSchedule(int id) async {
    await apiClient.delete(
      Endpoints.deleteSchedule.replaceFirst(":videoId", id.toString()),
    );

    return true;
  }
}
