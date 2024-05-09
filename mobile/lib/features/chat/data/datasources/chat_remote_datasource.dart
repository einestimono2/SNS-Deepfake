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
  Future<bool> seenConversation(int id);

  /*  */
  Future<BaseResponse> getConversationMessages({
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
  Future<BaseResponse> getConversationMessages({
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

    return response;
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
}
