import 'package:sns_deepfake/core/utils/utils.dart';

import '../../../../core/networks/networks.dart';
import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> cacheToken(String? token);
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
    if (token == null) {
      return;
    }

    await localCache.putString(AppStrings.accessTokenKey, token);
  }

  @override
  String? getToken() {
    return localCache.getString(AppStrings.accessTokenKey);
  }
}
