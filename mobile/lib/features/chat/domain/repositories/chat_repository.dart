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
  Future<Either<Failure, int>> getConversationId(int targetId);

  /*  */
  Future<Either<Failure, bool>> seenConversation(int id);

  /*  */
  Future<Either<Failure, bool>> deleteConversation(int id);

  /*  */
  Future<Either<Failure, bool>> deleteMember({
    required int id,
    required int memberId,
    required bool kick,
  });

  /*  */
  Future<Either<Failure, List<MemberModel>>> addMember({
    required int id,
    required List<int> memberIds,
  });

  /*  */
  Future<Either<Failure, Map<String, dynamic>>> updateConversation({
    required int id,
    required String name,
  });

  /*  */
  Future<Either<Failure, PaginationResult<MessageModel>>>
      getConversationMessages({
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

  /*  */
  Future<Either<Failure, ConversationModel>> createConversation({
    required List<int> memberIds,
    String? name,
    required MessageType type,
    String? message,
    int? replyId,
    required List<String> attachments,
  });
}
