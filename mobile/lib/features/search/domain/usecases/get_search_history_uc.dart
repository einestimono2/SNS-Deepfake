import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/models/search_model.dart';
import '../repositories/search_repository.dart';

class GetSearchHistoryUC
    extends UseCase<PaginationResult<SearchModel>, PaginationParams> {
  final SearchRepository repository;

  GetSearchHistoryUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<SearchModel>>> call(params) async {
    return await repository.getHistory(
      page: params.page,
      size: params.size,
    );
  }
}
