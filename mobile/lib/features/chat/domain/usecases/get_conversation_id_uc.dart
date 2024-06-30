import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class GetConversationIdUC
    extends UseCase<int, GetConversationIdParams> {
  final ChatRepository repository;

  GetConversationIdUC({required this.repository});

  @override
  Future<Either<Failure, int>> call(params) async {
    return await repository.getConversationId(params.targetId);
  }
}

class GetConversationIdParams {
  final int targetId;

  const GetConversationIdParams(this.targetId);
}
