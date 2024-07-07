import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class UserRepository {
  Future<Either<Failure, Map<String, dynamic>>> getUser();

  Future<Either<Failure, Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, Map<String, dynamic>>> finishProfile({
    String? avatar,
    String? coverImage,
    required String email,
    required String username,
    required String phoneNumber,
  });

  Future<Either<Failure, bool>> register({
    required String email,
    required String parentEmail,
    required String password,
    required int role,
  });

  Future<Either<Failure, int>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, bool>> resendOtp({
    required String email,
  });

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, bool>> resetPassword({
    required String email,
    required String otp,
    required String password,
  });
}
