import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../../../authentication/data/data.dart';
import '../../../friend/data/data.dart';
import '../../../news_feed/data/data.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> updateProfile({
    String? avatar,
    String? coverPhoto,
    String? phoneNumber,
    String? username,
  });

  Future<PaginationResult<PostModel>> getMyPosts({
    int? page,
    int? size,
  });

  Future<PaginationResult<PostModel>> getUserPosts({
    int? page,
    int? size,
    required int id,
  });

  Future<PaginationResult<FriendModel>> getUserFriends({
    int? page,
    int? size,
    required int id,
  });

  Future<ProfileModel> getUserProfile(int id);

  Future<int> buyCoins(int amount);

  Future<bool> block(int id);
  Future<bool> unblock(int id);

  Future<bool> changePassword({
    required String newPassword,
    required String oldPassword,
  });
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> updateProfile({
    String? avatar,
    String? coverPhoto,
    String? phoneNumber,
    String? username,
  }) async {
    final response = await apiClient.put(
      Endpoints.updateProfile,
      data: {
        "avatar": avatar,
        "phoneNumber": phoneNumber,
        "username": username,
        "coverPhoto": coverPhoto,
      },
    );

    return UserModel.fromMap(response.data);
  }

  @override
  Future<PaginationResult<PostModel>> getMyPosts({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.myPosts,
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
  Future<ProfileModel> getUserProfile(int id) async {
    final response = await apiClient.get(
      Endpoints.getProfile.replaceFirst(":userId", id.toString()),
    );

    return ProfileModel.fromMap(response.data);
  }

  @override
  Future<PaginationResult<FriendModel>> getUserFriends({
    int? page,
    int? size,
    required int id,
  }) async {
    final response = await apiClient.get(
      Endpoints.listFriend,
      queryParameters: {
        "page": page,
        "size": size,
      },
      data: {"user_id": id},
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => FriendModel.fromMap(e),
    );
  }

  @override
  Future<PaginationResult<PostModel>> getUserPosts({
    int? page,
    int? size,
    required int id,
  }) async {
    final response = await apiClient.get(
      Endpoints.listPost.replaceFirst(":groupId", "0"),
      queryParameters: {
        "page": page,
        "size": size,
      },
      data: {"user_id": id},
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => PostModel.fromMap(e),
    );
  }

  @override
  Future<bool> block(int id) async {
    final response = await apiClient.post(
      Endpoints.block.replaceFirst(":targetId", id.toString()),
    );

    return response.status == 'success';
  }

  @override
  Future<bool> unblock(int id) async {
    final response = await apiClient.post(
      Endpoints.unblock.replaceFirst(":targetId", id.toString()),
    );

    return response.status == 'success';
  }

  @override
  Future<bool> changePassword({
    required String newPassword,
    required String oldPassword,
  }) async {
    final response = await apiClient.put(
      Endpoints.changePassword,
      data: {
        "newPassword": newPassword,
        "oldPassword": oldPassword,
      },
    );

    return response.status == 'success';
  }

  @override
  Future<int> buyCoins(int amount) async {
    final response = await apiClient.post(
      Endpoints.buyCoins,
      data: {"coins": amount},
    );

    return int.parse(response.data['coins'].toString());
  }
}
