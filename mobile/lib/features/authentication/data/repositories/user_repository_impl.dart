import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl extends BaseRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final UserLocalDataSource local;

  UserRepositoryImpl({
    required this.remote,
    required this.local,
    required super.network,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> getUser() async {
    return await checkNetwork<Map<String, dynamic>>(
      () async {
        final data = await remote.getUser();

        if (data['user'] != null) {
          await local.cacheUser(data['user']);
        }

        return Right(data);
      },
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return await checkNetwork<Map<String, dynamic>>(
      () async {
        final data = await remote.login(email, password);

        return Right(data);
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
  Future<Either<Failure, Map<String, dynamic>>> finishProfile({
    String? avatar,
    String? coverImage,
    required String email,
    required String username,
    required String phoneNumber,
  }) async {
    return await checkNetwork<Map<String, dynamic>>(
      () async {
        final data = await remote.finishProfile(
          avatar: avatar,
          coverImage: coverImage,
          email: email,
          username: username,
          phoneNumber: phoneNumber,
        );

        // UserModel user = data['user'];

        // final _token = local.getToken();
        // if (_token != null) {
        //   user = user.copyWith(token: _token);
        // }

        // await local.cacheUser(user);

        // return Right({
        //   "user": user,
        //   "groups": data['groups'],
        // });

        return Right(data);
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
          await local.removeSelectedGroup();
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
