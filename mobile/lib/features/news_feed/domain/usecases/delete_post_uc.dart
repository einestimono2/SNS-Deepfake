import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/post_repository.dart';

class DeletePostUC extends UseCase<String, IdParams> {
  final PostRepository repository;

  DeletePostUC({required this.repository});

  @override
  Future<Either<Failure, String>> call(params) async {
    return await repository.deletePost(params.id);
  }
}
