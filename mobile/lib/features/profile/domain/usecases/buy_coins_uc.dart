import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/base/base.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class BuyCoinsUC extends UseCase<int, BuyCoinsParams> {
  final ProfileRepository repository;

  BuyCoinsUC({required this.repository});

  @override
  Future<Either<Failure, int>> call(params) async {
    return await repository.buyCoins(params.amount);
  }
}

class BuyCoinsParams {
  final int amount;

  const BuyCoinsParams(this.amount);
}
