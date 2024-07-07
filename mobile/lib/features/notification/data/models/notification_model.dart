import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final int type;
  final int id;
  final int objectId;
  final String title;
  final String createdAt;

  const NotificationModel({
    required this.type,
    required this.id,
    required this.objectId,
    required this.title,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [type, id, objectId, title, createdAt];

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: int.parse(map['data']['notification_id'].toString()),
      type: int.parse(map['data']['type'].toString()),
      objectId: int.parse(map['data']['object_id'].toString()),
      title: map['data']['title'],
      createdAt: map['data']['created'],
    );
  }
}
