import 'dart:io';

import '../../core.dart';

///
/// App logging and analytics utils.
///
abstract class Log {
  static final _logger = Logger(
    printer: Platform.isIOS ? PrettyPrinter(colors: false) : null,
  );

  static bool _isTest() {
    return Platform.environment.containsKey('FLUTTER_TEST');
  }

  /// Info level
  static void i(Object? message, [dynamic data]) {
    if (!_isTest()) {
      _logger.i(message, data);
    }
  }

  /// Debug level
  static void d(Object? message, [dynamic data]) {
    if (!_isTest()) {
      _logger.d(message, data);
    }
  }

  /// Verbose level
  static void v(Object? message, [dynamic data]) {
    if (!_isTest()) {
      _logger.v(message, data);
    }
  }

  /// Warning level
  static void w(Object? message, [dynamic data]) {
    if (!_isTest()) {
      _logger.w(message, data);
    }
  }

  /// Error level
  static void e(Object? message, [dynamic error, StackTrace? stackTrace]) {
    if (!_isTest()) {
      _logger.e(message, error, stackTrace);
    }
  }
}
