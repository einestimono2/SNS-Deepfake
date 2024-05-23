import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../../friend/data/models/friend.model.dart';
import '../repositories/search_repository.dart';

class SearchUserUC extends UseCase<PaginationResult<FriendModel>, SearchUserParams> {
  final SearchRepository repository;

  SearchUserUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> call(params) async {
    return await repository.searchUser(
      page: params.page,
      size: params.size,
      keyword: params.keyword,
    );
  }
}

class SearchUserParams {
  final int? page;
  final int? size;
  final String keyword;

  SearchUserParams({
    this.page,
    this.size,
    required this.keyword,
  });
}
