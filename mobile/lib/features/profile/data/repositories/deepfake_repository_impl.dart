import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/errors/failures.dart';
import 'package:sns_deepfake/features/profile/profile.dart';

import '../../../../core/base/base.dart';

class DeepfakeRepositoryImpl extends BaseRepositoryImpl
    implements DeepfakeRepository {
  final DeepfakeRemoteDataSource remote;

  DeepfakeRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, PaginationResult<VideoDeepfakeModel>>>
      getListVideoDeepfake({
    int? page,
    int? size,
    required int type,
  }) async {
    return await checkNetwork<PaginationResult<VideoDeepfakeModel>>(
      () async {
        final result = await remote.getListVideoDeepfake(
          page: page,
          size: size,
          type: type,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, VideoDeepfakeModel>> createVideoDeepfake({
    required String title,
    required String video,
    required String image,
    required List<String> audios,
  }) async {
    return await checkNetwork<VideoDeepfakeModel>(
      () async {
        final result = await remote.createVideoDeepfake(
          title: title,
          video: video,
          image: image,
          audios: audios,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> createSchedule({
    required int videoId,
    required int childId,
    required int frequency,
    required String time,
  }) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.createSchedule(
          videoId: videoId,
          time: time,
          childId: childId,
          frequency: frequency,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<VideoScheduleModel>>>
      getListSchedule({
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<VideoScheduleModel>>(
      () async {
        final result = await remote.getListSchedule(
          page: page,
          size: size,
        );

        return Right(result);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteSchedule(int id) async {
    return await checkNetwork<bool>(
      () async {
        final result = await remote.deleteSchedule(id);

        return Right(result);
      },
    );
  }
}
