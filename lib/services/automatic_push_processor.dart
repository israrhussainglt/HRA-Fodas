import '../../core/utils/logger.dart';

/// Automatic push notification processor
///
/// DEPRECATED: This service is no longer used.
/// All push notification processing has been moved to server-side Appwrite Functions:
/// - 'notification-sender': Handles actual push notification delivery
/// - 'donation-events': Triggers notifications based on donation status changes
///
/// This class is kept for backward compatibility but does nothing.
/// Consider removing it in future versions.
@Deprecated('Use server-side Appwrite Functions instead')
class AutomaticPushProcessor {
  AutomaticPushProcessor();

  /// Process pending notifications for a specific user
  /// DEPRECATED: Server-side function handles this now
  @Deprecated('Server-side function handles this')
  Future<void> processPendingNotificationsForUser(String userId) async {
    AppLogger.info(
      'Notification processing delegated to server-side function',
      tag: 'AUTO_PROCESSOR',
    );
  }

  /// Process all pending notifications (batch processing)
  /// DEPRECATED: Server-side function handles this now
  @Deprecated('Server-side function handles this')
  Future<void> processAllPendingNotifications() async {
    AppLogger.info(
      'Batch processing delegated to server-side function',
      tag: 'AUTO_PROCESSOR',
    );
  }
}
