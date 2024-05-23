import 'dart:convert';

import 'package:equatable/equatable.dart';

class PostMediaModel extends Equatable {
  final int id;
  final int postId;
  final String url;
  final String createdAt;

  const PostMediaModel({
    required this.id,
    required this.postId,
    required this.url,
    required this.createdAt,
  });
  
  @override
  List<Object?> get props => [id, postId, url, createdAt];

  factory PostMediaModel.fromMap(Map<String, dynamic> map) {
    return PostMediaModel(
      id: map['id']?.toInt() ?? 0,
      postId: map['postId']?.toInt() ?? 0,
      url: map['url'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  factory PostMediaModel.fromJson(String source) => PostMediaModel.fromMap(json.decode(source));
}
