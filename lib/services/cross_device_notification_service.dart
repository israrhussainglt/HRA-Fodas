import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import '../data/models/notification_model.dart';
import '../../appwrite_options.dart';
import '../../core/utils/logger.dart';

/// Cross-device push notification service using Appwrite Database Triggers
///
/// This service creates a record in 'pending_push_notifications' collection.
/// An Appwrite Function (server-side) listens to this collection and sends
/// the actual push notification via FCM/APNs.
///
/// Security: All push notifications are sent server-side to prevent token exposure.
class CrossDeviceNotificationService {
  final Client _appwriteClient;
  late final TablesDB _databases;

  CrossDeviceNotificationService(this._appwriteClient) {
    _databases = TablesDB(_appwriteClient);
  }

  /// Send push notification to specific users on other devices
  Future<void> sendPushNotificationToUsers({
    required List<String> userIds,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
    String? excludeCurrentDevice,
  }) async {
    AppLogger.notification(
      'Queuing push notifications for ${userIds.length} users',
      tag: 'CROSS_DEVICE',
    );

    try {
      // Create a pending notification record for each user
      // The Appwrite Function will pick these up and send the actual push
      await _queueNotificationsForProcessing(
        userIds: userIds,
        title: title,
        body: body,
        type: type,
        relatedEntityId: relatedEntityId,
        relatedEntityType: relatedEntityType,
        actorName: actorName,
        data: data,
        excludeCurrentDevice: excludeCurrentDevice,
      );

      AppLogger.success(
        'Notifications queued successfully for processing',
        tag: 'CROSS_DEVICE',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to queue notifications',
        tag: 'CROSS_DEVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Queue notifications in the database for the server function to process
  Future<void> _queueNotificationsForProcessing({
    required List<String> userIds,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
    String? excludeCurrentDevice,
  }) async {
    // Deduplicate user IDs
    final uniqueUserIds = userIds.toSet().toList();

    for (final userId in uniqueUserIds) {
      try {
        // 1. Get active FCM tokens for this user
        final tokensResponse = await _databases.listRows(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.fcmTokensCollection,
          queries: [
            Query.equal('user_id', userId),
            Query.equal('is_active', true),
          ],
        );

        if (tokensResponse.rows.isEmpty) {
          AppLogger.warning(
            'No active FCM tokens found for user $userId. Skipping push.',
            tag: 'CROSS_DEVICE',
          );
          continue;
        }

        // 2. Prepare data payload
        final notificationData = <String, dynamic>{
          'type': type.jsonValue,
          'user_id': userId,
        };

        if (relatedEntityId != null) {
          notificationData['related_entity_id'] = relatedEntityId;
        }
        if (relatedEntityType != null) {
          notificationData['related_entity_type'] = relatedEntityType;
        }
        if (actorName != null) notificationData['actor_name'] = actorName;
        if (data != null) notificationData.addAll(data);

        // 3. Create a pending record for EACH token
        for (final row in tokensResponse.rows) {
          final fcmToken = row.data['token'] as String;

          // Skip if this is the current device we want to exclude
          if (excludeCurrentDevice != null &&
              fcmToken == excludeCurrentDevice) {
            AppLogger.debug(
              'Skipping current device token: ${fcmToken.substring(0, 10)}...',
              tag: 'CROSS_DEVICE',
            );
            continue;
          }

          try {
            await _databases.createRow(
              databaseId: AppwriteOptions.databaseId,
              tableId: AppwriteOptions.pendingPushNotificationsCollection,
              rowId: ID.unique(),
              data: {
                'user_id': userId,
                'fcm_token': fcmToken,
                'title': title,
                'body': body,
                'data': jsonEncode(notificationData),
                'type': type.jsonValue,
                'status': 'pending',
                'created_at': DateTime.now().toIso8601String(),
              },
            );
            AppLogger.success(
              'Queued for user $userId (Token: ${fcmToken.substring(0, 10)}...)',
              tag: 'CROSS_DEVICE',
            );
          } catch (e, stackTrace) {
            AppLogger.error(
              'Failed to queue specific token',
              tag: 'CROSS_DEVICE',
              error: e,
              stackTrace: stackTrace,
            );
          }
        }
      } catch (e, stackTrace) {
        AppLogger.error(
          'Error processing user $userId',
          tag: 'CROSS_DEVICE',
          error: e,
          stackTrace: stackTrace,
        );
        // Continue with other users
      }
    }
  }

  /// Send push notification to users with specific roles
  Future<void> sendPushNotificationToRoles({
    required List<String> roles,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
    String? excludeUserId,
    String? excludeCurrentDevice,
  }) async {
    try {
      AppLogger.notification(
        'Queuing role-based push notifications: $roles',
        tag: 'CROSS_DEVICE',
      );

      // Get users by roles from the database
      final allUsers = <String>[];

      for (final role in roles) {
        try {
          final usersResponse = await _databases.listRows(
            databaseId: AppwriteOptions.databaseId,
            tableId: AppwriteOptions.userProfilesCollection,
            queries: [
              Query.equal('role', role),
              Query.equal('is_active', true),
            ],
          );

          final roleUserIds = usersResponse.rows.map((row) => row.$id).toList();
          allUsers.addAll(roleUserIds);
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to fetch users for role $role',
            tag: 'CROSS_DEVICE',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }

      // Remove duplicates and excluded user
      final uniqueUsers = allUsers.toSet().toList();
      if (excludeUserId != null) {
        uniqueUsers.remove(excludeUserId);
      }

      AppLogger.info(
        'Found ${uniqueUsers.length} users for roles: ${roles.join(', ')}',
        tag: 'CROSS_DEVICE',
      );

      if (uniqueUsers.isNotEmpty) {
        await sendPushNotificationToUsers(
          userIds: uniqueUsers,
          title: title,
          body: body,
          type: type,
          relatedEntityId: relatedEntityId,
          relatedEntityType: relatedEntityType,
          actorName: actorName,
          data: data,
          excludeCurrentDevice: excludeCurrentDevice,
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to send role-based notifications',
        tag: 'CROSS_DEVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Test cross-device push notification
  Future<void> testCrossDevicePush({
    required String currentUserId,
    required String currentDeviceToken,
  }) async {
    try {
      AppLogger.info(
        'Testing cross-device push notifications',
        tag: 'CROSS_DEVICE',
      );

      // Create a test pending notification - simpler than listing all users
      // This tests the pipeline itself
      await _queueNotificationsForProcessing(
        userIds: [currentUserId], // Send to self for testing pipeline
        title: 'Test Pipeline Notification',
        body: 'If you receive this, the DB-to-Function pipeline is working!',
        type: NotificationType.system,
        data: {'test': 'pipeline_verification'},
        excludeCurrentDevice: null,
      );

      AppLogger.success('Test notification queued', tag: 'CROSS_DEVICE');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Test failed',
        tag: 'CROSS_DEVICE',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
