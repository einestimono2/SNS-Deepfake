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
  int? ec;

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
          final data = _handleBadResponse(dioError.response);
          message = data[0];
          ec = data[1];
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

  List<dynamic> _handleBadResponse(Response<dynamic>? response) {
    final ec = response?.data['ec'];
    String message;

    switch (response?.statusCode) {
      case 400:
        message = response?.data?['message'] ?? 'Bad request.';
        break;
      case 401:
        message = response?.data?['message'] ?? 'Authentication failed.';
        break;
      case 403:
        message = response?.data?['message'] ??
            'The authenticated user is not allowed to access the specified API endpoint.';
        break;
      case 404:
        message = response?.data?['message'] ??
            'The requested resource does not exist.';
        break;
      case 405:
        message = response?.data?['message'] ??
            'Method not allowed. Please check the Allow header for the allowed HTTP methods.';
        break;
      case 415:
        message = response?.data?['message'] ??
            'Unsupported media type. The requested content type or version number is invalid.';
        break;
      case 422:
        message = response?.data?['message'] ?? 'Data validation failed.';
        break;
      case 429:
        message = response?.data?['message'] ?? 'Too many requests.';
        break;
      case 500:
        message = response?.data?['message'] ?? 'Internal server error.';
        break;
      default:
        message = 'Oops something went wrong!';
        break;
    }

    return [message, ec];
  }

  @override
  String toString() => message;
}
