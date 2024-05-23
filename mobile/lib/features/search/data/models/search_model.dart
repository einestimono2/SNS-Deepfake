import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils.dart';

class SearchModel extends Equatable {
  final int? id;
  final String keyword;
  final String? createdAt;
  final SearchHistoryType type;

  const SearchModel({
    this.id,
    required this.keyword,
    this.createdAt,
    required this.type,
  });

  @override
  List<Object?> get props => [keyword, id, createdAt, type];

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return SearchModel(
      id: map['id']?.toInt() ?? 0,
      keyword: map['keyword'] ?? '',
      createdAt: map['created'] ?? '',
      type: SearchHistoryType.values.byName(map['type'])
    );
  }

  factory SearchModel.fromJson(String source) =>
      SearchModel.fromMap(json.decode(source));
}
