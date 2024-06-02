import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../chat/chat.dart';

class GroupModel extends Equatable {
  final int id;
  final String? groupName;
  final String? description;
  final String? coverPhoto;
  final int creatorId;
  final String createdAt;
  final List<MemberModel> members;

  const GroupModel({
    required this.id,
    this.groupName,
    this.description,
    this.coverPhoto,
    required this.creatorId,
    required this.createdAt,
    this.members = const [],
  });

  @override
  List<Object?> get props => [
        id,
        groupName,
        description,
        coverPhoto,
        creatorId,
        createdAt,
        members,
      ];

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id']?.toInt() ?? 0,
      groupName: map['groupName'],
      description: map['description'],
      coverPhoto: map['coverPhoto'],
      creatorId: map['creatorId']?.toInt() ?? 0,
      createdAt: map['createdAt'] ?? '',
      members: map['members'] == null
          ? []
          : List<MemberModel>.from(
              map['members']?.map((x) => MemberModel.fromMap(x))),
    );
  }

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source));

  GroupModel copyWith({
    int? id,
    String? groupName,
    String? description,
    String? coverPhoto,
    int? creatorId,
    String? createdAt,
    List<MemberModel>? members,
  }) {
    return GroupModel(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
    );
  }
}
