import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'services/appwrite_notification_service.dart';
import 'services/target_registration_service.dart';

// Global Appwrite client instance
late final Client appwriteClient;

/// Background message handler for FCM
/// This function must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Skip on web platform
  if (kIsWeb) return;

  // Initialize Firebase if not already initialized
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Firebase already initialized or failed
  }

  // Handle background FCM message silently

  // You can show local notifications here if needed
  // or store the message for when the app opens
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Firebase with platform-specific handling
  if (kIsWeb) {
    // Initialize Firebase for web with proper options
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      // Continue without Firebase on web
    }
  } else {
    // Initialize Firebase for mobile platforms
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Set up background message handler (mobile only)
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
    } catch (e) {
      // This is critical for mobile push notifications
      rethrow;
    }
  }

  // Get Appwrite configuration from environment
  final endpoint = AppConstants.appwriteEndpoint;
  final projectId = AppConstants.appwriteProjectId;

  appwriteClient = Client()
      .setEndpoint(endpoint)
      .setProject(projectId)
      .setSelfSigned(
        status: true,
      ); // Allow self-signed certificates in development

  // Suppress Appwrite SDK console logs in release mode
  if (kReleaseMode) {
    // In release mode, Appwrite logs are automatically suppressed
  }

  // Initialize Appwrite Notification Service and register FCM targets
  try {
    final account = Account(appwriteClient);
    await AppwriteNotificationService.instance.initialize(
      appwriteClient,
      account,
    );

    // Check if user is already logged in and register FCM target
    try {
      final user = await account.get();

      await TargetRegistrationService.instance.registerCurrentUserTarget(
        userId: user.$id,
        appwriteClient: appwriteClient,
        account: account,
      );
    } catch (e) {
      // No user logged in on startup
    }
  } catch (e) {
    // Continue app initialization even if notifications fail
  }

  runApp(const ProviderScope(child: FoodDonationApp()));
}

class FoodDonationApp extends ConsumerWidget {
  const FoodDonationApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
