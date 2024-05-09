import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/utils/constants/enums.dart';
import 'package:sns_deepfake/features/chat/data/models/conversation_model.dart';
import 'package:sns_deepfake/features/chat/data/models/message_model.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/domain.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl extends BaseRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl({
    required this.remote,
    required super.network,
  });

  @override
  Future<Either<Failure, List<ConversationModel>>> myConversations({
    int? page,
    int? size,
  }) async {
    return await checkNetwork<List<ConversationModel>>(
      () async {
        final conversations =
            await remote.myConversations(page: page, size: size);

        return Right(conversations);
      },
    );
  }

  @override
  Future<Either<Failure, ConversationModel>> getConversationDetails(
    int id,
  ) async {
    return await checkNetwork<ConversationModel>(
      () async {
        final conversations = await remote.getConversationDetails(id);

        return Right(conversations);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> seenConversation(int id) async {
    return await checkNetwork<bool>(
      () async {
        final res = await remote.seenConversation(id);

        return Right(res);
      },
    );
  }

  @override
  Future<Either<Failure, BaseResponse>> getConversationMessages({
    required int id,
    int? page,
    int? size,
  }) async {
    return await checkNetwork<BaseResponse>(
      () async {
        final messages = await remote.getConversationMessages(
          id: id,
          page: page,
          size: size,
        );

        return Right(messages);
      },
    );
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage({
    required int conversationId,
    required MessageType type,
    String? message,
    int? replyId,
    required List<String> attachments,
  }) async {
    return await checkNetwork<MessageModel>(
      () async {
        final conversations = await remote.sendMessage(
          conversationId: conversationId,
          replyId: replyId,
          message: message,
          attachments: attachments,
          type: type,
        );

        return Right(conversations);
      },
    );
  }
}
