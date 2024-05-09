import 'package:sns_deepfake/core/utils/helpers/video_helper.dart';

import '../../../../config/configs.dart';
import '../../../../core/networks/networks.dart';
import '../../../upload/upload.dart';

abstract class PostRemoteDataSource {
  Future<String> createPost({
    int? groupId,
    String? description,
    String? status,
    required List<String> files,
  });
}

class PostRemoteDataSourceImpl extends PostRemoteDataSource {
  final ApiClient apiClient;
  final UploadRemoteDataSource uploadRemote;

  PostRemoteDataSourceImpl({
    required this.uploadRemote,
    required this.apiClient,
  });

  @override
  Future<String> createPost({
    int? groupId,
    String? description,
    String? status,
    required List<String> files,
  }) async {
    List<String> images = [];
    List<String> videos = [];

    for (var e in files) {
      if (fileIsVideo(e)) {
        videos.add(e);
      } else {
        images.add(e);
      }
    }

    late List<String> imageUrls;
    late List<String> videoUrls;

    await Future.wait([
      uploadRemote.uploadImages(images).then((urls) => imageUrls = urls),
      uploadRemote.uploadVideos(videos).then((urls) => videoUrls = urls),
    ]);

    final response = await apiClient.post(
      Endpoints.createPost,
      data: {
        "groupId": groupId,
        "description": description,
        "status": status,
        "images": imageUrls,
        "videos": videoUrls,
      },
    );

    return response.data["coins"];
  }
}
