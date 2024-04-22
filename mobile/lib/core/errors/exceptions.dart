import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String? _message;

  const ServerException(this._message);

  get message => _message;

  @override
  String toString() => '$_message';
}

class UnknownException implements Exception {}

class CacheException implements Exception {}

class OfflineException implements Exception {}

class UnauthenticatedException implements Exception {}

class HttpException implements Exception {
  late String message;

  HttpException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = 'Request to the server was cancelled.';
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection timed out.';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receiving timeout occurred.';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Request send timeout.';
        break;
      case DioExceptionType.badResponse:
        try {
          message = _handleBadResponse(dioError.response);
        } catch (e) {
          message = e.toString();
        }
        break;
      case DioExceptionType.connectionError:
        message = 'The server is not responding or is under maintenance!';
        break;
      case DioExceptionType.unknown:
        if (dioError.message!.contains('SocketException')) {
          message = 'No Internet.';
          break;
        }
        message = 'Unexpected error occurred.';
        break;
      default:
        message = 'Something went wrong';
        break;
    }
  }

  String _handleBadResponse(Response<dynamic>? response) {
    final ec = response?.data['ec'];
    if (ec != null) {
      switch (ec) {
        /* Custom error code */
        // Bearer Token Empty
        case 1001:
          return response?.data?['message'];

        default:
      }
    }

    switch (response?.statusCode) {
      case 400:
        return response?.data?['message'] ?? 'Bad request.';
      case 401:
        return response?.data?['message'] ?? 'Authentication failed.';
      case 403:
        return response?.data?['message'] ??
            'The authenticated user is not allowed to access the specified API endpoint.';
      case 404:
        return response?.data?['message'] ??
            'The requested resource does not exist.';
      case 405:
        return response?.data?['message'] ??
            'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
      case 415:
        return response?.data?['message'] ??
            'Unsupported media type. The requested content type or version number is invalid.';
      case 422:
        return response?.data?['message'] ?? 'Data validation failed.';
      case 429:
        return response?.data?['message'] ?? 'Too many requests.';
      case 500:
        return response?.data?['message'] ?? 'Internal server error.';
      default:
        return 'Oops something went wrong!';
    }
  }

  @override
  String toString() => message;
}
