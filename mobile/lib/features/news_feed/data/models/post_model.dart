import 'dart:collection';
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';
import '../../../chat/chat.dart';
import '../../../group/group.dart';
import 'post_media_model.dart';

class PostModel extends Equatable {
  final int id;
  final String? description;
  final String? status;
  final bool edited;
  final int? categoryId;
  final int? rate;
  final int kudosCount;
  final int disappointedCount;
  final int trustCount;
  final int fakeCount;
  final MemberModel author;
  final ShortGroupModel? group;
  final List<PostMediaModel> videos;
  final List<PostMediaModel> images;
  final bool canEdit;
  final bool banned;
  final String createdAt;
  final int numShares;
  final int myFeel;

  int get reactionCount => disappointedCount + kudosCount;

  int get commentCount => trustCount + fakeCount;

  List<String> reactionOrder() {
    Map<String, int> _map = {};
    if (kudosCount > 0) _map[AppImages.likeReaction] = kudosCount; // like
    if (disappointedCount > 0) {
      _map[AppImages.dislikeReaction] = disappointedCount; // dislike
    }
    // if (trustCount > 0) _map[AppImages.sadReaction] = trustCount;
    // if (fakeCount > 0) _map[AppImages.hahaReaction] = fakeCount;

    return SplayTreeMap<String, int>.from(
      _map,
      (a, b) => _map[a]! > _map[b]! ? -1 : 1,
    ).keys.toList();
  }

  const PostModel({
    required this.id,
    this.description,
    this.status,
    this.edited = false,
    this.categoryId,
    this.rate,
    this.kudosCount = 0,
    this.disappointedCount = 0,
    this.trustCount = 0,
    this.fakeCount = 0,
    required this.author,
    this.group,
    this.videos = const [],
    this.images = const [],
    this.canEdit = false,
    this.banned = false,
    this.myFeel = -1,
    this.numShares = 0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        description,
        status,
        edited,
        categoryId,
        rate,
        kudosCount,
        disappointedCount,
        trustCount,
        fakeCount,
        author,
        group,
        videos,
        images,
        canEdit,
        banned,
        createdAt,
        myFeel,
        numShares
      ];

  PostModel copyWith({
    int? kudosCount,
    int? disappointedCount,
    int? trustCount,
    int? fakeCount,
    int? id,
    String? description,
    String? status,
    bool? edited,
    int? categoryId,
    int? rate,
    int? myFeel,
    int? numShares,
    MemberModel? author,
    ShortGroupModel? group,
    List<PostMediaModel>? videos,
    List<PostMediaModel>? images,
    bool? canEdit,
    bool? banned,
    String? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      description: description ?? this.description,
      status: status ?? this.status,
      edited: edited ?? this.edited,
      categoryId: categoryId ?? this.categoryId,
      rate: rate ?? this.rate,
      kudosCount: kudosCount ?? this.kudosCount,
      disappointedCount: disappointedCount ?? this.disappointedCount,
      trustCount: trustCount ?? this.trustCount,
      fakeCount: fakeCount ?? this.trustCount,
      author: author ?? this.author,
      group: group ?? this.group,
      videos: videos ?? this.videos,
      images: images ?? this.images,
      canEdit: canEdit ?? this.canEdit,
      banned: banned ?? this.banned,
      createdAt: createdAt ?? this.createdAt,
      myFeel: myFeel ?? this.myFeel,
      numShares: numShares ?? this.numShares,
    );
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['post']['id']?.toInt() ?? 0,
      description: map['post']['description'],
      status: map['post']['status'],
      edited: int.parse(map['post']['edited'].toString()) != 0,
      categoryId: map['post']['categoryId']?.toInt(),
      rate: map['post']['rate']?.toInt(),
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
      images: List<PostMediaModel>.from(
        map['post']['images']?.map((x) => PostMediaModel.fromMap(x)),
      ),
      canEdit: int.parse(map['can_edit'].toString()) != 0,
      banned: int.parse(map['banned'].toString()) != 0,
      createdAt: map['post']['createdAt'] ?? DateTime.now().toString(),
      myFeel: map['post']['feels']?.length > 0
          ? map['post']['feels'][0]["type"]
          : -1,
      numShares: map['post']['numberOfShared'] ?? 0,
    );
  }

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));
}
