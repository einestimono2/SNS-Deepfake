import 'dart:convert';

import 'package:equatable/equatable.dart';

class FriendModel extends Equatable {
  final int id;
  final String? username;
  final String? avatar;
  final int sameFriends;
  final String createdAt;
  final List<String> sameFriendAvatars;

  const FriendModel({
    required this.id,
    this.username,
    this.avatar,
    this.sameFriends = 0,
    required this.createdAt,
    this.sameFriendAvatars = const [],
  });

  @override
  List<Object?> get props =>
      [id, username, avatar, sameFriends, createdAt, sameFriendAvatars];

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    List<String> avatars = [];
    map['commonUserAvatars']?.forEach((e) {
      avatars.add(e ?? "");
    });

    return FriendModel(
      id: map['id'] ?? -1,
      username: map['username'],
      avatar: map['avatar'] ?? '',
      sameFriends: int.parse(map['same_friends']?.toString() ?? '0'),
      createdAt: map['created'] ?? '',
      sameFriendAvatars: avatars,
    );
  }

  factory FriendModel.fromJson(String source) =>
      FriendModel.fromMap(json.decode(source));
}
