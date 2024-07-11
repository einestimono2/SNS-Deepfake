import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../core/errors/failures.dart';

class DeleteScheduleUC extends UseCase<bool, IdParams> {
  final DeepfakeRepository repository;

  DeleteScheduleUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.deleteSchedule(params.id);
  }
}
