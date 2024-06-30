import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../../news_feed/news_feed.dart';
import '../repositories/search_repository.dart';

class SearchPostUC
    extends UseCase<PaginationResult<PostModel>, SearchPostParams> {
  final SearchRepository repository;

  SearchPostUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<PostModel>>> call(params) async {
    return await repository.searchPost(
      page: params.page,
      size: params.size,
      keyword: params.keyword,
      cache: params.cache,
    );
  }
}

class SearchPostParams {
  final int? page;
  final int? size;
  final String keyword;
  final bool cache;

  SearchPostParams({
    this.page,
    this.size,
    required this.keyword,
    required this.cache,
  });
}
