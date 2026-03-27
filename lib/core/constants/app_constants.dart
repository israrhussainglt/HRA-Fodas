import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import for web
import 'web_env_stub.dart' if (dart.library.html) 'web_env_web.dart' as web_env;

class AppConstants {
  // Helper to get environment variable from web or dotenv
  static String _getEnv(String key, String defaultValue) {
    if (kIsWeb) {
      // For web, try to get from window.ENV
      final value = web_env.getWebEnv(key);
      if (value != null) return value;
    }
    // For mobile/desktop, use dotenv
    return dotenv.env[key] ?? defaultValue;
  }

  // Appwrite Configuration - loaded from .env file or web env.js
  static String get appwriteEndpoint =>
      _getEnv('APPWRITE_ENDPOINT', 'https://nyc.cloud.appwrite.io/v1');

  static String get appwriteProjectId =>
      _getEnv('APPWRITE_PROJECT_ID', '698457ea003c1c483173');

  static String get appwriteDatabaseId =>
      _getEnv('APPWRITE_DATABASE_ID', 'hra_fodas_main');

  // FCM Provider ID for push notifications
  static String get fcmProviderId =>
      _getEnv('FCM_PROVIDER_ID', 'fcm_provider_main');

  // App Configuration
  static String get appName => _getEnv('APP_NAME', 'HRA-FoDAS');

  static String get appTagline =>
      _getEnv('APP_TAGLINE', 'Food Donation & Distribution Platform');

  // Storage keys
  static const String userRoleKey = 'user_role';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeKey = 'theme_mode';
}
