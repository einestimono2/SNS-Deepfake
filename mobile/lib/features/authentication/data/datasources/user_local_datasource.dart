import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/networks/networks.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> removeCacheUser();
  Future<void> cacheToken(String? token);
  Future<void> removeCacheToken();
  Future<void> removeSelectedGroup();
  String? getToken();
}

class UserLocalDataSourceImpl extends UserLocalDataSource {
  final LocalCache localCache;

  UserLocalDataSourceImpl({required this.localCache});

  @override
  Future<void> cacheUser(UserModel user) async {
    await localCache.putValue<String>(AppStrings.userKey, user.toJson());
  }

  @override
  Future<void> cacheToken(String? token) async {
    if (token == null) {
      return;
    }

    await localCache.putValue<String>(AppStrings.accessTokenKey, token);
  }

  @override
  String? getToken() {
    return localCache.getValue<String?>(AppStrings.accessTokenKey);
  }

  @override
  Future<void> removeCacheToken() async {
    await localCache.clearKey(AppStrings.accessTokenKey);
  }

  @override
  Future<void> removeCacheUser() async {
    await localCache.clearKey(AppStrings.userKey);
  }
  
  @override
  Future<void> removeSelectedGroup() async {
    await localCache.clearKey(AppStrings.selectedGroupKey);
  }
}
