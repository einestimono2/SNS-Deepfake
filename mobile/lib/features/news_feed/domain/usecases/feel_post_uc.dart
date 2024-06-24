import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../domain.dart';

class FeelPostUC extends UseCase<Map<String, int>, FeelPostParams> {
  final PostRepository repository;

  FeelPostUC({required this.repository});

  @override
  Future<Either<Failure, Map<String, int>>> call(params) async {
    return await repository.feelPost(
      postId: params.postId,
      type: params.type,
    );
  }
}

class FeelPostParams {
  final int postId;
  final int type;

  const FeelPostParams({
    required this.postId,
    required this.type,
  });
}
