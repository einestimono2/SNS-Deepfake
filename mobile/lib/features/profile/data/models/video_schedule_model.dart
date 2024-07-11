import 'package:equatable/equatable.dart';

class VideoScheduleModel extends Equatable {
  final int id;
  final Map<String, dynamic> video;
  final Map<String, dynamic> user;
  final Map<String, dynamic> target;
  final String time;
  final String createdAt;
  final int repeat;

  const VideoScheduleModel({
    required this.id,
    required this.video,
    required this.user,
    required this.target,
    required this.time,
    required this.repeat,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, video, user, target, time, createdAt, repeat];

  factory VideoScheduleModel.fromMap(Map<String, dynamic> map) {
    return VideoScheduleModel(
      id: int.parse(map['id'].toString()),
      user: map['user'],
      video: map['video'],
      target: map['target'],
      createdAt: map['createdAt'] ?? '',
      time: map['time'] ?? '',
      repeat: int.parse(map['repeat'].toString()),
    );
  }
}
