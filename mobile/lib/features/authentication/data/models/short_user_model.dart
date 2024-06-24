import 'dart:convert';

import 'package:equatable/equatable.dart';

class ShortUserModel extends Equatable {
  final int id;
  final String? avatar;
  final String username;
  final String? phoneNumber;

  const ShortUserModel({
    required this.id,
    this.avatar,
    required this.username,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [id, avatar, username, phoneNumber];

  factory ShortUserModel.fromMap(Map<String, dynamic> map) {
    return ShortUserModel(
      id: map['id']?.toInt() ?? 0,
      avatar: map['avatar'],
      username: map['username'] ?? map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
    );
  }

  factory ShortUserModel.fromJson(String source) =>
      ShortUserModel.fromMap(json.decode(source));
}
