import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/utils/constants/enums.dart';

import '../../../../core/base/base_usecase.dart';
import '../../../../core/errors/failures.dart';
import '../../data/data.dart';
import '../repositories/chat_repository.dart';

class SendMessageUC extends UseCase<MessageModel, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUC({required this.repository});

  @override
  Future<Either<Failure, MessageModel>> call(params) async {
    return await repository.sendMessage(
      conversationId: params.conversationId,
      replyId: params.replyId,
      message: params.message,
      attachments: params.attachments,
      type: params.type,
    );
  }
}

class SendMessageParams {
  final String? message;
  final int conversationId;
  final int? replyId;
  final MessageType type;
  final List<String> attachments;

  const SendMessageParams({
    required this.conversationId,
    required this.type,
    this.message,
    this.replyId,
    required this.attachments,
  });
}
