import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl extends BaseRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;

  UserRepositoryImpl({
    required this.remote,
    required this.local,
    required super.network,
  });

  @override
  Future<Either<Failure, UserModel?>> getUser() async {
    return await checkNetwork<UserModel?>(
      () async {
        final user = await remote.getUser();

        if (user != null) {
          await local.cacheUser(user);
        }

        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    return await checkNetwork<UserModel>(
      () async {
        final data = await remote.login(email, password);

        // data = { user: {}, accessToken: '' }
        final user = UserModel.fromMap(data['user']);

        await local.cacheUser(user);
        await local.cacheToken(user.token);
        print(
            "login: ${(await SharedPreferences.getInstance()).getString(AppStrings.accessTokenKey)}");

        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> register({
    required String email,
    required String password,
    required int role,
  }) async {
    return await checkNetwork<bool>(
      () async {
        final response = await remote.register(email, password, role);

        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> resendOtp({required String email}) async {
    return await checkNetwork<bool>(
      () async {
        final response = await remote.resendOtp(email);

        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, int>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await checkNetwork<int>(
      () async {
        final response = await remote.verifyOtp(email, otp);

        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> finishProfile({
    String? avatar,
    String? coverImage,
    required String email,
    required String username,
    required String phoneNumber,
  }) async {
    return await checkNetwork<UserModel>(
      () async {
        UserModel user = await remote.finishProfile(
          avatar: avatar,
          coverImage: coverImage,
          email: email,
          username: username,
          phoneNumber: phoneNumber,
        );

        final _token = local.getToken();
        if (_token != null) {
          user = user.copyWith(token: _token);
        }

        await local.cacheUser(user);

        return Right(user);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    return await checkNetwork<bool>(
      () async {
        try {
          await remote.logout();
        } catch (e) {
          AppLogger.error("Logout API error", e);
        } finally {
          await local.removeCacheToken();
          await local.removeCacheUser();
        }

        // await Future.wait([
        //   local.removeCacheToken(),
        //   local.removeCacheUser(),
        // ]);

        return const Right(true);
      },
    );
  }
}
