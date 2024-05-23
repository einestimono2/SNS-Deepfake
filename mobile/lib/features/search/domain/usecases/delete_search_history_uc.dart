import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/utils.dart';
import '../repositories/search_repository.dart';

class DeleteSearchHistoryUC extends UseCase<bool, DeleteSearchHistoryParams> {
  final SearchRepository repository;

  DeleteSearchHistoryUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.deleteHistory(
      keyword: params.keyword,
      type: params.type,
      all: params.all,
    );
  }
}

class DeleteSearchHistoryParams {
  final String? keyword;
  final bool all;
  final SearchHistoryType type;

  DeleteSearchHistoryParams({
    this.keyword,
    this.all = false,
    required this.type,
  });
}
