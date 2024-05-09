import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/networks/networks.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<bool> removeCacheUser();
  Future<void> cacheToken(String? token);
  Future<bool> removeCacheToken();
  String? getToken();
}

class UserLocalDataSourceImpl extends UserLocalDataSource {
  final LocalCache localCache;

  UserLocalDataSourceImpl({required this.localCache});

  @override
  Future<void> cacheUser(UserModel user) async {
    await localCache.putString(AppStrings.userKey, user.toJson());
  }

  @override
  Future<void> cacheToken(String? token) async {
    print("CacheToekn: $token");
    if (token == null) {
      return;
    }

    await localCache.putString(AppStrings.accessTokenKey, token);
  }

  @override
  String? getToken() {
    return localCache.getString(AppStrings.accessTokenKey);
  }

  @override
  Future<bool> removeCacheToken() async {
    return await localCache.clearKey(AppStrings.accessTokenKey);
  }

  @override
  Future<bool> removeCacheUser() async {
    return await localCache.clearKey(AppStrings.userKey);
  }
}
