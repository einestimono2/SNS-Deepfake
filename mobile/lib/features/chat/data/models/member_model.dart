import 'dart:convert';

import 'package:equatable/equatable.dart';

class MemberModel extends Equatable {
  final int id;
  final String? avatar;
  final String? username;
  final String email;
  final String? phoneNumber;
  final String? lastActive;

  const MemberModel({
    required this.id,
    this.avatar,
    this.username,
    required this.email,
    this.phoneNumber,
    this.lastActive,
  });

  @override
  List<Object?> get props => [id, avatar, username, email, phoneNumber, lastActive];

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id']?.toInt() ?? 0,
      avatar: map['avatar'],
      username: map['username'],
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      lastActive: map['lastActive'],
    );
  }

  factory MemberModel.fromJson(String source) => MemberModel.fromMap(json.decode(source));
}
