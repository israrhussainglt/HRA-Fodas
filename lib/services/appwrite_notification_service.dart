import 'dart:async';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Appwrite-based notification service using Appwrite Messaging
/// Integrates with Appwrite's push notification capabilities (FCM/APNs)
///
/// Setup required:
/// 1. Configure push provider in Appwrite Console (FCM for Android, APNs for iOS)
/// 2. Add firebase_messaging dependency for FCM token generation
/// 3. Create messaging targets for users via Appwrite API
class AppwriteNotificationService {
  static final AppwriteNotificationService _instance =
      AppwriteNotificationService._internal();
  static AppwriteNotificationService get instance => _instance;

  AppwriteNotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  // Appwrite client and account for push token management
  Client? _client;
  Account? _account;

  // Push notification token (FCM for Android, APNs for iOS)
  String? _pushToken;
  String? get pushToken => _pushToken;

  // Target ID for Appwrite Messaging
  String? _targetId;
  String? get targetId => _targetId;

  bool _initialized = false;

  /// Initialize Appwrite Messaging and Local Notifications
  Future<void> initialize(Client client, Account account) async {
    if (_initialized) return;

    try {
      _client = client;
      _account = account;

      // Request permissions
      await requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get push token from platform (FCM/APNs)
      await _getPlatformPushToken();

      _initialized = true;
    } catch (e) {
      rethrow;
    }
  }

  /// Request notification permissions
  Future<bool> requestPermissions() async {
    try {
      // Skip permission requests on web platform
      if (kIsWeb) {
        return true;
      }

      if (Platform.isAndroid) {
        // Android 13+ requires runtime permission
        final androidImplementation = _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

        if (androidImplementation != null) {
          final granted = await androidImplementation
              .requestNotificationsPermission();
          return granted ?? false;
        }
        return true; // Older Android versions don't need runtime permission
      } else if (Platform.isIOS) {
        final iosImplementation = _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

        if (iosImplementation != null) {
          final granted = await iosImplementation.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          return granted ?? false;
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Initialize local notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    // Skip local notifications on web platform
    if (kIsWeb) {
      return;
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel with HIGH priority for popup/sound
    // Skip this on web platform
    try {
      if (Platform.isAndroid) {
        const channel = AndroidNotificationChannel(
          'high_importance_channel',
          'Food Donation Alerts',
          description: 'Notifications for new donations and updates',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          showBadge: true,
        );

        await _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(channel);
      }
    } catch (e) {
      // Platform operations not supported on web
    }
  }

  /// Get platform-specific push token (FCM for Android, APNs for iOS)
  Future<void> _getPlatformPushToken() async {
    try {
      // Skip Firebase messaging on web platform due to compatibility issues
      if (kIsWeb) {
        _pushToken = 'web_token_${DateTime.now().millisecondsSinceEpoch}';
        return;
      }

      // Get FCM token (handles both Android FCM and iOS APNs automatically)
      final messaging = FirebaseMessaging.instance;

      // Request permission for iOS
      if (Platform.isIOS) {
        final settings = await messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
        );

        if (settings.authorizationStatus != AuthorizationStatus.authorized) {
          return;
        }
      }

      // Get the token
      _pushToken = await messaging.getToken();

      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) {
        _pushToken = newToken;
        // TODO: Update token in Appwrite when it refreshes
      });

      // Set up foreground message handling
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Set up background message handling
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    } catch (e) {
      // Fallback to placeholder token
      _pushToken = 'fallback_token_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  /// Create or update Appwrite Messaging target for this device
  /// This registers the device to receive push notifications via Appwrite
  Future<String?> createMessagingTarget({
    required String userId,
    String? providerId,
    String? name,
  }) async {
    if (_pushToken == null) {
      return null;
    }

    if (_client == null || _account == null) {
      return null;
    }

    try {
      // Determine provider ID (defaults to constant from documentation)
      final actualProviderId = providerId ?? 'fcm_provider_main';
      final deviceName = name ?? '${Platform.operatingSystem} Device';

      // Save FCM token to database (legacy/fallback)
      await _saveFCMTokenToDatabase(userId);

      // Register device as a native Push Target in Appwrite
      try {
        final target = await _account!.createPushTarget(
          targetId: ID.unique(),
          identifier: _pushToken!,
          providerId: actualProviderId,
        );

        _targetId = target.$id;
        return _targetId;
      } on AppwriteException catch (ae) {
        if (ae.code == 409) {
          return 'already_exists';
        }
        return 'pending_target_creation';
      } catch (messagingError) {
        return 'pending_target_creation';
      }
    } catch (e) {
      return null;
    }
  }

  /// Fallback: Save FCM token to database for manual processing
  Future<void> _saveFCMTokenToDatabase(String userId) async {
    if (_pushToken == null || _client == null) return;

    try {
      final tablesDB = TablesDB(_client!);

      // Check if token already exists
      try {
        final existing = await tablesDB.listRows(
          databaseId: 'hra_fodas_main',
          tableId: 'fcm_tokens',
          queries: [Query.equal('token', _pushToken!)],
        );

        if (existing.rows.isNotEmpty) {
          // Update existing token
          await tablesDB.updateRow(
            databaseId: 'hra_fodas_main',
            tableId: 'fcm_tokens',
            rowId: existing.rows.first.$id,
            data: {
              'user_id': userId,
              'device_type': Platform.isIOS ? 'ios' : 'android',
              'is_active': true,
              'last_used_at': DateTime.now().toIso8601String(),
            },
          );
        } else {
          // Create new token record
          await tablesDB.createRow(
            databaseId: 'hra_fodas_main',
            tableId: 'fcm_tokens',
            rowId: ID.unique(),
            data: {
              'user_id': userId,
              'token': _pushToken!,
              'device_type': Platform.isIOS ? 'ios' : 'android',
              'is_active': true,
              'last_used_at': DateTime.now().toIso8601String(),
            },
          );
        }
      } catch (tableError) {
        // Ignore table errors - not critical for login
      }
    } catch (e) {
      // Don't rethrow - this should not block login
    }
  }

  /// Deactivate FCM token in database
  Future<void> _deactivateFCMTokenInDatabase(String userId) async {
    if (_pushToken == null || _client == null) return;

    try {
      final tablesDB = TablesDB(_client!);

      // Find and deactivate the token
      final existing = await tablesDB.listRows(
        databaseId: 'hra_fodas_main',
        tableId: 'fcm_tokens',
        queries: [
          Query.equal('user_id', userId),
          Query.equal('token', _pushToken!),
        ],
      );

      for (final row in existing.rows) {
        await tablesDB.updateRow(
          databaseId: 'hra_fodas_main',
          tableId: 'fcm_tokens',
          rowId: row.$id,
          data: {
            'is_active': false,
            'last_used_at': DateTime.now().toIso8601String(),
          },
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete Appwrite Messaging target for this device
  Future<void> deleteMessagingTarget({required String userId}) async {
    try {
      // For now, just mark FCM token as inactive in database
      // The actual target deletion will be handled by the backend/MCP tools
      await _deactivateFCMTokenInDatabase(userId);

      _targetId = null;
    } catch (e) {
      // Ignore errors
    }
  }

  /// Handle notification tap from local notifications
  void _onNotificationTapped(NotificationResponse response) {
    // Handle deep linking based on payload
    // You can parse the payload and navigate to specific screens
  }

  /// Show local notification (for foreground messages)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    // On web platform, just emit to stream (no local notifications)
    if (kIsWeb) {
      _messageStreamController.add({
        'title': title,
        'body': body,
        'data': data ?? {},
      });
      return;
    }

    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Food Donation Alerts',
          channelDescription: 'Notifications for new donations and updates',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
          fullScreenIntent: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: data?.toString(),
    );

    // Emit to stream for app to handle
    _messageStreamController.add({
      'title': title,
      'body': body,
      'data': data ?? {},
    });
  }

  /// Get push token (FCM/APNs)
  Future<String?> getToken() async {
    if (_pushToken == null) {
      await _getPlatformPushToken();
    }
    return _pushToken;
  }

  /// Refresh push token
  Future<String?> refreshToken() async {
    await _getPlatformPushToken();
    return _pushToken;
  }

  /// Cancel a notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation = _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        return await androidImplementation?.areNotificationsEnabled() ?? false;
      } else if (Platform.isIOS) {
        final iosImplementation = _localNotifications
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
        // iOS doesn't have a direct way to check, assume true if initialized
        return iosImplementation != null;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Handle foreground FCM messages
  void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification for foreground messages
    if (message.notification != null) {
      showNotification(
        id: message.hashCode,
        title: message.notification!.title ?? 'New Notification',
        body: message.notification!.body ?? '',
        data: message.data,
      );
    }
  }

  /// Handle FCM message when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    // Emit to stream for app to handle navigation
    _messageStreamController.add({
      'title': message.notification?.title ?? '',
      'body': message.notification?.body ?? '',
      'data': message.data,
      'opened_from_notification': true,
    });
  }

  /// Dispose resources
  void dispose() {
    _messageStreamController.close();
  }
}
