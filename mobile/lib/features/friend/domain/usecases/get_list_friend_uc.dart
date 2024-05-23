import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/friend_repository.dart';


class GetListFriendUC
    extends UseCase<PaginationResult<FriendModel>, PaginationParams> {
  final FriendRepository repository;

  GetListFriendUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<FriendModel>>> call(params) async {
    return await repository.getListFriends(
      page: params.page,
      size: params.size,
    );
  }
}
