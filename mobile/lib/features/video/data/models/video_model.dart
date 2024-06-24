import 'package:equatable/equatable.dart';

import '../../../chat/chat.dart';
import '../../../group/data/data.dart';
import '../../../news_feed/data/models/post_media_model.dart';

class VideoModel extends Equatable {
  final int id;
  final int authorId;
  final String? description;
  final bool edited;
  final int kudosCount;
  final int disappointedCount;
  final int trustCount;
  final int fakeCount;
  final MemberModel author;
  final List<PostMediaModel> videos;
  final ShortGroupModel? group;
  final bool canEdit;
  final bool banned;
  final String createdAt;

  const VideoModel({
    required this.id,
    required this.authorId,
    this.description,
    this.edited = false,
    this.kudosCount = 0,
    this.disappointedCount = 0,
    this.trustCount = 0,
    this.fakeCount = 0,
    required this.author,
    this.group,
    this.videos = const [],
    this.canEdit = false,
    this.banned = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        authorId,
        description,
        edited,
        kudosCount,
        disappointedCount,
        trustCount,
        fakeCount,
        author,
        group,
        videos,
        canEdit,
        banned,
        createdAt,
      ];

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['post']['id']?.toInt() ?? 0,
      description: map['post']['description'],
      authorId: map['post']['authorId'],
      edited: int.parse(map['post']['edited'].toString()) != 0,
      kudosCount: int.parse(map['post']['kudosCount']?.toString() ?? '0'),
      disappointedCount:
          int.parse(map['post']['disappointedCount']?.toString() ?? '0'),
      trustCount: int.parse(map['post']['trustCount']?.toString() ?? '0'),
      fakeCount: int.parse(map['post']['fakeCount']?.toString() ?? '0'),
      author: MemberModel.fromMap(map['post']['author']),
      group: map['post']['group'] != null
          ? ShortGroupModel.fromMap(map['post']['group'])
          : null,
      videos: List<PostMediaModel>.from(
        map['post']['videos']?.map((x) => PostMediaModel.fromMap(x)),
      ),
      canEdit: int.parse(map['can_edit'].toString()) != 0,
      banned: int.parse(map['banned'].toString()) != 0,
      createdAt: map['post']['createdAt'] ?? DateTime.now().toString(),
    );
  }
}
