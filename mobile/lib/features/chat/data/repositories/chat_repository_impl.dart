import 'package:dartz/dartz.dart';
import 'package:sns_deepfake/core/utils/constants/enums.dart';

import '../../../../core/base/base.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/domain.dart';
import '../data.dart';

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
  Future<Either<Failure, Map<String, dynamic>>> updateConversation({
    required int id,
    required String name,
  }) async {
    return await checkNetwork<Map<String, dynamic>>(
      () async {
        final res = await remote.updateConversation(id: id, name: name);

        return Right(res);
      },
    );
  }

  @override
  Future<Either<Failure, PaginationResult<MessageModel>>>
      getConversationMessages({
    required int id,
    int? page,
    int? size,
  }) async {
    return await checkNetwork<PaginationResult<MessageModel>>(
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

  @override
  Future<Either<Failure, ConversationModel>> createConversation({
    required List<int> memberIds,
    String? name,
    required MessageType type,
    String? message,
    int? replyId,
    required List<String> attachments,
  }) async {
    return await checkNetwork<ConversationModel>(
      () async {
        final conversation = await remote.createConversation(
          replyId: replyId,
          message: message,
          attachments: attachments,
          type: type,
          memberIds: memberIds,
          name: name,
        );

        return Right(conversation);
      },
    );
  }

  @override
  Future<Either<Failure, int>> getConversationId(int targetId) async {
    return await checkNetwork<int>(
      () async {
        final id = await remote.getConversationId(targetId);

        return Right(id);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteMember({
    required int id,
    required int memberId,
    required bool kick,
  }) async {
    return await checkNetwork<bool>(
      () async {
        final res =
            await remote.deleteMember(id: id, memberId: memberId, kick: kick);

        return Right(res);
      },
    );
  }

  @override
  Future<Either<Failure, List<MemberModel>>> addMember({
    required int id,
    required List<int> memberIds,
  }) async {
    return await checkNetwork<List<MemberModel>>(
      () async {
        final res = await remote.addMember(id: id, memberIds: memberIds);

        return Right(res);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteConversation(int id) async {
    return await checkNetwork<bool>(
      () async {
        final res = await remote.deleteConversation(id);

        return Right(res);
      },
    );
  }
}
