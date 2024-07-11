import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../../authentication/data/data.dart';
import '../repositories/profile_repository.dart';

class GetMyChildrenUC extends UseCase<List<ShortUserModel>, NoParams> {
  final ProfileRepository repository;

  GetMyChildrenUC({required this.repository});

  @override
  Future<Either<Failure, List<ShortUserModel>>> call(params) async {
    return await repository.getMyChildren();
  }
}
