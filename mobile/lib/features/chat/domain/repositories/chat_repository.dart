import 'package:dartz/dartz.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/utils.dart';
import '../../data/data.dart';

abstract class ChatRepository {
  /*  */
  Future<Either<Failure, List<ConversationModel>>> myConversations({
    int? page,
    int? size,
  });

  /*  */
  Future<Either<Failure, ConversationModel>> getConversationDetails(int id);

  /*  */
  Future<Either<Failure, bool>> seenConversation(int id);

  /*  */
  Future<Either<Failure, BaseResponse>> getConversationMessages({
    required int id,
    int? page,
    int? size,
  });
  
  /*  */
  Future<Either<Failure, MessageModel>> sendMessage({
    required int conversationId,
    required MessageType type,
    String? message,
    int? replyId,
    required List<String> attachments,
  });
}
