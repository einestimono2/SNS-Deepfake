import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../../authentication/data/data.dart';
import '../../../friend/data/data.dart';
import '../../../news_feed/data/data.dart';
import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserModel>> updateProfile({
    String? avatar,
    String? coverPhoto,
    String? phoneNumber,
    String? username,
  });

  Future<Either<Failure, PaginationResult<PostModel>>> getMyPosts({
    int? page,
    int? size,
  });

  Future<Either<Failure, PaginationResult<FriendModel>>> getUserFriends({
    int? page,
    int? size,
    required int id,
  });

  Future<Either<Failure, PaginationResult<PostModel>>> getUserPosts({
    int? page,
    int? size,
    required int id,
  });

  Future<Either<Failure, ProfileModel>> getUserProfile(int id);

  Future<Either<Failure, bool>> block(int id);
  Future<Either<Failure, bool>> unblock(int id);

  Future<Either<Failure, bool>> changePassword({
    required String newPassword,
    required String oldPassword,
  });
  
  Future<Either<Failure, int>> buyCoins(int amount);
}
