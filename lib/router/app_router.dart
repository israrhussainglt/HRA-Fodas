import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../ui/screens/auth/login_screen.dart';
import '../ui/screens/auth/register_screen.dart';
import '../ui/screens/auth/email_verification_screen.dart';
import '../ui/screens/auth/resend_verification_screen.dart';
import '../ui/screens/setup/first_admin_setup_screen.dart';
import '../ui/screens/home/home_screen.dart';
import '../ui/screens/donor/create_donation_screen.dart';
import '../ui/screens/donor/edit_donation_screen.dart';
import '../ui/screens/donation/donation_detail_screen.dart';
import '../ui/screens/profile/profile_screen.dart';
import '../ui/screens/profile/edit_profile_screen.dart';
import '../ui/screens/profile/settings_screen.dart';
import '../ui/screens/profile/help_support_screen.dart';
import '../ui/screens/profile/about_screen.dart';
import '../ui/screens/settings/llm_settings_screen.dart';
import '../ui/screens/notifications/notifications_screen.dart';
import '../ui/screens/recipient/inventory_screen.dart';
import '../ui/screens/chat/conversations_screen.dart';
import '../ui/screens/chat/chat_screen.dart';
import '../ui/screens/feedback/feedback_screen.dart';
import '../ui/screens/admin/analytics_dashboard.dart';
import '../ui/screens/admin/ngo_requests_screen.dart';

/// Notifier for GoRouter refresh based on auth state changes
class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(this._ref) {
    // Watch the auth state provider and notify listeners when it changes
    _ref.listen(currentUserProvider, (previous, next) {
      notifyListeners();
    });

    // Watch the admin status provider and notify listeners when it changes
    _ref.listen(hasAdminUserProvider, (previous, next) {
      notifyListeners();
    });
  }

  final Ref _ref;
}

final _refreshListenableProvider = Provider<GoRouterRefreshNotifier>((ref) {
  return GoRouterRefreshNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(_refreshListenableProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshListenable,
    redirect: (context, state) async {
      // First, check if admin setup is needed
      final hasAdminAsync = ref.read(hasAdminUserProvider);

      // Wait for the check to complete
      if (hasAdminAsync.isLoading) {
        return null; // Don't redirect while checking
      }

      final hasAdmin = hasAdminAsync.value ?? true; // Default to true on error

      // If no admin exists and not already on setup, redirect to setup
      if (!hasAdmin && state.matchedLocation != '/setup') {
        return '/setup';
      }

      // If admin exists and trying to access setup, redirect to login
      if (hasAdmin && state.matchedLocation == '/setup') {
        return '/login';
      }

      // Properly await the current user
      final userAsync = ref.read(currentUserProvider);

      // Handle loading state - allow navigation while loading
      if (userAsync.isLoading) {
        return null; // Don't redirect while loading
      }

      final user = userAsync.value;
      final isLoggedIn = user != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute && state.matchedLocation != '/setup') {
        return '/login';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/setup',
        builder: (context, state) => const FirstAdminSetupScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/resend-verification',
        builder: (context, state) => const ResendVerificationScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) {
          final userId = state.uri.queryParameters['userId'];
          final secret = state.uri.queryParameters['secret'];

          if (userId == null || secret == null) {
            return const LoginScreen();
          }

          return EmailVerificationScreen(userId: userId, secret: secret);
        },
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/donation/create',
        builder: (context, state) => const CreateDonationScreen(),
      ),
      GoRoute(
        path: '/donation/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null) return const LoginScreen();
          return DonationDetailScreen(donationId: id);
        },
      ),
      GoRoute(
        path: '/donations/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null) return const LoginScreen();
          return DonationDetailScreen(donationId: id);
        },
      ),
      GoRoute(
        path: '/donation/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null) return const LoginScreen();
          return EditDonationScreen(donationId: id);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/llm',
        builder: (context, state) => const LLMSettingsScreen(),
      ),
      GoRoute(
        path: '/help',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: '/conversations',
        builder: (context, state) => const ConversationsScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null) return const LoginScreen();
          return ChatScreen(conversationId: id);
        },
      ),
      GoRoute(
        path: '/feedback/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId'];
          if (userId == null) return const LoginScreen();
          return FeedbackScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsDashboard(),
      ),
      GoRoute(
        path: '/admin/ngo-requests',
        builder: (context, state) => const NGORequestsScreen(),
      ),
    ],
  );
});
