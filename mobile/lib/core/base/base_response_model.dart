import 'dart:convert';

import 'package:equatable/equatable.dart';

class BaseResponseModel extends Equatable {
  final int statusCode;
  final String message;
  final dynamic data;
  final dynamic paging;
  final dynamic extra;

  const BaseResponseModel({
    required this.statusCode,
    required this.message,
    this.paging,
    this.extra,
    this.data,
  });

  @override
  List<Object?> get props => [statusCode, message, data, paging, extra];

  factory BaseResponseModel.fromMap(Map<String, dynamic> map) {
    return BaseResponseModel(
      statusCode: map['meta']['status_code']?.toInt() ?? 0,
      message: map['meta']['message'] ?? '',
      data: map['data'],
      paging: map['paging'],
      extra: map['Extra'],
    );
  }

  factory BaseResponseModel.fromJson(String source) =>
      BaseResponseModel.fromMap(json.decode(source));
}
