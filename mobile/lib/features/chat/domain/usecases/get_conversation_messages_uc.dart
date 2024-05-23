import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/chat_repository.dart';

class GetConversationMessagesUC extends UseCase<PaginationResult<MessageModel>,
    GetConversationMessagesParams> {
  final ChatRepository repository;

  GetConversationMessagesUC({required this.repository});

  @override
  Future<Either<Failure, PaginationResult<MessageModel>>> call(params) async {
    return await repository.getConversationMessages(
      id: params.id,
      page: params.page,
      size: params.size,
    );
  }
}

class GetConversationMessagesParams {
  final int id;
  final int? page;
  final int? size;

  const GetConversationMessagesParams({
    required this.id,
    this.page,
    this.size,
  });
}
