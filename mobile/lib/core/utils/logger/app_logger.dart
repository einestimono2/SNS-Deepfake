import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger =
      Logger(printer: PrettyPrinter(printTime: true), level: Level.debug);

  static void debug(String message) => kReleaseMode ? null : _logger.d(message);
  static void info(String message) => kReleaseMode ? null : _logger.i(message);
  static void warn(String message) => kReleaseMode ? null : _logger.w(message);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      kReleaseMode
          ? null
          : _logger.e(
              message,
              error: error,
              stackTrace: stackTrace ?? StackTrace.current,
            );
}
