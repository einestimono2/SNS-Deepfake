import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/post_repository.dart';

class GetPostDetailsUC extends UseCase<PostModel, IdParams> {
  final PostRepository repository;

  GetPostDetailsUC({required this.repository});

  @override
  Future<Either<Failure, PostModel>> call(params) async {
    return await repository.getPostDetails(params.id);
  }
}
