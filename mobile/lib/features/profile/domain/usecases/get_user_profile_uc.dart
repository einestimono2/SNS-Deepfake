import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileUC extends UseCase<ProfileModel, IdParams> {
  final ProfileRepository repository;

  GetUserProfileUC({required this.repository});

  @override
  Future<Either<Failure, ProfileModel>> call(params) async {
    return await repository.getUserProfile(params.id);
  }
}
