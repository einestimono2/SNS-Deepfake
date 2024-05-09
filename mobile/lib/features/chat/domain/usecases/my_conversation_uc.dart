import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/chat_repository.dart';

class MyConversationUC
    extends UseCase<List<ConversationModel>, MyConversationParams> {
  final ChatRepository repository;

  MyConversationUC({required this.repository});

  @override
  Future<Either<Failure, List<ConversationModel>>> call(params) async {
    return await repository.myConversations(
      page: params.page,
      size: params.size,
    );
  }
}

class MyConversationParams {
  final int? page;
  final int? size;

  const MyConversationParams({
    this.page,
    this.size,
  });
}
