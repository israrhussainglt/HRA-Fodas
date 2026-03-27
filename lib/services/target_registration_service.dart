import 'package:appwrite/appwrite.dart';
import '../core/utils/logger.dart';
import 'appwrite_notification_service.dart';

/// Service to handle automatic FCM target registration
/// This ensures users get registered for push notifications when they log in
class TargetRegistrationService {
  static final TargetRegistrationService _instance =
      TargetRegistrationService._internal();
  static TargetRegistrationService get instance => _instance;

  TargetRegistrationService._internal();

  /// Register FCM target for current user
  /// Call this after successful login
  Future<void> registerCurrentUserTarget({
    required String userId,
    required Client appwriteClient,
    required Account account,
  }) async {
    try {
      AppLogger.notification(
        'Starting FCM target registration for user: $userId',
        tag: 'TARGET_REGISTRATION',
      );

      // Initialize notification service if not already done
      final notificationService = AppwriteNotificationService.instance;

      try {
        await notificationService.initialize(appwriteClient, account);
      } catch (initError) {
        AppLogger.warning(
          'Notification service initialization failed (continuing login)',
          tag: 'TARGET_REGISTRATION',
        );
        return; // Don't block login if notification service fails to initialize
      }

      // Get FCM token
      String? fcmToken;
      try {
        fcmToken = await notificationService.getToken();
      } catch (tokenError) {
        AppLogger.warning(
          'FCM token retrieval failed (continuing login)',
          tag: 'TARGET_REGISTRATION',
        );
        return; // Don't block login if FCM token fails
      }

      if (fcmToken == null) {
        AppLogger.warning(
          'No FCM token available - continuing login',
          tag: 'TARGET_REGISTRATION',
        );
        return;
      }

      AppLogger.success(
        'FCM token obtained: ${fcmToken.substring(0, 20)}...',
        tag: 'TARGET_REGISTRATION',
      );

      // Create messaging target in Appwrite
      String? targetId;
      try {
        targetId = await notificationService.createMessagingTarget(
          userId: userId,
          name: 'HRA-FoDAS Mobile App',
        );
      } catch (targetError) {
        AppLogger.warning(
          'Messaging target creation failed (continuing login)',
          tag: 'TARGET_REGISTRATION',
        );
        return; // Don't block login if target creation fails
      }

      if (targetId != null) {
        AppLogger.success(
          'Target registered successfully: $targetId',
          tag: 'TARGET_REGISTRATION',
        );
      } else {
        AppLogger.warning(
          'Target registration failed, but login will continue',
          tag: 'TARGET_REGISTRATION',
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error during target registration (login will continue)',
        tag: 'TARGET_REGISTRATION',
        error: e,
        stackTrace: stackTrace,
      );
      // Don't rethrow - this should not block login
    }
  }

  /// Unregister FCM target for current user
  /// Call this on logout
  Future<void> unregisterCurrentUserTarget({required String userId}) async {
    try {
      AppLogger.notification(
        'Unregistering FCM target for user: $userId',
        tag: 'TARGET_REGISTRATION',
      );

      final notificationService = AppwriteNotificationService.instance;
      await notificationService.deleteMessagingTarget(userId: userId);

      AppLogger.success(
        'Target unregistered successfully',
        tag: 'TARGET_REGISTRATION',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error during target unregistration',
        tag: 'TARGET_REGISTRATION',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Check if user has FCM target registered
  Future<bool> isUserTargetRegistered(String userId, Client client) async {
    try {
      // Check if FCM token exists in database
      final tablesDB = TablesDB(client);

      final existing = await tablesDB.listRows(
        databaseId: 'hra_fodas_main',
        tableId: 'fcm_tokens',
        queries: [
          Query.equal('user_id', userId),
          Query.equal('is_active', true),
        ],
      );

      final hasActiveToken = existing.rows.isNotEmpty;

      AppLogger.debug(
        'User $userId has active FCM token: $hasActiveToken',
        tag: 'TARGET_REGISTRATION',
      );
      return hasActiveToken;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error checking target status',
        tag: 'TARGET_REGISTRATION',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Refresh FCM token and update target
  /// Call this when FCM token is refreshed
  Future<void> refreshUserTarget({
    required String userId,
    required Client appwriteClient,
    required Account account,
  }) async {
    try {
      AppLogger.notification(
        'Refreshing FCM target for user: $userId',
        tag: 'TARGET_REGISTRATION',
      );

      // Unregister old target
      await unregisterCurrentUserTarget(userId: userId);

      // Register new target
      await registerCurrentUserTarget(
        userId: userId,
        appwriteClient: appwriteClient,
        account: account,
      );

      AppLogger.success(
        'Target refreshed successfully',
        tag: 'TARGET_REGISTRATION',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error during target refresh',
        tag: 'TARGET_REGISTRATION',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
