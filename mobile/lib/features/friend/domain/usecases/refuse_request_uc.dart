import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/friend_repository.dart';

class RefuseRequestUC extends UseCase<bool, RefuseRequestParams> {
  final FriendRepository repository;

  RefuseRequestUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.refuseRequest(params.targetId);
  }
}

class RefuseRequestParams extends Equatable {
  final int targetId;

  const RefuseRequestParams(this.targetId);

  @override
  List<Object?> get props => [targetId];
}
