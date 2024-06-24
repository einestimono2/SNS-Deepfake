import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../../authentication/data/data.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUC extends UseCase<UserModel, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUC({required this.repository});

  @override
  Future<Either<Failure, UserModel>> call(params) async {
    return await repository.updateProfile(
      username: params.username,
      phoneNumber: params.phoneNumber,
      avatar: params.avatar,
      coverPhoto: params.coverPhoto,
    );
  }
}

class UpdateProfileParams {
  final String? avatar;
  final String? coverPhoto;
  final String? phoneNumber;
  final String? username;

  const UpdateProfileParams({
    this.avatar,
    this.coverPhoto,
    this.phoneNumber,
    this.username,
  });
}
