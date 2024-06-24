import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../models/friend.model.dart';

abstract class FriendRemoteDataSource {
  Future<PaginationResult<FriendModel>> getRequestedFriends({
    int? page,
    int? size,
  });
  Future<PaginationResult<FriendModel>> getSuggestedFriends({
    int? page,
    int? size,
  });
  Future<PaginationResult<FriendModel>> getListFriend({int? page, int? size});

  Future<bool> sendRequest(int targetId);
  Future<bool> unsentRequest(int targetId);
  Future<bool> acceptRequest(int targetId);
  Future<bool> refuseRequest(int targetId);
  Future<bool> unfriend(int targetId);
}

class FriendRemoteDataSourceImpl extends FriendRemoteDataSource {
  final ApiClient apiClient;

  FriendRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginationResult<FriendModel>> getRequestedFriends({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.requestedFriend,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => FriendModel.fromMap(e),
    );
  }

  @override
  Future<PaginationResult<FriendModel>> getSuggestedFriends({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.suggestedFriend,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => FriendModel.fromMap(e),
    );
  }

  @override
  Future<PaginationResult<FriendModel>> getListFriend({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.listFriend,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => FriendModel.fromMap(e),
    );
  }

  @override
  Future<bool> acceptRequest(int targetId) async {
    final response = await apiClient.get(
      Endpoints.acceptRequest.replaceFirst(":targetId", targetId.toString()),
    );

    return response.status == "success";
  }

  @override
  Future<bool> refuseRequest(int targetId) async {
    final response = await apiClient.delete(
      Endpoints.refuseRequest.replaceFirst(":targetId", targetId.toString()),
    );

    return response.status == "success";
  }

  @override
  Future<bool> sendRequest(int targetId) async {
    final response = await apiClient.get(
      Endpoints.sendRequest.replaceFirst(":targetId", targetId.toString()),
    );

    return response.status == "success";
  }
  
  @override
  Future<bool> unsentRequest(int targetId) async {
    final response = await apiClient.delete(
      Endpoints.unsentRequest.replaceFirst(":targetId", targetId.toString()),
    );

    return response.status == "success";
  }

  @override
  Future<bool> unfriend(int targetId) async {
    final response = await apiClient.get(
      Endpoints.unfriend.replaceFirst(":targetId", targetId.toString()),
    );

    return response.status == "success";
  }
}
