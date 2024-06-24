import 'package:dartz/dartz.dart';

import 'package:sns_deepfake/core/errors/failures.dart';
import 'package:sns_deepfake/features/friend/data/models/friend.model.dart';
import 'package:sns_deepfake/features/news_feed/data/models/post_model.dart';
import 'package:sns_deepfake/features/profile/data/models/profile_model.dart';

import '../../../../core/base/base.dart';
import '../../../authentication/data/data.dart';
import '../../domain/domain.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl extends BaseRepositoryImpl
    implements ProfileRepository {
  final ProfileRemoteDataSource remote;

  ProfileRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    String? avatar,
    String? coverPhoto,
    String? phoneNumber,
    String? username,
  }) async {
    return await checkNetwork<UserModel>(
      () async {
        final newProfile = await remote.updateProfile(
          avatar: avatar,
          coverPhoto: coverPhoto,
          phoneNumber: phoneNumber,
          username: username,
        );

        return Right(newProfile);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<PostModel>>> getMyPosts({
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<PostModel>>(
      () async {
        final result = await remote.getMyPosts(
          page: page,
          size: size,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, ProfileModel>> getUserProfile(int id) async {
    return await checkNetwork<ProfileModel>(
      () async {
        final result = await remote.getUserProfile(id);

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> getUserFriends({
    int? page,
    int? size,
    required int id,
  }) async {
    return await checkNetwork<PaginationResult<FriendModel>>(
      () async {
        final result = await remote.getUserFriends(
          page: page,
          size: size,
          id: id,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<PostModel>>> getUserPosts({
    int? page,
    int? size,
    required int id,
  }) async {
    return await checkNetwork<PaginationResult<PostModel>>(
      () async {
        final result = await remote.getUserPosts(
          page: page,
          size: size,
          id: id,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> block(int id) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.block(id);

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> unblock(int id) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.unblock(id);

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> changePassword({
    required String newPassword,
    required String oldPassword,
  }) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, int>> buyCoins(int amount) async {
    return await checkNetwork<int>(
      () async {
        final coins = await remote.buyCoins(amount);

        return Right(coins);
      },
    );
  }
}
