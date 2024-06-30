import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../../../../core/utils/utils.dart';
import '../../../friend/data/models/friend.model.dart';
import '../../../news_feed/data/data.dart';
import '../models/search_model.dart';

abstract class SearchRemoteDataSource {
  Future<PaginationResult<FriendModel>> searchUser({
    int? page,
    int? size,
    required String keyword,
    required bool cache,
  });

  Future<PaginationResult<PostModel>> searchPost({
    int? page,
    int? size,
    required String keyword,
    required bool cache,
  });

  Future<PaginationResult<SearchModel>> getHistory({
    int? page,
    int? size,
  });

  Future<bool> deleteHistory({
    String? keyword,
    required SearchHistoryType type,
    required bool all,
  });
}

class SearchRemoteDataSourceImpl extends SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginationResult<FriendModel>> searchUser({
    int? page,
    int? size,
    required String keyword,
    required bool cache,
  }) async {
    final response = await apiClient.get(
      Endpoints.searchUser,
      queryParameters: {
        "page": page,
        "size": size,
        "keyword": keyword,
        "cache": cache,
      },
    );

    return PaginationResult<FriendModel>.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => FriendModel.fromMap(e),
    );
  }

  @override
  Future<PaginationResult<SearchModel>> getHistory({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.searchHistory,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult<SearchModel>.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => SearchModel.fromMap(e),
    );
  }

  @override
  Future<bool> deleteHistory({
    String? keyword,
    required SearchHistoryType type,
    required bool all,
  }) async {
    final response = await apiClient.delete(
      Endpoints.deleteHistory,
      data: {
        "keyword": keyword,
        "all": all,
        "type": type.name,
      },
    );

    return response.status == 'success';
  }

  @override
  Future<PaginationResult<PostModel>> searchPost({
    int? page,
    int? size,
    required String keyword,
    required bool cache,
  }) async {
    final response = await apiClient.get(
      Endpoints.searchPost,
      queryParameters: {
        "page": page,
        "size": size,
        "keyword": keyword,
        "cache": cache,
      },
    );

    return PaginationResult<PostModel>.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => PostModel.fromMap(e),
    );
  }
}
