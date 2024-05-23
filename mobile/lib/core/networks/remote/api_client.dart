import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../../base/base.dart';

const List<int> acceptedStatusCode = [200, 201, 204, 304];

class ApiClient {
  final Dio _dio;
  final CacheOptions _cacheOptions;

  ApiClient({
    required Dio dio,
    required CacheOptions cacheOptions,
  })  : _dio = dio,
        _cacheOptions = cacheOptions;

  Options? getRequestOptions(Options? options, CachePolicy? cacheOption) {
    Options _options = options ?? Options();

    if (cacheOption != null) {
      _options.extra ??= {};

      _options.extra!.addAll(
        _cacheOptions.copyWith(policy: cacheOption).toExtra(),
      );
    }

    return _options;
  }

  // - Get Method
  Future<BaseResponse> get(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    CachePolicy? cacheOption,
  }) async {
    try {
      final Response response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: getRequestOptions(options, cacheOption),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (acceptedStatusCode.contains(response.statusCode)) {
        return BaseResponse.fromMap(response.data);
      }

      throw "[API Client] Something went wrong";
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
    CachePolicy? cacheOption,
  }) async {
    try {
      final Response response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: getRequestOptions(options, cacheOption),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      if (acceptedStatusCode.contains(response.statusCode)) {
        return BaseResponse.fromMap(response.data);
      }

      throw "[API Client] Something went wrong";
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

      if (acceptedStatusCode.contains(response.statusCode)) {
        return BaseResponse.fromMap(response.data);
      }

      throw "[API Client] Something went wrong";
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

      if (acceptedStatusCode.contains(response.statusCode)) {
        return BaseResponse.fromMap(response.data);
      }

      throw "[API Client] Something went wrong";
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

      if (acceptedStatusCode.contains(response.statusCode)) {
        return BaseResponse.fromMap(response.data);
      }

      throw "[API Client] Something went wrong";
    } catch (e) {
      rethrow;
    }
  }
}
