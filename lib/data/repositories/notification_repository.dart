import 'dart:convert';
import 'dart:async';
import 'package:appwrite/appwrite.dart';
import '../models/notification_model.dart';
import '../../appwrite_options.dart';
import '../../core/utils/logger.dart';

class NotificationRepository {
  final TablesDB _databases; // Changed from _databases to _databases
  final Realtime _realtime;

  NotificationRepository(this._databases, this._realtime);

  // ============================================
  // FCM TOKEN MANAGEMENT
  // ============================================

  /// Save or update FCM token
  Future<void> saveFCMToken({
    required String userId,
    required String token,
    required String deviceType,
    Map<String, dynamic>? deviceInfo,
  }) async {
    try {
      // Try to find existing token
      final existing = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.fcmTokensCollection,
        queries: [Query.equal('token', token)],
      );

      if (existing.rows.isNotEmpty) {
        // Update existing
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.fcmTokensCollection,
          rowId: existing.rows.first.$id,
          data: {
            'user_id': userId,
            'device_type': deviceType,
            'device_info': deviceInfo != null ? jsonEncode(deviceInfo) : null,
            'is_active': true,
            'last_used_at': DateTime.now().toIso8601String(),
          },
        );
      } else {
        // Create new
        await _databases.createRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.fcmTokensCollection,
          rowId: ID.unique(),
          data: {
            'user_id': userId,
            'token': token,
            'device_type': deviceType,
            'device_info': deviceInfo != null ? jsonEncode(deviceInfo) : null,
            'is_active': true,
            'last_used_at': DateTime.now().toIso8601String(),
          },
          permissions: [
            Permission.read(Role.user(userId)),
            Permission.update(Role.user(userId)),
            Permission.delete(Role.user(userId)),
          ],
        );
      }
    } catch (e) {
      throw Exception('Failed to save FCM token: $e');
    }
  }

  /// Get user's FCM tokens
  Future<List<FCMToken>> getUserFCMTokens(String userId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.fcmTokensCollection,
        queries: [
          Query.equal('user_id', userId),
          Query.equal('is_active', true),
        ],
      );

      return response.rows.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        return FCMToken.fromJson({...data, 'id': doc.$id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to get FCM tokens: $e');
    }
  }

  /// Deactivate FCM token
  Future<void> deactivateFCMToken(String token) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.fcmTokensCollection,
        queries: [Query.equal('token', token)],
      );

      if (response.rows.isNotEmpty) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.fcmTokensCollection,
          rowId: response.rows.first.$id,
          data: {'is_active': false},
        );
      }
    } catch (e) {
      throw Exception('Failed to deactivate FCM token: $e');
    }
  }

  /// Delete FCM token
  Future<void> deleteFCMToken(String token) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.fcmTokensCollection,
        queries: [Query.equal('token', token)],
      );

      if (response.rows.isNotEmpty) {
        await _databases.deleteRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.fcmTokensCollection,
          rowId: response.rows.first.$id,
        );
      }
    } catch (e) {
      throw Exception('Failed to delete FCM token: $e');
    }
  }

  // ============================================
  // NOTIFICATION PREFERENCES
  // ============================================

  /// Get user's notification preferences
  Future<NotificationPreferences?> getNotificationPreferences(
    String userId,
  ) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationPreferencesCollection,
        queries: [Query.equal('user_id', userId)],
      );

      if (response.rows.isEmpty) return null;
      return NotificationPreferences.fromJson({
        ...response.rows.first.data,
        'id': response.rows.first.$id,
      });
    } catch (e) {
      throw Exception('Failed to get notification preferences: $e');
    }
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences({
    required String userId,
    bool? newDonationAlerts,
    bool? pickupReminders,
    bool? statusUpdates,
    bool? chatMessages,
    bool? allNotificationsEnabled,
  }) async {
    try {
      final updates = <String, dynamic>{
        'user_id': userId,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (newDonationAlerts != null) {
        updates['new_donation_alerts'] = newDonationAlerts;
      }
      if (pickupReminders != null) {
        updates['pickup_reminders'] = pickupReminders;
      }
      if (statusUpdates != null) updates['status_updates'] = statusUpdates;
      if (chatMessages != null) updates['chat_messages'] = chatMessages;
      if (allNotificationsEnabled != null) {
        updates['all_notifications_enabled'] = allNotificationsEnabled;
      }

      // Check if preferences exist
      final existing = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationPreferencesCollection,
        queries: [Query.equal('user_id', userId)],
      );

      if (existing.rows.isNotEmpty) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.notificationPreferencesCollection,
          rowId: existing.rows.first.$id,
          data: updates,
        );
      } else {
        await _databases.createRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.notificationPreferencesCollection,
          rowId: ID.unique(),
          data: updates,
          permissions: [
            Permission.read(Role.user(userId)),
            Permission.update(Role.user(userId)),
            Permission.delete(Role.user(userId)),
          ],
        );
      }
    } catch (e) {
      throw Exception('Failed to update notification preferences: $e');
    }
  }

  // ============================================
  // NOTIFICATIONS HISTORY
  // ============================================

  /// Get user's notifications with filtering
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    int limit = 50,
    int offset = 0,
    bool? isRead,
    NotificationType? type,
    String? category,
  }) async {
    try {
      final queries = [
        Query.equal('user_id', userId),
        Query.orderDesc('\$createdAt'),
        Query.limit(limit),
        Query.offset(offset),
      ];

      if (isRead != null) {
        queries.add(Query.equal('is_read', isRead));
      }

      if (type != null) {
        queries.add(Query.equal('type', type.jsonValue));
      }

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationsCollection,
        queries: queries,
      );

      var notifications = <NotificationModel>[];

      for (final doc in response.rows) {
        try {
          final data = Map<String, dynamic>.from(doc.data);

          // Add the document ID
          data['id'] = doc.$id;

          // Add created_at from $createdAt if not present
          if (!data.containsKey('created_at')) {
            data['created_at'] = doc.$createdAt;
          }

          // Schema now has these fields, but ensure they're null if not present
          if (!data.containsKey('related_entity_id')) {
            data['related_entity_id'] = null;
          }
          if (!data.containsKey('related_entity_type')) {
            data['related_entity_type'] = null;
          }
          if (!data.containsKey('actor_name')) {
            data['actor_name'] = null;
          }

          final notification = NotificationModel.fromJson(data);
          notifications.add(notification);
        } catch (e, stackTrace) {
          AppLogger.error(
            'Failed to parse notification: ${doc.$id}',
            tag: 'NOTIFICATION',
            error: e,
            stackTrace: stackTrace,
          );
          AppLogger.error('Raw data: ${doc.data}', tag: 'NOTIFICATION');
          // Skip this notification and continue with others
          continue;
        }
      }

      // Filter by category if specified (client-side filtering since Appwrite doesn't support computed fields)
      if (category != null) {
        notifications = notifications
            .where((n) => n.type.category == category)
            .toList();
      }

      return notifications;
    } catch (e) {
      AppLogger.error(
        'Failed to get notifications',
        tag: 'NOTIFICATION',
        error: e,
      );
      throw Exception('Failed to get notifications: $e');
    }
  }

  /// Get available notification categories for a user
  Future<List<String>> getNotificationCategories(String userId) async {
    try {
      final notifications = await getNotifications(userId: userId, limit: 1000);
      final categories = notifications
          .map((n) => n.type.category)
          .toSet()
          .toList();
      categories.sort();
      return categories;
    } catch (e) {
      throw Exception('Failed to get notification categories: $e');
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationsCollection,
        queries: [
          Query.equal('user_id', userId),
          Query.equal('is_read', false),
        ],
      );
      return response.total;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationsCollection,
        rowId: notificationId,
        data: {'is_read': true},
      );
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      final unreadNotifications = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationsCollection,
        queries: [
          Query.equal('user_id', userId),
          Query.equal('is_read', false),
        ],
      );

      for (final doc in unreadNotifications.rows) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.notificationsCollection,
          rowId: doc.$id,
          data: {'is_read': true},
        );
      }
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _databases.deleteRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationsCollection,
        rowId: notificationId,
      );
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Delete all notifications for a user
  Future<void> deleteAllNotifications(String userId) async {
    try {
      final notifications = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationsCollection,
        queries: [Query.equal('user_id', userId)],
      );

      for (final doc in notifications.rows) {
        await _databases.deleteRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.notificationsCollection,
          rowId: doc.$id,
        );
      }
    } catch (e) {
      throw Exception('Failed to delete all notifications: $e');
    }
  }

  /// Create notification
  /// After running the schema migration, this will work for cross-user notifications
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Include all fields that exist in the updated database schema
      final notificationData = <String, dynamic>{
        'user_id': userId,
        'title': title,
        'message': body,
        'type': type.jsonValue,
        'is_read': false,
      };

      // Add optional fields if provided
      if (relatedEntityId != null) {
        notificationData['related_entity_id'] = relatedEntityId;
      }
      if (relatedEntityType != null) {
        notificationData['related_entity_type'] = relatedEntityType;
      }
      if (actorName != null) {
        notificationData['actor_name'] = actorName;
      }

      // Create notification (collection permissions now allow cross-user creation)
      await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.notificationsCollection,
        rowId: ID.unique(),
        data: notificationData,
      );
    } catch (e) {
      AppLogger.error(
        'Failed to create notification',
        tag: 'NOTIFICATION',
        error: e,
      );
      // Don't throw - notification failures shouldn't block main operations
    }
  }

  /// Watch notifications (real-time)
  Stream<List<NotificationModel>> watchNotifications(String userId) {
    final controller = StreamController<List<NotificationModel>>();

    // 1. Initial fetch
    getNotifications(userId: userId)
        .then((list) {
          if (!controller.isClosed) controller.add(list);
        })
        .catchError((e) {
          if (!controller.isClosed) controller.addError(e);
        });

    // 2. Subscribe to Realtime events
    final subscription = _realtime.subscribe([
      'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.notificationsCollection}.documents',
    ]);

    final sub = subscription.stream.listen((event) async {
      // Refresh list on any change to the notifications collection
      // We could filter more strictly by event.payload['user_id'] if available on all events
      // For now, simpler is safer: refresh if something changed.
      try {
        // Optional: Check if the event is relevant to this user to avoid unnecessary fetches
        // but payloads differ by event type (create vs delete), so careful parsing is needed.
        // For robust updates:
        final notifications = await getNotifications(userId: userId);
        if (!controller.isClosed) controller.add(notifications);
      } catch (e) {
        // Silent fail - continue watching
      }
    });

    controller.onCancel = () {
      sub.cancel();
      controller.close();
    };

    return controller.stream;
  }

  /// Watch unread count (real-time)
  Stream<int> watchUnreadCount(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    // For now, return empty stream - implement in UI layer
    return Stream.value(0);
  }
}
