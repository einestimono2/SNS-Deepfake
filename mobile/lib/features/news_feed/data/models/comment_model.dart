import 'package:equatable/equatable.dart';

import '../../../authentication/data/data.dart';

class CommentModel extends Equatable {
  final int id;
  final String content;
  final String createdAt;
  final int type;
  final ShortUserModel author;
  final List<CommentModel> nested;

  const CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.type,
    required this.author,
    this.nested = const [],
  });

  @override
  List<Object?> get props => [id, content, createdAt, type, author, nested];

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id']?.toInt() ?? 0,
      content: map['mark_content'],
      type: int.parse(map['type_of_mark'].toString()),
      createdAt: map['created'] ?? '',
      author: ShortUserModel.fromMap(map['poster']),
      nested: List<CommentModel>.from(
        map['comments']?.map((x) => CommentModel.fromMap(x)) ?? [],
      ),
    );
  }
}
