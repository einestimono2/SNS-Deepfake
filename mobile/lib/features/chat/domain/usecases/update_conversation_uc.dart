import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/chat_repository.dart';

class UpdateConversationUC
    extends UseCase<Map<String, dynamic>, UpdateConversationParams> {
  final ChatRepository repository;

  UpdateConversationUC({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(params) async {
    return await repository.updateConversation(
      id: params.id,
      name: params.name,
    );
  }
}

class UpdateConversationParams {
  final int id;
  final String name;

  const UpdateConversationParams({
    required this.id,
    required this.name,
  });
}
