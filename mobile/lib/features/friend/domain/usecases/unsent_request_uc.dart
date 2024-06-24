import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/friend_repository.dart';

class UnsentRequestUC extends UseCase<bool, UnsentRequestParams> {
  final FriendRepository repository;

  UnsentRequestUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.unsentRequest(params.targetId);
  }
}

class UnsentRequestParams extends Equatable {
  final int targetId;

  const UnsentRequestParams(this.targetId);

  @override
  List<Object?> get props => [targetId];
}
