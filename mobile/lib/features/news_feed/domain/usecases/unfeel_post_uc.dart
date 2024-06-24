import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../domain.dart';

class UnfeelPostUC extends UseCase<Map<String, int>, IdParams> {
  final PostRepository repository;

  UnfeelPostUC({required this.repository});

  @override
  Future<Either<Failure, Map<String, int>>> call(params) async {
    return await repository.unfeelPost(params.id);
  }
}
