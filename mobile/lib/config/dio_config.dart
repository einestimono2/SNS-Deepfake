import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';

import '../core/networks/networks.dart';
import '../core/utils/utils.dart';
import 'configs.dart';

class DioConfigs {
  final Connectivity connectivity;
  final LocalCache localCache;

  DioConfigs({
    required this.localCache,
    required this.connectivity,
  });

  Dio init() {
    /* Init */
    final dio = Dio(BaseOptions(
      baseUrl: FlavorConfig.instance.endpointUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      receiveDataWhenStatusError: true,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json'
      },
      // maxRedirects: 2,
    ));

    /* HTTPS certificate verification */
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client = HttpClient(
          context: SecurityContext(withTrustedRoots: false),
        );
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

    /* Logger Interceptor */
    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    /* Authentication Interceptor */
    dio.interceptors.add(AuthInterceptor(localCache));

    /* Retry Interceptor */
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: AppLogger.warn, // specify log function (optional)
        retries: 3, // retry count (optional)
        retryDelays: const [
          // set delays between retries (optional)
          Duration(seconds: 1), // wait 1 sec before first retry
          Duration(seconds: 2), // wait 2 sec before second retry
          Duration(seconds: 3), // wait 3 sec before third retry
        ],
      ),
    );

    // dio_http_cache

    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  final LocalCache localCache;

  AuthInterceptor(this.localCache);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = localCache.getString(AppStrings.accessTokenKey);
    if (accessToken?.isNotEmpty ?? false) {
      options.headers.addAll({'Authorization': 'Bearer $accessToken'});
    }

    return handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    /* Xử lý Refresh Token */
    // if (err.response!.statusCode == 403 || err.response!.statusCode == 401) {
    //   final options = err.requestOptions;
    //   final accessToken = await _tokenService.refreshToken();

    //   if (accessToken == null || accessToken.isEmpty) {
    //     return handler.reject(err);
    //   } else {
    //     options.headers.addAll({'Authorization': accessToken});

    //     try {
    //       final _res = await _tokenService.fetch(options);
    //       return handler.resolve(_res);
    //     } on DioException catch (e) {
    //      handler.next(e);
    //      return;
    //      }
    // }

    return handler.next(err);
  }
}

/* 
class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
    // Customize the printer
    printer: PrettyPrinter(
      methodCount: 0,
      printTime: false,
    ),
  );

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request => $requestPath'); // Debug log
    logger.d('Error: ${err.error}, Message: ${err.message}'); // Error log
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request => $requestPath'); // Info log
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d(
        'StatusCode: ${response.statusCode}, Data: ${response.data}'); // Debug log
    return super.onResponse(response, handler);
  }
}
*/