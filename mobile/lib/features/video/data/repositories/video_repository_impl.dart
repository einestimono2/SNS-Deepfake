import 'package:dartz/dartz.dart';

import 'package:sns_deepfake/core/errors/failures.dart';

import '../../../../core/base/base.dart';
import '../../domain/domain.dart';
import '../data.dart';

class VideoRepositoryImpl extends BaseRepositoryImpl
    implements VideoRepository {
  final VideoRemoteDataSource remote;

  VideoRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, PaginationResult<VideoModel>>> getListVideo({
    int? page,
    int? size,
    required int groupId,
  }) async {
    return await checkNetwork<PaginationResult<VideoModel>>(
      () async {
        final result = await remote.getListVideo(
          page: page,
          size: size,
          groupId: groupId,
        );

        return Right(result);
      },
    );
  }
}
