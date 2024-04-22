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

  Map<String, Object> get headers {
    final header = {
      'accept': 'application/json',
      'content-type': 'application/json'
    };

    final accessToken = localCache.getString(AppStrings.accessTokenKey);
    if (accessToken?.isNotEmpty ?? false) {
      header['Authorization'] = 'Bearer $accessToken';
    }

    return header;
  }

  Dio init() {
    final dio = Dio(BaseOptions(
      baseUrl: FlavorConfig.instance.endpointUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      receiveDataWhenStatusError: true,
      headers: headers,
      // maxRedirects: 2,
    ));

    // - HTTPS certificate verification
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );

    // - Logger
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

    // Retry
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

// <== Custom ==>
// class DioConnectivityRequestRetrier {
//   DioConnectivityRequestRetrier({
//     required this.dio,
//     required this.connectivity,
//   });

//   final Dio dio;
//   final Connectivity connectivity;

//   Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
//     late StreamSubscription streamSubscription;
//     final responseCompleter = Completer<Response>();

//     streamSubscription =
//         connectivity.onConnectivityChanged.listen((connectivityResult) {
//       if (connectivityResult != ConnectivityResult.none) {
//         streamSubscription.cancel();
//         responseCompleter.complete(dio.request(
//           requestOptions.path,
//           cancelToken: requestOptions.cancelToken,
//           data: requestOptions.data,
//           onReceiveProgress: requestOptions.onReceiveProgress,
//           onSendProgress: requestOptions.onSendProgress,
//           queryParameters: requestOptions.queryParameters,
//         ));
//       }
//     });

//     return responseCompleter.future;
//   }
// }

// class RetryOnConnectionChangeInterceptor extends Interceptor {
//   RetryOnConnectionChangeInterceptor({
//     required this.requestRetrier,
//   });

//   final DioConnectivityRequestRetrier requestRetrier;

//   @override
//   Future onError(
//     DioException err,
//     ErrorInterceptorHandler handler,
//   ) async {
//     if (_shouldRetry(err)) {
//       try {
//         return requestRetrier.scheduleRequestRetry(err.requestOptions);
//       } catch (e) {
//         return e;
//       }
//     }

//     return err;
//   }

//   bool _shouldRetry(DioException err) {
//     return err.type == DioExceptionType.unknown &&
//         err.error != null &&
//         err.error is SocketException;
//   }
// }

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