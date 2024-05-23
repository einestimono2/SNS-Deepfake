import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'group_model.dart';

class ShortGroupModel extends Equatable {
  final int id;
  final String groupName;
  final String? description;
  final String? coverPhoto;

  const ShortGroupModel({
    required this.id,
    required this.groupName,
    this.description,
    this.coverPhoto,
  });

  @override
  List<Object?> get props => [id, groupName, description, coverPhoto];

  factory ShortGroupModel.fromMap(Map<String, dynamic> map) {
    return ShortGroupModel(
      id: map['id']?.toInt() ?? 0,
      groupName: map['groupName'] ?? '',
      description: map['description'],
      coverPhoto: map['coverPhoto'],
    );
  }
  
  factory ShortGroupModel.fromGroupModel(GroupModel gr) {
    return ShortGroupModel(
      id: gr.id,
      groupName: gr.groupName ?? "",
      description: gr.description,
      coverPhoto: gr.coverPhoto,
    );
  }

  factory ShortGroupModel.fromJson(String source) =>
      ShortGroupModel.fromMap(json.decode(source));
}
