import 'dart:convert';

import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
  final int id;
  final int? edited;
  final String? description;
  final String? status;
  final int? rate;

  const PostModel({
    required this.id,
    this.edited,
    this.description,
    this.status,
    this.rate,
  });

  @override
  List<Object?> get props => [id, edited, description, status, rate];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'edited': edited,
      'description': description,
      'status': status,
      'rate': rate,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id']?.toInt() ?? 0,
      edited: map['edited']?.toInt(),
      description: map['description'],
      status: map['status'],
      rate: map['rate']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  PostModel copyWith({
    int? id,
    int? edited,
    String? description,
    String? status,
    int? rate,
  }) {
    return PostModel(
      id: id ?? this.id,
      edited: edited ?? this.edited,
      description: description ?? this.description,
      status: status ?? this.status,
      rate: rate ?? this.rate,
    );
  }
}
