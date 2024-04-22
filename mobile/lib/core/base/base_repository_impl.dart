import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../networks/remote/network_info.dart';
import '../utils/utils.dart';

typedef FutureEitherOr<T> = Future<Either<Failure, T>> Function();
typedef FutureEitherOrWithToken<T> = Future<Either<Failure, T>> Function(
  String token,
);

abstract class BaseRepository {
  Future<Either<Failure, T>> checkNetwork<T>(FutureEitherOr<T> body);
}

class BaseRepositoryImpl implements BaseRepository {
  final NetworkInfo network;

  BaseRepositoryImpl({required this.network});

  @override
  Future<Either<Failure, T>> checkNetwork<T>(FutureEitherOr<T> body) async {
    if (await network.isConnected) {
      try {
        return await body();
      } on DioException catch (e) {
        final errorMessage = HttpException.fromDioError(e).toString();

        if (kDebugMode) {
          AppLogger.error(errorMessage, e);
        }

        return Left(HttpFailure(errorMessage));
      } on ServerException catch (error) {
        return Left(ServerFailure(error.message));
      } on UnauthenticatedException catch (_) {
        return Left(
          UnauthenticatedFailure("UNAUTHENTICATED_FAILURE_TEXT".tr()),
        );
      } catch (error) {
        return Left(ServerFailure(error.toString()));
      }
    } else {
      return Left(OfflineFailure("OFFLINE_FAILURE_TEXT".tr()));
    }
  }
}

/** Sử dụng trong xx_repository_impl.dart //! extends BaseRepositoryImpl implements LoginRepository
  Future<Either<Failure, User>> login(
      String email, 
      String password, 
    ) async {
    return await checkNetwork<User>(
      () async {
        try {
          final user = await loginRemoteDataSource.login(email, password);
          
          if (user != null) {
            //
            return Right(user);
          }

          return Left(ServerFailure());
        } on ServerException catch (e) {
          return Left(ServerFailure());
        }
      },
    );
  }
*/