import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/friend_repository.dart';

class AcceptRequestUC extends UseCase<bool, AcceptRequestParams> {
  final FriendRepository repository;

  AcceptRequestUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.acceptRequest(params.targetId);
  }
}

class AcceptRequestParams extends Equatable {
  final int targetId;

  const AcceptRequestParams(this.targetId);

  @override
  List<Object?> get props => [targetId];
}
