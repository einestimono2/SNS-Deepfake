import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../core/errors/failures.dart';

class CreateScheduleUC extends UseCase<bool, CreateScheduleParams> {
  final DeepfakeRepository repository;

  CreateScheduleUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.createSchedule(
      videoId: params.videoId,
      time: params.time,
      childId: params.childId,
      frequency: params.frequency,
    );
  }
}

class CreateScheduleParams {
  final int videoId;
  final int childId;
  final int frequency;
  final String time;

  CreateScheduleParams({
    required this.videoId,
    required this.childId,
    required this.frequency,
    required this.time,
  });
}
