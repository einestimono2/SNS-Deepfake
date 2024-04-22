import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<Either<Failure, UserModel?>> getUser();

  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, UserModel>> finishProfile({
    String? avatar,
    String? coverImage,
    required String email,
    required String username,
    required String phoneNumber,
  });

  Future<Either<Failure, bool>> register({
    required String email,
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
}
