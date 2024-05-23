import '../../../../config/configs.dart';
import '../../../../core/networks/networks.dart';
import '../../../../core/services/services.dart';
import '../../../../core/utils/utils.dart';
import '../../../group/group.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> getUser();
  Future<Map<String, dynamic>> login(String email, String password);
  Future<bool> logout();
  Future<Map<String, dynamic>> finishProfile({
    String? avatar,
    String? coverImage,
    required String email,
    required String username,
    required String phoneNumber,
  });
  Future<bool> register(String email, String password, int role);
  Future<int> verifyOtp(String email, String otp);
  Future<bool> resendOtp(String email);
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> getUser() async {
    final response = await apiClient.get(Endpoints.verify);

    return {
      "user": UserModel.fromMap(response.data['user']),
      "groups": List<GroupModel>.from(
        response.data['groups']?.map((x) => GroupModel.fromMap(x)),
      ),
    };
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final uuid = await DeviceUtils.getDeviceID();

    final response = await apiClient.post(
      Endpoints.login,
      data: {
        "email": email,
        "password": password,
        'uuid': uuid,
        'fcmToken': FirebaseNotificationService.instance.token ?? "",
      },
    );

    return {
      "user": UserModel.fromMap(response.data['user']),
      "groups": List<GroupModel>.from(
        response.data['groups']?.map((x) => GroupModel.fromMap(x)),
      ),
    };
  }

  @override
  Future<bool> register(
    String email,
    String password,
    int role,
  ) async {
    final uuid = await DeviceUtils.getDeviceID();

    await apiClient.post(
      Endpoints.register,
      data: {
        "email": email,
        "password": password,
        'uuid': uuid,
        'role': role,
      },
    );

    return true;
  }

  @override
  Future<bool> resendOtp(String email) async {
    await apiClient.get(
      Endpoints.resendOtp,
      data: {"email": email},
    );

    return true;
  }

  @override
  Future<int> verifyOtp(String email, String otp) async {
    final response = await apiClient.post(
      Endpoints.verifyOtp,
      data: {"email": email, "code": otp},
    );

    return response.data['status']; /* {status: x, id: x} */
  }

  @override
  Future<Map<String, dynamic>> finishProfile({
    String? avatar,
    String? coverImage,
    required String email,
    required String username,
    required String phoneNumber,
  }) async {
    final response = await apiClient.patch(
      Endpoints.finishProfile,
      data: {
        "avatar": avatar,
        "coverImage": coverImage,
        "email": email,
        "username": username,
        "phoneNumber": username,
      },
    );

    return {
      "user": UserModel.fromMap(response.data['user']),
      "groups": List<GroupModel>.from(
        response.data['groups']?.map((x) => GroupModel.fromMap(x)),
      ),
    };
  }

  @override
  Future<bool> logout() async {
    await apiClient.post(Endpoints.logout);

    // await Future.wait([
    //   local.removeCacheToken(),
    //   local.removeCacheUser(),
    // ]);

    return true;
  }
}
