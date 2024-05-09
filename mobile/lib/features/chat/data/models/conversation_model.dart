import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/core/utils/utils.dart';

import 'member_model.dart';
import 'message_model.dart';

class ConversationModel extends Equatable {
  final int id;
  final String? name;
  final ConversationType type;
  final int creatorId;
  final String? lastMessageAt;
  final String createdAt;
  final List<MemberModel> members;
  final List<MessageModel> messages;

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        creatorId,
        lastMessageAt,
        createdAt,
        members,
        messages,
      ];

  const ConversationModel({
    required this.id,
    this.name,
    required this.type,
    required this.creatorId,
    this.lastMessageAt,
    required this.createdAt,
    required this.members,
    required this.messages,
  });

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'],
      type: ConversationType.values.byName(map['type']),
      creatorId: map['creatorId']?.toInt() ?? 0,
      lastMessageAt: map['lastMessageAt'],
      createdAt: map['createdAt'],
      members: List<MemberModel>.from(
          map['members']?.map((x) => MemberModel.fromMap(x))),
      messages: List<MessageModel>.from(
          map['messages']?.map((x) => MessageModel.fromMap(x))),
    );
  }

  factory ConversationModel.fromJson(String source) =>
      ConversationModel.fromMap(json.decode(source));

  String getConversationName(int myId) {
    if (type == ConversationType.group) {
      return name ??
          members.map((e) => e.username ?? e.email).toList().join(', ');
    } else {
      final other = members.firstWhere((element) => element.id != myId);

      return other.username ?? other.email;
    }
  }

  List<String> getConversationAvatar(int myId) {
    if (type == ConversationType.group) {
      return members.take(2).map((e) => e.avatar?.fullPath ?? "").toList();
    } else {
      final other = members.firstWhere((element) => element.id != myId);

      return [other.avatar?.fullPath ?? ""];
    }
  }

  String getConversationTime(String locale) {
    return Formatter.formatDateWithSpecificWeekday(
      lastMessageAt ?? createdAt,
      locale,
    );
  }

  String getNewestMessage(int myId) {
    if (messages.isEmpty) return "JUST_CREATED_CONVERSATION_TEXT".tr();

    String from = "";
    MemberModel sender =
        members.firstWhere((member) => member.id == messages.first.senderId);

    if (sender.id == myId) {
      from = "YOU:_TEXT".tr(); // Đã có khoảng cách ở sau ("Bạn: " | "You: ")
    } else if (type == ConversationType.group) {
      from = "${sender.username ?? sender.email}: ";
    }

    return from +
        (messages.first.message ?? "JUST_CREATED_CONVERSATION_TEXT".tr());
  }

  bool isReadNewestMessage(int myId) {
    if (messages.isEmpty) return false;

    return messages.first.seenIds.contains(myId);
  }

  bool isReadNewestMessageByOther(int myId) {
    if (type == ConversationType.group) return false;

    return messages.first.seenIds
        .contains(members.firstWhere((element) => element.id != myId).id);
  }

  ConversationModel copyWith({
    int? id,
    String? name,
    ConversationType? type,
    int? creatorId,
    String? lastMessageAt,
    String? createdAt,
    List<MemberModel>? members,
    List<MessageModel>? messages,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      creatorId: creatorId ?? this.creatorId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
      messages: messages ?? this.messages,
    );
  }
}
