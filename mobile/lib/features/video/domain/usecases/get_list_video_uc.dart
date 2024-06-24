import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/video_repository.dart';

class GetListVideoUC
    extends UseCase<PaginationResult<VideoModel>, GetListVideoParams> {
  final VideoRepository repository;

  GetListVideoUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<VideoModel>>> call(params) async {
    return await repository.getListVideo(
      page: params.page,
      size: params.size,
      groupId: params.groupId,
    );
  }
}

class GetListVideoParams {
  final int? page;
  final int? size;
  final int groupId;

  GetListVideoParams({
    this.page,
    this.size,
    required this.groupId,
  });
}
