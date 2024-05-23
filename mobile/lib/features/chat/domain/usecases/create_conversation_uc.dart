import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/utils/constants/enums.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/chat_repository.dart';

class CreateConversationUC
    extends UseCase<ConversationModel, CreateConversationParams> {
  final ChatRepository repository;

  CreateConversationUC({required this.repository});

  @override
  Future<Either<Failure, ConversationModel>> call(params) async {
    return await repository.createConversation(
      replyId: params.replyId,
      message: params.message,
      attachments: params.attachments,
      type: params.type,
      name: params.name,
      memberIds: params.memberIds,
    );
  }
}

class CreateConversationParams {
  final String? message;
  final int? replyId;
  final MessageType type;
  final List<String> attachments;
  final List<int> memberIds;
  final String? name;

  const CreateConversationParams({
    required this.type,
    this.message,
    this.replyId,
    required this.attachments,
    required this.memberIds,
    this.name,
  });
}
