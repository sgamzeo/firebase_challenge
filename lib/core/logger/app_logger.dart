import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(printer: SimplePrinter());

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
