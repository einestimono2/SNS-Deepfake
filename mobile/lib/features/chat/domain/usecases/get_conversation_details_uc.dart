import 'package:dartz/dartz.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/chat_repository.dart';

class GetConversationDetailsUC
    extends UseCase<ConversationModel, GetConversationDetailsParams> {
  final ChatRepository repository;

  GetConversationDetailsUC({required this.repository});

  @override
  Future<Either<Failure, ConversationModel>> call(params) async {
    return await repository.getConversationDetails(params.id);
  }
}

class GetConversationDetailsParams {
  final int id;

  const GetConversationDetailsParams({required this.id});
}
