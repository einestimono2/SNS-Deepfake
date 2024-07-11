import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/deepfake_repository.dart';

class CreateVideoDeepfakeUC
    extends UseCase<VideoDeepfakeModel, CreateVideoDeepfakeParams> {
  final DeepfakeRepository repository;

  CreateVideoDeepfakeUC({required this.repository});

  @override
  Future<Either<Failure, VideoDeepfakeModel>> call(params) async {
    return await repository.createVideoDeepfake(
      title: params.title,
      audios: params.audios,
      image: params.image,
      video: params.video,
    );
  }
}

class CreateVideoDeepfakeParams {
  final String title;
  final String video;
  final String image;
  final List<String> audios;

  CreateVideoDeepfakeParams({
    required this.title,
    required this.image,
    required this.video,
    this.audios = const [],
  });
}
