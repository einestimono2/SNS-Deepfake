import '../../../../config/configs.dart';
import '../../../../core/base/base.dart';
import '../../../../core/networks/networks.dart';
import '../../../../core/utils/utils.dart';
import '../../../upload/upload.dart';
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
  Future<Map<String, dynamic>> updateConversation({
    required int id,
    required String name,
  });

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
  final UploadRemoteDataSource uploadRemote;

  ChatRemoteDataSourceImpl({
    required this.uploadRemote,
    required this.apiClient,
  });

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
    List<String> images = [];
    List<String> videos = [];

    for (var e in attachments) {
      if (fileIsVideo(e)) {
        videos.add(e);
      } else {
        images.add(e);
      }
    }

    List<String> urls = [];

    if (videos.isNotEmpty) {
      final _urls = await uploadRemote.uploadVideos(videos);
      urls = [...urls, ..._urls];
    }
    if (images.isNotEmpty) {
      final _urls = await uploadRemote.uploadImages(images);
      urls = [...urls, ..._urls];
    }

    final response = await apiClient.post(Endpoints.sendMessage, data: {
      "conversationId": conversationId,
      "type": type.name,
      "message": message,
      "replyId": replyId,
      "attachments": urls,
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
    List<String> images = [];
    List<String> videos = [];

    for (var e in attachments) {
      if (fileIsVideo(e)) {
        videos.add(e);
      } else {
        images.add(e);
      }
    }

    List<String> urls = [];

    if (videos.isNotEmpty) {
      final _urls = await uploadRemote.uploadVideos(videos);
      urls = [...urls, ..._urls];
    }
    if (images.isNotEmpty) {
      final _urls = await uploadRemote.uploadImages(images);
      urls = [...urls, ..._urls];
    }

    final response = await apiClient.post(Endpoints.createConversation, data: {
      "message": {
        "type": type.name,
        "message": message,
        "replyId": replyId,
        "attachments": urls,
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

  @override
  Future<Map<String, dynamic>> updateConversation({
    required int id,
    required String name,
  }) async {
    final response = await apiClient.patch(
      Endpoints.updateConversation.replaceFirst(":id", id.toString()),
      data: {"name": name},
    );

    return response.data;
  }
}
