import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../config/configs.dart';
import '../../../../core/networks/networks.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadImage(String path);
}

class UploadRemoteDataSourceImpl extends UploadRemoteDataSource {
  final ApiClient apiClient;

  UploadRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<String> uploadImage(String path) async {
    final fileName = path.split('/').last;
    final fileExt = fileName.split('.').last;
    final _formData = FormData.fromMap({
      "images": [
        MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType("image", fileExt),
        ),
      ],
    });

    final response = await apiClient.post(
      Endpoints.uploadImages,
      data: _formData,
    );

    return response["path"]; // { path: "", name: "" }
  }
}
