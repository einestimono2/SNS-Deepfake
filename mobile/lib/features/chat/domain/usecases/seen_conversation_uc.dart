import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class SeenConversationUC
    extends UseCase<bool, SeenConversationParams> {
  final ChatRepository repository;

  SeenConversationUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.seenConversation(params.id);
  }
}

class SeenConversationParams {
  final int id;

  const SeenConversationParams({required this.id});
}
