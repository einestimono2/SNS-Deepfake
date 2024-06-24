import 'package:sns_deepfake/core/utils/helpers/video_helper.dart';

import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../../../upload/upload.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

abstract class PostRemoteDataSource {
  Future<BaseResponse> createPost({
    required int groupId,
    String? description,
    String? status,
    required List<String> files,
  });

  Future<Map<String, dynamic>> createComment({
    required int postId,
    int? markId,
    int? page,
    int? size,
    required String content,
    required int type,
  });

  Future<String> deletePost({
    required int groupId,
    required int postId,
  });

  Future<PostModel> editPost({
    required int postId,
  });

  Future<PostModel> getPostDetails(postId);

  Future<PaginationResult<PostModel>> getListPost({
    required int groupId,
    int? page,
    int? size,
  });

  Future<PaginationResult<CommentModel>> getListComment({
    required int postId,
    int? page,
    int? size,
  });

  Future<Map<String, int>> feelPost({
    required int postId,
    required int type,
  });

  Future<Map<String, int>> unfeelPost(postId);
}

class PostRemoteDataSourceImpl extends PostRemoteDataSource {
  final ApiClient apiClient;
  final UploadRemoteDataSource uploadRemote;

  PostRemoteDataSourceImpl({
    required this.uploadRemote,
    required this.apiClient,
  });

  @override
  Future<BaseResponse> createPost({
    required int groupId,
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

    List<String> _videosUrls = [];
    List<String> _imagesUrls = [];

    if (videos.isNotEmpty) {
      _videosUrls = await uploadRemote.uploadVideos(videos);
    }
    if (images.isNotEmpty) {
      _imagesUrls = await uploadRemote.uploadImages(images);
    }

    final response = await apiClient.post(
      Endpoints.createPost,
      data: {
        "groupId": groupId,
        "description": description,
        "status": status,
        "images": _imagesUrls,
        "videos": _videosUrls,
      },
    );

    return response;
  }

  @override
  Future<PaginationResult<PostModel>> getListPost({
    required int groupId,
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.listPost.replaceFirst(":groupId", groupId.toString()),
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => PostModel.fromMap(e),
    );
  }

  @override
  Future<String> deletePost({
    required int groupId,
    required int postId,
  }) async {
    final response = await apiClient.delete(
      Endpoints.deletePost.replaceFirst(":postId", postId.toString()),
      data: {"groupId": groupId},
    );

    return response.data['coins'];
  }

  @override
  Future<PostModel> getPostDetails(postId) async {
    final response = await apiClient.get(
      Endpoints.detailsPost.replaceFirst(":postId", postId.toString()),
    );

    return PostModel.fromMap(response.data);
  }

  @override
  Future<PostModel> editPost({
    required int postId,
  }) async {
    final response = await apiClient.put(
      Endpoints.editPost.replaceFirst(":postId", postId.toString()),
    );

    return PostModel.fromMap(response.data);
  }

  @override
  Future<PaginationResult<CommentModel>> getListComment({
    required int postId,
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.listComment.replaceFirst(":postId", postId.toString()),
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => CommentModel.fromMap(e),
    );
  }

  @override
  Future<Map<String, dynamic>> createComment({
    required int postId,
    int? markId,
    int? page,
    int? size,
    required String content,
    required int type,
  }) async {
    final response = await apiClient.post(
        Endpoints.createComment.replaceFirst(":postId", postId.toString()),
        queryParameters: {
          "page": page,
          "size": size,
        },
        data: {
          "markId": markId,
          "content": content,
          "type": type,
        });

    return {
      "data": response.data["data"]
          .map<CommentModel>((e) => CommentModel.fromMap(e))
          .toList(),
      "coins": response.data["coins"],
      "pageIndex": response.extra?["pageIndex"] ?? 0,
      "pageSize": response.extra?["pageSize"] ?? 0,
      "totalPages": response.extra?["totalPages"] ?? 0,
      "totalCount": response.extra?["totalCount"] ?? 0,
    };
  }

  @override
  Future<Map<String, int>> feelPost({
    required int postId,
    required int type,
  }) async {
    final response = await apiClient.post(
        Endpoints.feelPost.replaceFirst(":postId", postId.toString()),
        data: {"type": type});

    return {
      "disappointed": response.data["disappointed"],
      "kudos": response.data["kudos"],
    };
  }

  @override
  Future<Map<String, int>> unfeelPost(postId) async {
    final response = await apiClient.delete(
      Endpoints.unfeelPost.replaceFirst(":postId", postId.toString()),
    );

    return {
      "disappointed": response.data["disappointed"],
      "kudos": response.data["kudos"],
    };
  }
}
