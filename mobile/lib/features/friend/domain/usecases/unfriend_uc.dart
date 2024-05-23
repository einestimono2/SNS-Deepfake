import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/friend_repository.dart';

class UnfriendUC extends UseCase<bool, UnfriendParams> {
  final FriendRepository repository;

  UnfriendUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.unfriend(params.targetId);
  }
}

class UnfriendParams extends Equatable {
  final int targetId;

  const UnfriendParams(this.targetId);

  @override
  List<Object?> get props => [targetId];
}
