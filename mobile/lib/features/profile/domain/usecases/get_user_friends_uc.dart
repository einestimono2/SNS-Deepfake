import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../../friend/data/data.dart';
import '../repositories/profile_repository.dart';

class GetUserFriendsUC
    extends UseCase<PaginationResult<FriendModel>, GetUserFriendsParams> {
  final ProfileRepository repository;

  GetUserFriendsUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> call(params) async {
    return await repository.getUserFriends(
      page: params.page,
      size: params.size,
      id: params.id,
    );
  }
}

class GetUserFriendsParams {
  final int? page;
  final int? size;
  final int id;

  GetUserFriendsParams({this.page, this.size, required this.id});
}
