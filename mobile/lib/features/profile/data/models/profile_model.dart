import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';

class ProfileModel extends Equatable {
  final int id;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? avatar;
  final String? coverImage;
  final int totalFriends;
  final FriendStatus friendStatus;
  final BlockStatus blockStatus;
  final String createdAt;
  final int conversationId;

  const ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.avatar,
    this.coverImage,
    required this.createdAt,
    this.totalFriends = 0,
    required this.friendStatus,
    required this.blockStatus,
    required this.conversationId,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        phoneNumber,
        avatar,
        coverImage,
        totalFriends,
        createdAt,
        email,
        friendStatus,
        conversationId,
        blockStatus
      ];

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? -1,
      username: map['username'] ?? map['email'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      avatar: map['avatar'],
      coverImage: map['coverImage'],
      totalFriends: map['totalFriends']?.toInt() ?? -1,
      conversationId: map['conversationId']?.toInt() ?? -1,
      createdAt: map['createdAt'] ?? '',
      friendStatus: FriendStatus.values[
          map['friendStatus']?.toInt() ?? FriendStatus.values.length - 1],
      blockStatus: BlockStatus
          .values[map['blockStatus']?.toInt() ?? BlockStatus.values.length - 1],
    );
  }

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source));

  ProfileModel copyWith({
    int? id,
    String? username,
    String? email,
    String? phoneNumber,
    String? avatar,
    String? coverImage,
    int? totalFriends,
    FriendStatus? friendStatus,
    BlockStatus? blockStatus,
    String? createdAt,
    int? conversationId,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      coverImage: coverImage ?? this.coverImage,
      totalFriends: totalFriends ?? this.totalFriends,
      friendStatus: friendStatus ?? this.friendStatus,
      blockStatus: blockStatus ?? this.blockStatus,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}
