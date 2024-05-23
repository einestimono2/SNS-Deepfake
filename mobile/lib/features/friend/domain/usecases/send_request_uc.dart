import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/friend_repository.dart';

class SendRequestUC extends UseCase<bool, SendRequestParams> {
  final FriendRepository repository;

  SendRequestUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.sendRequest(params.targetId);
  }
}

class SendRequestParams extends Equatable {
  final int targetId;

  const SendRequestParams(this.targetId);

  @override
  List<Object?> get props => [targetId];
}
