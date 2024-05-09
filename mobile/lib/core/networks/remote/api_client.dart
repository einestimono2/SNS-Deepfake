import 'package:dio/dio.dart';

import '../../base/base.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({required Dio dio}) : _dio = dio;

  // - Get Method
  Future<BaseResponse> get(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BaseResponse.fromMap(response.data);
      }

      throw "Something went wrong";
    } catch (e) {
      rethrow;
    }
  }

  // - Post Method
  Future<BaseResponse> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BaseResponse.fromMap(response.data);
      }

      throw "Something went wrong";
    } catch (e) {
      rethrow;
    }
  }

  // - Put Method
  Future<BaseResponse> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BaseResponse.fromMap(response.data);
      }

      throw "Something went wrong";
    } catch (e) {
      rethrow;
    }
  }

  // - Patch Method
  Future<BaseResponse> patch(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BaseResponse.fromMap(response.data);
      }

      throw "Something went wrong";
    } catch (e) {
      rethrow;
    }
  }

  // - Delete Method
  Future<BaseResponse> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return BaseResponse.fromMap(response.data);
      }

      throw "Something went wrong";
    } catch (e) {
      rethrow;
    }
  }
}
