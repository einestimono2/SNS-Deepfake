import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class ChangePasswordUC extends UseCase<bool, ChangePasswordParams> {
  final ProfileRepository repository;

  ChangePasswordUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.changePassword(
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
    );
  }
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.newPassword,
    required this.oldPassword,
  });
}
