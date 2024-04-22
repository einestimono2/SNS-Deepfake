import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? id;
  final int role;
  final String? avatar;
  final String? coverImage;
  final String? phoneNumber;
  final String email;
  final String? token;
  final String? username;
  final int status;
  final int? coins;

  const UserModel({
    this.id,
    required this.role,
    this.avatar,
    this.coverImage,
    this.phoneNumber,
    required this.email,
    this.token,
    this.username,
    required this.status,
    this.coins,
  });

  @override
  List<Object?> get props => [
        id,
        role,
        avatar,
        coverImage,
        phoneNumber,
        email,
        token,
        username,
        status,
        coins
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'avatar': avatar,
      'coverImage': coverImage,
      'phoneNumber': phoneNumber,
      'email': email,
      'token': token,
      'username': username,
      'status': status,
      'coins': coins,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      role: map['role']?.toInt() ?? 0,
      avatar: map['avatar'],
      coverImage: map['coverImage'],
      phoneNumber: map['phoneNumber'],
      email: map['email'] ?? '',
      token: map['token'],
      username: map['username'],
      status: map['status']?.toInt() ?? 0,
      coins: map['coins']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    int? id,
    int? role,
    String? avatar,
    String? coverImage,
    String? phoneNumber,
    String? email,
    String? token,
    String? username,
    int? status,
    int? coins,
  }) {
    return UserModel(
      id: id ?? this.id,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      token: token ?? this.token,
      username: username ?? this.username,
      status: status ?? this.status,
      coins: coins ?? this.coins,
    );
  }
}
