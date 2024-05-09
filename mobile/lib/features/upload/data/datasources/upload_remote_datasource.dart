import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../config/configs.dart';
import '../../../../core/networks/networks.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadImage(String path);
  Future<List<String>> uploadImages(List<String> paths);
  Future<String> uploadVideo(String path);
  Future<List<String>> uploadVideos(List<String> paths);
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

    return response.data["path"]; // { path: "", name: "" }
  }

  @override
  Future<List<String>> uploadImages(List<String> paths) async {
    final _formData = FormData.fromMap({
      "images": paths.map((path) {
        final fileName = path.split('/').last;
        final fileExt = fileName.split('.').last;

        return MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType("image", fileExt),
        );
      }).toList()
    });

    final response = await apiClient.post(
      Endpoints.uploadImages,
      data: _formData,
    );

    return response.data["path"] is List
        ? response.data["path"]
        : [response.data["path"]];
  }

  @override
  Future<String> uploadVideo(String path) async {
    final fileName = path.split('/').last;
    final fileExt = fileName.split('.').last;
    final _formData = FormData.fromMap({
      "videos": [
        MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType("image", fileExt),
        ),
      ],
    });

    final response = await apiClient.post(
      Endpoints.uploadVideos,
      data: _formData,
    );

    return response.data["path"]; // { path: "", name: "" }
  }

  @override
  Future<List<String>> uploadVideos(List<String> paths) async {
    final _formData = FormData.fromMap({
      "videos": paths.map((path) {
        final fileName = path.split('/').last;
        final fileExt = fileName.split('.').last;

        return MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType("image", fileExt),
        );
      }).toList()
    });

    final response = await apiClient.post(
      Endpoints.uploadVideos,
      data: _formData,
    );

    return response.data["path"] is List
        ? response.data["path"]
        : [response.data["path"]];
  }
}
