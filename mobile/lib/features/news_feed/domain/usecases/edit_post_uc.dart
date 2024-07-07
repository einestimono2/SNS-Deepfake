import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/post_repository.dart';

class EditPostUC extends UseCase<Map<String, dynamic>, EditPostParams> {
  final PostRepository repository;

  EditPostUC({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(params) async {
    return await repository.editPost(
      postId: params.postId,
      images: params.images,
      videos: params.videos,
      imageDel: params.imageDel,
      videoDel: params.videoDel,
      description: params.description,
      status: params.status,
      groupId: params.groupId,
    );
  }
}

class EditPostParams {
  final int postId;
  final int? groupId;
  final List<String>? images;
  final List<String>? videos;
  final List<String>? imageDel;
  final List<String>? videoDel;
  final String? description;
  final String? status;

  const EditPostParams({
    this.images,
    this.videos,
    this.imageDel,
    this.videoDel,
    this.description,
    this.status,
    this.groupId,
    required this.postId,
  });
}
