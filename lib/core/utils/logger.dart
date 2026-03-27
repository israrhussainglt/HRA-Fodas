import 'package:flutter/foundation.dart';

/// Application-wide logger utility
///
/// Provides structured logging with different levels:
/// - debug: Development-only logs
/// - info: General information
/// - warning: Warning messages
/// - error: Error messages with optional stack traces
class AppLogger {
  static const String _prefix = '[HRA-FoDAS]';

  /// Log debug message (only in debug mode)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr 🔍 $message');
    }
  }

  /// Log info message
  static void info(String message, {String? tag}) {
    final tagStr = tag != null ? '[$tag]' : '';
    debugPrint('$_prefix$tagStr ℹ️ $message');
  }

  /// Log warning message
  static void warning(String message, {String? tag, Object? error}) {
    final tagStr = tag != null ? '[$tag]' : '';
    debugPrint('$_prefix$tagStr ⚠️ $message');
    if (error != null) {
      debugPrint('$_prefix$tagStr    Error: $error');
    }
  }

  /// Log error message with optional stack trace
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final tagStr = tag != null ? '[$tag]' : '';
    debugPrint('$_prefix$tagStr ❌ $message');
    if (error != null) {
      debugPrint('$_prefix$tagStr    Error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('$_prefix$tagStr    Stack trace:\n$stackTrace');
    }
  }

  /// Log success message
  static void success(String message, {String? tag}) {
    final tagStr = tag != null ? '[$tag]' : '';
    debugPrint('$_prefix$tagStr ✅ $message');
  }

  /// Log network request
  static void network(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr 🌐 $message');
    }
  }

  /// Log database operation
  static void database(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr 💾 $message');
    }
  }

  /// Log authentication operation
  static void auth(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr 🔐 $message');
    }
  }

  /// Log notification operation
  static void notification(String message, {String? tag}) {
    if (kDebugMode) {
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('$_prefix$tagStr 🔔 $message');
    }
  }
}
