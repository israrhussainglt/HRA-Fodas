import 'package:appwrite/appwrite.dart';
import '../data/repositories/notification_repository.dart';
import '../data/models/notification_model.dart';
import 'appwrite_notification_service.dart';
import 'cross_device_notification_service.dart';

/// Enhanced notification service that combines local, database, and push notifications
///
/// This service provides a unified interface for all notification types:
/// 1. Local notifications (immediate UI feedback)
/// 2. Database notifications (persistent history)
/// 3. Cross-device push notifications (actual push notifications to other devices)
class EnhancedNotificationService {
  final NotificationRepository _notificationRepository;
  final AppwriteNotificationService _localNotificationService;
  final CrossDeviceNotificationService _crossDeviceService;
  final Client _appwriteClient;

  EnhancedNotificationService(
    this._notificationRepository,
    this._localNotificationService,
    this._appwriteClient,
  ) : _crossDeviceService = CrossDeviceNotificationService(_appwriteClient);

  /// Send comprehensive notification (local + database + cross-device push)
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    var localSuccess = false;
    var databaseSuccess = false;
    var pushSuccess = false;

    // 1. Send local notification (immediate UI feedback)
    try {
      // Generate a safe 32-bit integer ID
      final notificationId =
          (DateTime.now().millisecondsSinceEpoch % 2147483647).toInt();
      await _localNotificationService.showNotification(
        id: notificationId,
        title: title,
        body: body,
        data: {
          'user_id': userId,
          'type': type.jsonValue,
          'related_entity_id': relatedEntityId ?? '',
          'related_entity_type': relatedEntityType ?? '',
          ...?data,
        },
      );
      localSuccess = true;
    } catch (e) {
      // Ignore local notification errors
    }

    // 2. Save to database (persistent history)
    try {
      await _notificationRepository.createNotification(
        userId: userId,
        title: title,
        body: body,
        type: type,
        relatedEntityId: relatedEntityId,
        relatedEntityType: relatedEntityType,
        actorName: actorName,
        data: data,
      );
      databaseSuccess = true;
    } catch (e) {
      // Ignore database notification errors
    }

    // 3. Send cross-device push notification (actual push to other devices)
    try {
      // Get current device token to exclude it
      final currentDeviceToken = await _localNotificationService.getToken();

      await _crossDeviceService.sendPushNotificationToUsers(
        userIds: [userId],
        title: title,
        body: body,
        type: type,
        relatedEntityId: relatedEntityId,
        relatedEntityType: relatedEntityType,
        actorName: actorName,
        data: data,
        excludeCurrentDevice: currentDeviceToken,
      );

      pushSuccess = true;
    } catch (e) {
      // Ignore cross-device push errors
    }
  }

  /// Send notification to multiple users
  Future<void> sendNotificationToUsers({
    required List<String> userIds,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      // Get current device token to exclude it from cross-device notifications
      final currentDeviceToken = await _localNotificationService.getToken();

      // 1. Send cross-device push notifications first (only once for all users)
      await _crossDeviceService.sendPushNotificationToUsers(
        userIds: userIds,
        title: title,
        body: body,
        type: type,
        relatedEntityId: relatedEntityId,
        relatedEntityType: relatedEntityType,
        actorName: actorName,
        data: data,
        excludeCurrentDevice: currentDeviceToken,
      );

      // 2. Send individual local and database notifications (without cross-device push)
      final futures = userIds.map(
        (userId) => _sendLocalAndDatabaseNotification(
          userId: userId,
          title: title,
          body: body,
          type: type,
          relatedEntityId: relatedEntityId,
          relatedEntityType: relatedEntityType,
          actorName: actorName,
          data: data,
          imageUrl: imageUrl,
        ),
      );

      await Future.wait(futures);
    } catch (e) {
      // Ignore multi-user notification errors
    }
  }

  /// Send local and database notification only (no cross-device push)
  Future<void> _sendLocalAndDatabaseNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    // 1. Send local notification (immediate UI feedback)
    try {
      // Generate a safe 32-bit integer ID
      final notificationId =
          (DateTime.now().millisecondsSinceEpoch % 2147483647).toInt();
      await _localNotificationService.showNotification(
        id: notificationId,
        title: title,
        body: body,
        data: {
          'user_id': userId,
          'type': type.jsonValue,
          'related_entity_id': relatedEntityId ?? '',
          'related_entity_type': relatedEntityType ?? '',
          ...?data,
        },
      );
    } catch (e) {
      // Ignore local notification errors
    }

    // 2. Save to database (persistent history)
    try {
      await _notificationRepository.createNotification(
        userId: userId,
        title: title,
        body: body,
        type: type,
        relatedEntityId: relatedEntityId,
        relatedEntityType: relatedEntityType,
        actorName: actorName,
        data: data,
      );
    } catch (e) {
      // Ignore database notification errors
    }
  }

  /// Send notification based on user roles
  Future<void> sendNotificationToRoles({
    required List<String> roles, // ['volunteer', 'recipient', 'donor']
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? excludeUserId, // Don't send to this user (e.g., the actor)
  }) async {
    try {
      // Get current device token to exclude it from cross-device notifications
      final currentDeviceToken = await _localNotificationService.getToken();

      // Send cross-device push notifications to roles first
      await _crossDeviceService.sendPushNotificationToRoles(
        roles: roles,
        title: title,
        body: body,
        type: type,
        relatedEntityId: relatedEntityId,
        relatedEntityType: relatedEntityType,
        actorName: actorName,
        data: data,
        excludeUserId: excludeUserId,
        excludeCurrentDevice: currentDeviceToken,
      );

      // Get users by roles from database for local/database notifications
      final tablesDB = TablesDB(_appwriteClient);
      final allUsers = <String>[];

      for (final role in roles) {
        final usersResponse = await tablesDB.listRows(
          databaseId: 'hra_fodas_main',
          tableId: 'user_profiles',
          queries: [Query.equal('role', role), Query.equal('is_active', true)],
        );

        final roleUserIds = usersResponse.rows.map((doc) => doc.$id).toList();
        allUsers.addAll(roleUserIds);
      }

      // Remove duplicates and excluded user
      final uniqueUsers = allUsers.toSet().toList();
      if (excludeUserId != null) {
        uniqueUsers.remove(excludeUserId);
      }

      if (uniqueUsers.isNotEmpty) {
        // Send notifications without duplicate cross-device calls
        final futures = uniqueUsers.map(
          (userId) => _sendLocalAndDatabaseNotification(
            userId: userId,
            title: title,
            body: body,
            type: type,
            relatedEntityId: relatedEntityId,
            relatedEntityType: relatedEntityType,
            actorName: actorName,
            data: data,
            imageUrl: imageUrl,
          ),
        );

        await Future.wait(futures);
      }
    } catch (e) {
      // Ignore role-based notification errors
    }
  }

  /// Send broadcast notification to all users
  Future<void> sendBroadcastNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? relatedEntityId,
    String? relatedEntityType,
    String? actorName,
    Map<String, dynamic>? data,
    String? imageUrl,
  }) async {
    try {
      // Get all active users
      final tablesDB = TablesDB(_appwriteClient);
      final allUsersResponse = await tablesDB.listRows(
        databaseId: 'hra_fodas_main',
        tableId: 'user_profiles',
        queries: [Query.equal('is_active', true)],
      );

      final allUserIds = allUsersResponse.rows.map((doc) => doc.$id).toList();

      if (allUserIds.isNotEmpty) {
        await sendNotificationToUsers(
          userIds: allUserIds,
          title: title,
          body: body,
          type: type,
          relatedEntityId: relatedEntityId,
          relatedEntityType: relatedEntityType,
          actorName: actorName,
          data: data,
          imageUrl: imageUrl,
        );
      }
    } catch (e) {
      // Ignore broadcast notification errors
    }
  }

  /// Test notification system
  Future<void> testNotificationSystem(String userId) async {
    await sendNotification(
      userId: userId,
      title: 'Test Notification',
      body:
          'This is a test notification to verify the system is working correctly.',
      type: NotificationType.system,
      data: {'test': 'true'},
    );
  }

  /// Test cross-device push notifications
  Future<void> testCrossDeviceNotifications(String currentUserId) async {
    try {
      final currentDeviceToken = await _localNotificationService.getToken();

      await _crossDeviceService.testCrossDevicePush(
        currentUserId: currentUserId,
        currentDeviceToken: currentDeviceToken ?? '',
      );
    } catch (e) {
      // Ignore test errors
    }
  }
}
