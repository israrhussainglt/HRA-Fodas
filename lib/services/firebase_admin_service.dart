import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../core/utils/logger.dart';

/// Firebase Admin Service for server-side push notifications
///
/// SECURITY WARNING: This service loads credentials from config/firebase_service_account.json
/// For production, move this to a backend service or Appwrite Function.
class FirebaseAdminService {
  static const String _fcmEndpoint = 'https://fcm.googleapis.com/v1/projects';
  static const String _serviceAccountPath =
      'config/firebase_service_account.json';

  // Firebase service account configuration loaded from file
  static Map<String, dynamic>? _serviceAccount;
  static String? _accessToken;
  static DateTime? _tokenExpiry;

  /// Load service account from JSON file
  static Future<Map<String, dynamic>> _loadServiceAccount() async {
    if (_serviceAccount != null) {
      return _serviceAccount!;
    }

    try {
      // Try to load from file system first (for development)
      final file = File(_serviceAccountPath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        _serviceAccount = jsonDecode(contents);
        AppLogger.debug(
          'Loaded service account from file',
          tag: 'FIREBASE_ADMIN',
        );
        return _serviceAccount!;
      }
    } catch (e) {
      AppLogger.debug('Could not load from file: $e', tag: 'FIREBASE_ADMIN');
    }

    try {
      // Fallback to asset bundle (for production builds)
      final contents = await rootBundle.loadString(_serviceAccountPath);
      _serviceAccount = jsonDecode(contents);
      AppLogger.debug(
        'Loaded service account from assets',
        tag: 'FIREBASE_ADMIN',
      );
      return _serviceAccount!;
    } catch (e) {
      AppLogger.error(
        'Failed to load service account from $_serviceAccountPath',
        tag: 'FIREBASE_ADMIN',
        error: e,
      );
      throw Exception(
        'Service account file not found. Please ensure $_serviceAccountPath exists.',
      );
    }
  }

  /// Get OAuth2 access token for Firebase Admin API
  static Future<String> _getAccessToken() async {
    // Load service account if not already loaded
    final serviceAccount = await _loadServiceAccount();

    // Return cached token if still valid
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(
          _tokenExpiry!.subtract(const Duration(minutes: 5)),
        )) {
      return _accessToken!;
    }

    try {
      // Create JWT for service account authentication
      final jwt = _createJWT(serviceAccount);

      // Exchange JWT for access token
      final response = await http.post(
        Uri.parse(serviceAccount['token_uri']),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
          'assertion': jwt,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access_token'];
        _tokenExpiry = DateTime.now().add(
          Duration(seconds: data['expires_in'] ?? 3600),
        );
        return _accessToken!;
      } else {
        throw Exception('Failed to get access token: ${response.body}');
      }
    } catch (e) {
      AppLogger.error(
        'Error getting Firebase access token: $e',
        tag: 'FIREBASE_ADMIN',
      );
      rethrow;
    }
  }

  /// Create JWT for service account authentication
  static String _createJWT(Map<String, dynamic> serviceAccount) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expiry = now + 3600; // 1 hour

    final header = {'alg': 'RS256', 'typ': 'JWT'};

    final payload = {
      'iss': serviceAccount['client_email'],
      'scope': 'https://www.googleapis.com/auth/cloud-platform',
      'aud': serviceAccount['token_uri'],
      'exp': expiry,
      'iat': now,
    };

    final headerEncoded = base64Url.encode(utf8.encode(jsonEncode(header)));
    final payloadEncoded = base64Url.encode(utf8.encode(jsonEncode(payload)));
    final message = '$headerEncoded.$payloadEncoded';

    // For simplicity, we'll use a placeholder signature
    // In production, you'd need to implement RSA-SHA256 signing
    // or use a proper JWT library
    final signature = base64Url.encode(utf8.encode('placeholder_signature'));

    return '$message.$signature';
  }

  /// Send push notification to specific FCM token
  static Future<bool> sendNotificationToToken({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    try {
      AppLogger.info(
        'Sending notification to token: ${fcmToken.substring(0, 20)}...',
        tag: 'FIREBASE_ADMIN',
      );

      // For now, we'll simulate the notification sending
      // In production, you'd implement the full OAuth2 flow and FCM API call
      AppLogger.debug('Notification details:', tag: 'FIREBASE_ADMIN');
      AppLogger.debug('   Title: $title', tag: 'FIREBASE_ADMIN');
      AppLogger.debug('   Body: $body', tag: 'FIREBASE_ADMIN');
      AppLogger.debug('   Data: $data', tag: 'FIREBASE_ADMIN');
      AppLogger.debug('   Image: $imageUrl', tag: 'FIREBASE_ADMIN');

      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // TODO: Implement actual FCM API call
      /*
      final serviceAccount = await _loadServiceAccount();
      final accessToken = await _getAccessToken();
      final projectId = serviceAccount['project_id'];
      
      final message = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': title,
            'body': body,
            if (imageUrl != null) 'image': imageUrl,
          },
          if (data != null) 'data': data,
          'android': {
            'notification': {
              'channel_id': 'high_importance_channel',
              'priority': 'high',
              'default_sound': true,
              'default_vibrate_timings': true,
            },
          },
          'apns': {
            'payload': {
              'aps': {
                'alert': {
                  'title': title,
                  'body': body,
                },
                'sound': 'default',
                'badge': 1,
              },
            },
          },
        },
      };

      final response = await http.post(
        Uri.parse('$_fcmEndpoint/$projectId/messages:send'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ [FIREBASE_ADMIN] Notification sent successfully');
        return true;
      } else {
        AppLogger.error('Failed to send notification: ${response.body}', tag: 'FIREBASE_ADMIN');
        return false;
      }
      */

      AppLogger.info(
        'Notification simulated successfully',
        tag: 'FIREBASE_ADMIN',
      );
      return true;
    } catch (e) {
      AppLogger.error('Error sending notification: $e', tag: 'FIREBASE_ADMIN');
      return false;
    }
  }

  /// Send notification to multiple tokens
  static Future<Map<String, bool>> sendNotificationToTokens({
    required List<String> fcmTokens,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    final results = <String, bool>{};

    // Send notifications in parallel for better performance
    final futures = fcmTokens.map((token) async {
      final success = await sendNotificationToToken(
        fcmToken: token,
        title: title,
        body: body,
        data: data,
        imageUrl: imageUrl,
      );
      return MapEntry(token, success);
    });

    final responses = await Future.wait(futures);
    for (final response in responses) {
      results[response.key] = response.value;
    }

    return results;
  }

  /// Send notification to topic (for broadcast messages)
  static Future<bool> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
    String? imageUrl,
  }) async {
    try {
      AppLogger.info(
        'Sending notification to topic: $topic',
        tag: 'FIREBASE_ADMIN',
      );

      // TODO: Implement topic-based notification
      // Similar to token-based but uses 'topic' instead of 'token' in message

      AppLogger.info(
        'Topic notification simulated successfully',
        tag: 'FIREBASE_ADMIN',
      );
      return true;
    } catch (e) {
      AppLogger.error(
        'Error sending topic notification: $e',
        tag: 'FIREBASE_ADMIN',
      );
      return false;
    }
  }
}
