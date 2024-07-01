import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';

class MessageModel extends Equatable {
  final int id;
  final int? replyId;
  final String? message;
  final int senderId;
  final List<int> seenIds;
  final List<String> attachments;
  final String createdAt;
  final MessageType type;
  final int conversationId;
  final MessageModel? reply;

  const MessageModel({
    required this.attachments,
    required this.type,
    required this.id,
    this.replyId,
    this.message,
    this.reply,
    required this.senderId,
    required this.conversationId,
    required this.seenIds,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        message,
        senderId,
        seenIds,
        createdAt,
        type,
        attachments,
        replyId,
        conversationId
      ];

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id']?.toInt() ?? 0,
      replyId: map['replyId']?.toInt(),
      conversationId: map['conversationId']?.toInt() ?? -1,
      message: map['message'],
      senderId: map['senderId']?.toInt() ?? 0,
      seenIds: List<int>.from(map['seenIds']),
      attachments: map['attachments'] == null
          ? []
          : List<String>.from(map['attachments']),
      createdAt: map['createdAt'] ?? '',
      type: MessageType.values.byName(map['type']),
      reply: map['reply'] != null ? MessageModel.fromMap(map['reply']) : null,
    );
  }

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));
}
