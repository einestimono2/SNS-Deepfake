import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../../config/configs.dart';
import '../../../../core/networks/networks.dart';

abstract class UploadRemoteDataSource {
  Future<String> uploadImage(String path);
  Future<List<String>> uploadImages(List<String> paths);
  Future<String> uploadVideo(String path);
  Future<List<String>> uploadVideos(List<String> paths);
  Future<List<String>> uploadAudios(List<String> paths);
}

class UploadRemoteDataSourceImpl extends UploadRemoteDataSource {
  final ApiClient apiClient;

  UploadRemoteDataSourceImpl({
    required this.apiClient,
  });

  @override
  Future<String> uploadImage(String path) async {
    final fileName = path.split('/').last;
    final type = lookupMimeType(path)!.split("/");
    final _formData = FormData.fromMap({
      "images": [
        MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType(type[0], type[1]),
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
        final type = lookupMimeType(path)!.split("/");

        return MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType(type[0], type[1]),
        );
      }).toList()
    });

    final response = await apiClient.post(
      Endpoints.uploadImages,
      data: _formData,
    );

    if (response.data is List) {
      return List<String>.from(response.data.map((e) => e["path"]));
    } else {
      return [response.data["path"]];
    }
  }

  @override
  Future<String> uploadVideo(String path) async {
    final fileName = path.split('/').last;
    final type = lookupMimeType(path)!.split("/");
    final _formData = FormData.fromMap({
      "videos": [
        MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType(type[0], type[1]),
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
        final type = lookupMimeType(path)!.split("/");

        return MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType(type[0], type[1]),
        );
      }).toList()
    });

    final response = await apiClient.post(
      Endpoints.uploadVideos,
      data: _formData,
    );

    if (response.data is List) {
      return List<String>.from(response.data.map((e) => e["path"]));
    } else {
      return [response.data["path"]];
    }
  }

  @override
  Future<List<String>> uploadAudios(List<String> paths) async {
    final _formData = FormData.fromMap({
      "audios": paths.map((path) {
        final fileName = path.split('/').last;
        final type = lookupMimeType(path)!.split("/");

        return MultipartFile.fromFileSync(
          path,
          filename: fileName,
          contentType: MediaType(type[0], type[1]),
        );
      }).toList()
    });

    final response = await apiClient.post(
      Endpoints.uploadAudios,
      data: _formData,
    );

    if (response.data is List) {
      return List<String>.from(response.data.map((e) => e["path"]));
    } else {
      return [response.data["path"]];
    }
  }
}
