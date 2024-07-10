import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class DeleteConversationUC extends UseCase<bool, IdParams> {
  final ChatRepository repository;

  DeleteConversationUC({required this.repository});

  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.deleteConversation(params.id);
  }
}
