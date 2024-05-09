import 'dart:convert';

import 'package:equatable/equatable.dart';

class BaseResponse extends Equatable {
  final String status;
  final String? message;
  final dynamic data;
  final Map<String, dynamic>? extra;

  const BaseResponse({
    this.message,
    required this.status,
    this.extra,
    this.data,
  });

  @override
  List<Object?> get props => [message, data, extra, status];

  factory BaseResponse.fromMap(dynamic map) {
    return BaseResponse(
      status: map['status'],
      message: map['message'],
      data: map['data'],
      extra: map['extra'],
    );
  }

  factory BaseResponse.fromJson(String source) =>
      BaseResponse.fromMap(json.decode(source));
}
