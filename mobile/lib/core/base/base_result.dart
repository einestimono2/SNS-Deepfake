import 'package:equatable/equatable.dart';

import 'base_response.dart';

class PaginationResult<T> extends Equatable {
  final List<T> data;
  final int pageIndex;
  final int pageSize;
  final int totalPages;
  final int totalCount;

  const PaginationResult({
    required this.data,
    required this.pageIndex,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [
        data,
        pageIndex,
        pageSize,
        totalPages,
        totalCount,
      ];

  factory PaginationResult.fromData({
    Map<String, dynamic>? extra,
    required List<T> data,
  }) {
    return PaginationResult<T>(
      data: data,
      pageIndex: extra?["pageIndex"] ?? 0,
      pageSize: extra?["pageSize"] ?? 0,
      totalPages: extra?["totalPages"] ?? 0,
      totalCount: extra?["totalCount"] ?? 0,
    );
  }

  factory PaginationResult.fromBaseResponse({
    required BaseResponse baseResponse,
    required T Function(dynamic e) mapFunc,
  }) {
    return PaginationResult<T>(
      data: baseResponse.data.map<T>((e) => mapFunc(e)).toList(),
      pageIndex: baseResponse.extra?["pageIndex"] ?? 0,
      pageSize: baseResponse.extra?["pageSize"] ?? 0,
      totalPages: baseResponse.extra?["totalPages"] ?? 0,
      totalCount: baseResponse.extra?["totalCount"] ?? 0,
    );
  }
}
