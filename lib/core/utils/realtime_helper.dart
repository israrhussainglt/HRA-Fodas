import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'logger.dart';

/// Helper class for managing Appwrite Realtime subscriptions with error handling
class RealtimeHelper {
  /// Subscribe to realtime channels with automatic error handling
  ///
  /// This wrapper suppresses verbose connection logs and handles errors gracefully
  static RealtimeSubscription subscribe(
    Realtime realtime,
    List<String> channels, {
    String? tag,
  }) {
    final subscription = realtime.subscribe(channels);

    // Listen to the stream and handle errors silently
    subscription.stream.listen(
      (event) {
        // Events are handled by the caller
      },
      onError: (error) {
        // Only log errors in debug mode
        if (kDebugMode) {
          AppLogger.debug(
            'Realtime connection error: $error',
            tag: tag ?? 'REALTIME',
          );
        }
        // Suppress error - Appwrite will automatically reconnect
      },
      cancelOnError: false, // Keep subscription alive even on errors
    );

    return subscription;
  }

  /// Close a subscription safely
  static void closeSubscription(RealtimeSubscription? subscription) {
    try {
      subscription?.close();
    } catch (e) {
      // Ignore errors when closing
    }
  }
}
