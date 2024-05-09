import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class PostRepository {
  Future<Either<Failure, String>> createPost({
    int? groupId,
    String? description,
    String? status,
    required List<String> files,
  });
}
