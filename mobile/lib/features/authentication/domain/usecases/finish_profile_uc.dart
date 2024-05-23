import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/user_repository.dart';

class FinishProfileUC
    extends UseCase<Map<String, dynamic>, FinishProfileParams> {
  final UserRepository repository;

  FinishProfileUC({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(params) async {
    return await repository.finishProfile(
      email: params.email,
      username: params.username,
      phoneNumber: params.phoneNumber,
      avatar: params.avatar,
      coverImage: params.coverImage,
    );
  }
}

class FinishProfileParams {
  final String email;
  final String username;
  final String? avatar;
  final String? coverImage;
  final String phoneNumber;

  const FinishProfileParams({
    this.avatar,
    this.coverImage,
    required this.email,
    required this.username,
    required this.phoneNumber,
  });
}
