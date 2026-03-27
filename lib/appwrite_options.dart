/// Appwrite configuration for HRA-FoDAS
///
/// This file contains the Appwrite project configuration.
/// All sensitive values are loaded from .env file for security.
library;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteOptions {
  // Appwrite Project Configuration - loaded from .env file
  static String get endpoint =>
      dotenv.env['APPWRITE_ENDPOINT'] ?? 'https://nyc.cloud.appwrite.io/v1';
  static String get projectId => dotenv.env['APPWRITE_PROJECT_ID'] ?? '';
  static String get databaseId => dotenv.env['APPWRITE_DATABASE_ID'] ?? '';

  // Collection IDs (matching your database schema)
  static const String userProfilesCollection = 'user_profiles';
  static const String donationsCollection = 'donations';
  static const String volunteerProfilesCollection = 'volunteer_profiles';
  static const String recipientOrganizationsCollection =
      'recipient_organizations';
  static const String deliveriesCollection = 'deliveries';
  static const String deliveryLogsCollection = 'delivery_logs';
  static const String notificationsCollection = 'notifications';
  static const String chatMessagesCollection = 'chat_messages';
  static const String conversationsCollection = 'conversations';
  static const String chatLogsCollection = 'chat_logs';
  static const String feedbackRatingsCollection = 'feedback_ratings';
  static const String ratingsCollection = 'ratings';
  static const String inventoryCollection = 'inventory';
  static const String inventoryV2Collection = 'inventory_v2';
  static const String fcmTokensCollection = 'fcm_tokens';
  static const String notificationPreferencesCollection =
      'notification_preferences';
  static const String scheduledNotificationsCollection =
      'scheduled_notifications';
  static const String pendingPushNotificationsCollection =
      'pending_push_notifications';
  static const String messagesCollection = 'messages';
  static const String feedbackCollection = 'feedback';
  static const String analyticsEventsCollection = 'analytics_events';
  static const String dailyStatisticsCollection = 'daily_statistics';
  static const String adminReportsCollection = 'admin_reports';
  static const String trustScoresCollection = 'trust_scores';
  static const String feedbackModerationCollection = 'feedback_moderation';
  static const String resourceUtilizationCollection = 'resource_utilization';
  static const String ngoRequestsCollection = 'ngo_requests';

  // Storage Bucket IDs
  static const String donationImagesBucket = 'donation_images';
  static const String deliveryPhotosBucket = 'delivery_photos';
  static const String profileAvatarsBucket = 'profile_avatars';
}
