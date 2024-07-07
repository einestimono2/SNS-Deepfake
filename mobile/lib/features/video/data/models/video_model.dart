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
  final int myFeel;

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
    this.myFeel = -1,
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
        myFeel
      ];

  VideoModel copyWith({
    int? kudosCount,
    int? disappointedCount,
    int? trustCount,
    int? fakeCount,
    int? id,
    int? authorId,
    String? description,
    bool? edited,
    int? myFeel,
    MemberModel? author,
    ShortGroupModel? group,
    List<PostMediaModel>? videos,
    bool? canEdit,
    bool? banned,
    String? createdAt,
  }) {
    return VideoModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      description: description ?? this.description,
      edited: edited ?? this.edited,
      kudosCount: kudosCount ?? this.kudosCount,
      disappointedCount: disappointedCount ?? this.disappointedCount,
      trustCount: trustCount ?? this.trustCount,
      fakeCount: fakeCount ?? this.trustCount,
      author: author ?? this.author,
      group: group ?? this.group,
      videos: videos ?? this.videos,
      canEdit: canEdit ?? this.canEdit,
      banned: banned ?? this.banned,
      createdAt: createdAt ?? this.createdAt,
      myFeel: myFeel ?? this.myFeel,
    );
  }

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
      myFeel: map['post']['feels'] != null && map['post']['feels']?.length > 0
          ? map['post']['feels'][0]["type"]
          : -1,
    );
  }
}
