import 'package:equatable/equatable.dart';
import 'package:sns_deepfake/features/authentication/authentication.dart';

class VideoDeepfakeModel extends Equatable {
  final int id;
  final String title;
  final String url;
  final int status;
  final int userId;
  final ShortUserModel user;
  final String createdAt;

  const VideoDeepfakeModel({
    required this.id,
    required this.title,
    required this.url,
    required this.status,
    required this.userId,
    required this.user,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, status, title, url, userId, user, createdAt];

  factory VideoDeepfakeModel.fromMap(Map<String, dynamic> map) {
    return VideoDeepfakeModel(
      id: map['id'] ?? 0,
      userId: map['userId'] ?? 0,
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      createdAt: map['createdAt'] ?? '',
      status: int.parse(map['status'].toString()),
      user: ShortUserModel.fromMap(map['user']),
    );
  }
}
