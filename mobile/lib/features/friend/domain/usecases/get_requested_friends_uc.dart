import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/friend_repository.dart';

class GetRequestedFriendsUC
    extends UseCase<PaginationResult<FriendModel>, PaginationParams> {
  final FriendRepository repository;

  GetRequestedFriendsUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> call(params) async {
    return await repository.getRequestedFriends(
      page: params.page,
      size: params.size,
    );
  }
}