import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../models/group_model.dart';

abstract class GroupRemoteDataSource {
  Future<BaseResponse> createGroup({
    required String name,
    String? description,
    required List<int> memberIds,
    String? coverPhoto,
  });

  Future<bool> inviteMembers({
    required int groupId,
    required List<int> memberIds,
  });

  Future<bool> deleteMembers({
    required int groupId,
    required List<int> memberIds,
  });

  Future<bool> deleteGroup(int groupId);
  Future<bool> leaveGroup(int groupId);

  Future<GroupModel> updateGroup({
    required int id,
    String? name,
    String? description,
    String? coverPhoto,
  });

  Future<PaginationResult<GroupModel>> myGroups({
    int? page,
    int? size,
  });

  Future<GroupModel> getGroupDetails(int id);
}

class GroupRemoteDataSourceImpl extends GroupRemoteDataSource {
  final ApiClient apiClient;

  GroupRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BaseResponse> createGroup({
    required String name,
    String? description,
    required List<int> memberIds,
    String? coverPhoto,
  }) async {
    final response = await apiClient.post(
      Endpoints.createGroup,
      data: {
        "name": name,
        "description": description,
        "memberIds": memberIds,
        "coverPhoto": coverPhoto,
      },
    );

    return response;
  }

  @override
  Future<PaginationResult<GroupModel>> myGroups({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.myGroups,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => GroupModel.fromMap(e),
    );
  }

  @override
  Future<GroupModel> getGroupDetails(int id) async {
    final response = await apiClient.get(
      Endpoints.groupDetails.replaceFirst(":groupId", id.toString()),
    );

    return GroupModel.fromMap(response.data);
  }

  @override
  Future<GroupModel> updateGroup({
    required int id,
    String? name,
    String? description,
    String? coverPhoto,
  }) async {
    final response = await apiClient.put(
        Endpoints.updateGroup.replaceFirst(":groupId", id.toString()),
        data: {
          "name": name,
          "description": description,
          "coverImage": coverPhoto,
        });

    return GroupModel.fromMap(response.data);
  }

  @override
  Future<bool> inviteMembers({
    required int groupId,
    required List<int> memberIds,
  }) async {
    final response = await apiClient.post(
      Endpoints.addMember.replaceFirst(":groupId", groupId.toString()),
      data: {"memberIds": memberIds},
    );

    return response.status == 'success';
  }

  @override
  Future<bool> deleteMembers({
    required int groupId,
    required List<int> memberIds,
  }) async {
    final response = await apiClient.delete(
      Endpoints.deleteMember.replaceFirst(":groupId", groupId.toString()),
      data: {"memberIds": memberIds},
    );

    return response.status == 'success';
  }

  @override
  Future<bool> deleteGroup(int groupId) async {
    final response = await apiClient.delete(
      Endpoints.deleteGroup.replaceFirst(":groupId", groupId.toString()),
    );

    return response.status == 'success';
  }

  @override
  Future<bool> leaveGroup(int groupId) async {
    final response = await apiClient.get(
      Endpoints.leaveGroup.replaceFirst(":groupId", groupId.toString()),
    );

    return response.status == 'success';
  }
}
