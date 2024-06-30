import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../../../../core/utils/utils.dart';
import '../data.dart';

abstract class ChatRemoteDataSource {
  /*  */
  Future<List<ConversationModel>> myConversations({
    int? page,
    int? size,
  });

  /*  */
  Future<ConversationModel> getConversationDetails(int id);

  /*  */
  Future<int> getConversationId(int targetId);

  /*  */
  Future<bool> seenConversation(int id);

  /*  */
  Future<PaginationResult<MessageModel>> getConversationMessages({
    required int id,
    int? page,
    int? size,
  });

  /*  */
  Future<MessageModel> sendMessage({
    required int conversationId,
    required MessageType type,
    String? message,
    int? replyId,
    required List<String> attachments,
  });

  /*  */
  Future<ConversationModel> createConversation({
    required MessageType type,
    String? message,
    int? replyId,
    required List<String> attachments,
    required List<int> memberIds,
    String? name,
  });
}

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final ApiClient apiClient;

  ChatRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ConversationModel>> myConversations({
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.myConversations,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );

    return List<ConversationModel>.from(
      response.data
          .map((_conversation) => ConversationModel.fromMap(_conversation)),
    );
  }

  @override
  Future<ConversationModel> getConversationDetails(int id) async {
    final response = await apiClient.get(
      Endpoints.conversationDetails.replaceFirst(":id", id.toString()),
    );

    return ConversationModel.fromMap(response.data);
  }

  @override
  Future<bool> seenConversation(int id) async {
    final response = await apiClient.get(
      Endpoints.seenConversation.replaceFirst(":id", id.toString()),
    );

    return response.status == "success";
  }

  @override
  Future<PaginationResult<MessageModel>> getConversationMessages({
    required int id,
    int? page,
    int? size,
  }) async {
    final response = await apiClient.get(
      Endpoints.conversationMessages
          .replaceFirst(":conversationId", id.toString()),
      queryParameters: {
        "page": page,
        "size": size,
        "sort": 'desc',
      },
    );

    return PaginationResult.fromBaseResponse(
      baseResponse: response,
      mapFunc: (e) => MessageModel.fromMap(e),
    );
  }

  @override
  Future<MessageModel> sendMessage({
    required int conversationId,
    required MessageType type,
    String? message,
    int? replyId,
    required List<String> attachments,
  }) async {
    final response = await apiClient.post(Endpoints.sendMessage, data: {
      "conversationId": conversationId,
      "type": type.name,
      "message": message,
      "replyId": replyId,
      "attachments": attachments,
    });

    return MessageModel.fromMap(response.data);
  }

  @override
  Future<ConversationModel> createConversation({
    required MessageType type,
    String? message,
    int? replyId,
    required List<String> attachments,
    required List<int> memberIds,
    String? name,
  }) async {
    final response = await apiClient.post(Endpoints.createConversation, data: {
      "message": {
        "type": type.name,
        "message": message,
        "replyId": replyId,
        "attachments": attachments,
      },
      "name": name,
      "memberIds": memberIds,
    });

    Map<String, dynamic> conversationMap = response.data['conversation'];
    conversationMap.addAll({
      "members": response.data['members'],
      "messages": [response.data['message']],
    });

    return ConversationModel.fromMap(conversationMap);
  }

  @override
  Future<int> getConversationId(int targetId) async {
    final response = await apiClient.post(
      Endpoints.getSingleConversationByMembers,
      data: {"targetId": targetId},
    );

    return response.data["id"] as int;
  }
}
