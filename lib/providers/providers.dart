import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../main.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/donation_repository.dart';
import '../data/repositories/delivery_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/inventory_repository.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/feedback_repository.dart';
import '../data/repositories/analytics_repository.dart';
import '../data/repositories/setup_repository.dart';
import '../services/enhanced_notification_service.dart';
import '../services/appwrite_notification_service.dart';
import '../data/models/user_profile.dart';
import '../data/models/donation.dart';
import '../data/models/delivery.dart';
import '../data/models/notification_model.dart';
import '../data/models/inventory_item.dart';
import '../data/models/chat_message.dart';
import '../data/models/feedback_rating.dart';
import '../data/models/analytics_data.dart';
import '../core/enums/enums.dart';

// Export admin providers
export 'admin_providers.dart';

// Appwrite client provider
final appwriteClientProvider = Provider<Client>((ref) {
  return appwriteClient;
});

// Appwrite services providers
final appwriteAccountProvider = Provider<Account>((ref) {
  return Account(ref.watch(appwriteClientProvider));
});

final appwriteTablesDBProvider = Provider<TablesDB>((ref) {
  return TablesDB(ref.watch(appwriteClientProvider));
});

// Alias for backward compatibility
final appwriteDatabasesProvider = appwriteTablesDBProvider;

final appwriteStorageProvider = Provider<Storage>((ref) {
  return Storage(ref.watch(appwriteClientProvider));
});

final appwriteRealtimeProvider = Provider<Realtime>((ref) {
  return Realtime(ref.watch(appwriteClientProvider));
});

// Repository providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(appwriteAccountProvider),
    ref.watch(appwriteTablesDBProvider),
    ref.watch(appwriteClientProvider),
  );
});

final donationRepositoryProvider = Provider<DonationRepository>((ref) {
  return DonationRepository(
    ref.watch(appwriteTablesDBProvider),
    authRepository: ref.watch(authRepositoryProvider),
    notificationRepository: ref.watch(notificationRepositoryProvider),
    enhancedNotificationService: ref.watch(enhancedNotificationServiceProvider),
  );
});

final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  return DeliveryRepository(ref.watch(appwriteTablesDBProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(
    ref.watch(appwriteTablesDBProvider),
    ref.watch(appwriteRealtimeProvider),
  );
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(
    ref.watch(appwriteTablesDBProvider),
    ref.watch(appwriteRealtimeProvider),
  );
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(
    ref.watch(appwriteTablesDBProvider),
    ref.watch(appwriteRealtimeProvider),
  );
});

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepository(ref.watch(appwriteTablesDBProvider));
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(appwriteTablesDBProvider));
});

final setupRepositoryProvider = Provider<SetupRepository>((ref) {
  return SetupRepository(
    ref.watch(appwriteTablesDBProvider),
    ref.watch(appwriteAccountProvider),
  );
});

// Enhanced notification service provider
final enhancedNotificationServiceProvider =
    Provider<EnhancedNotificationService>((ref) {
      return EnhancedNotificationService(
        ref.watch(notificationRepositoryProvider),
        AppwriteNotificationService.instance,
        ref.watch(appwriteClientProvider),
      );
    });

// Auth state provider - polls for current user
// Note: Appwrite doesn't have a built-in auth state stream like Supabase
// This provider will be invalidated when login/logout occurs
final authStateProvider = FutureProvider<models.User?>((ref) async {
  return ref.watch(authRepositoryProvider).currentUser;
});

// Current user provider - watches auth state to stay reactive
final currentUserProvider = FutureProvider<models.User?>((ref) async {
  // Watch auth state to trigger updates on login/logout
  return ref.watch(authStateProvider.future);
});

// User profile provider
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;
  return ref.watch(authRepositoryProvider).getUserProfile(user.$id);
});

// Donations list provider
final donationsProvider =
    FutureProvider.family<List<Donation>, DonationStatus?>((ref, status) async {
      return ref.watch(donationRepositoryProvider).getDonations(status: status);
    });

// Available donations provider (for volunteers/recipients)
final availableDonationsProvider = FutureProvider<List<Donation>>((ref) async {
  return ref.watch(donationRepositoryProvider).getAvailableDonations();
});

// My donations provider (for donors)
final myDonationsProvider = FutureProvider<List<Donation>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];
  return ref.watch(donationRepositoryProvider).getDonations(donorId: user.$id);
});

// Single donation provider
final donationProvider = FutureProvider.family<Donation, String>((
  ref,
  id,
) async {
  return ref.watch(donationRepositoryProvider).getDonationById(id);
});

// Deliveries list provider for volunteers
final myDeliveriesProvider = FutureProvider<List<Delivery>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];
  return ref
      .watch(deliveryRepositoryProvider)
      .getDeliveriesForVolunteer(user.$id);
});

// Deliveries list provider for recipients
final recipientDeliveriesProvider = FutureProvider<List<Delivery>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return [];
  return ref
      .watch(deliveryRepositoryProvider)
      .getDeliveriesForRecipient(user.$id);
});

// Single delivery provider
final deliveryProvider = FutureProvider.family<Delivery, String>((
  ref,
  id,
) async {
  return ref.watch(deliveryRepositoryProvider).getDeliveryById(id);
});

// ============ Notification Providers ============
final notificationsProvider =
    FutureProvider.family<List<NotificationModel>, String>((ref, userId) async {
      return ref
          .watch(notificationRepositoryProvider)
          .getNotifications(userId: userId);
    });

final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return 0;
  return ref.watch(notificationRepositoryProvider).getUnreadCount(user.$id);
});

// ============ Inventory Providers ============
final inventoryProvider = FutureProvider.family<List<InventoryItem>, String>((
  ref,
  recipientId,
) async {
  return ref.watch(inventoryRepositoryProvider).getInventory(recipientId);
});

final expiringItemsProvider =
    FutureProvider.family<List<InventoryItem>, String>((
      ref,
      recipientId,
    ) async {
      return ref
          .watch(inventoryRepositoryProvider)
          .getExpiringItems(recipientId);
    });

final lowStockItemsProvider =
    FutureProvider.family<List<InventoryItem>, String>((
      ref,
      recipientId,
    ) async {
      return ref
          .watch(inventoryRepositoryProvider)
          .getLowStockItems(recipientId);
    });

final inventorySummaryProvider =
    FutureProvider.family<Map<FoodCategory, double>, String>((
      ref,
      recipientId,
    ) async {
      return ref
          .watch(inventoryRepositoryProvider)
          .getInventorySummary(recipientId);
    });

// ============ Chat Providers ============
final conversationsProvider = StreamProvider.family<List<Conversation>, String>(
  (ref, userId) {
    return ref.watch(chatRepositoryProvider).watchConversations(userId);
  },
);

final messagesProvider = StreamProvider.family<List<ChatMessage>, String>((
  ref,
  conversationId,
) {
  return ref.watch(chatRepositoryProvider).watchMessages(conversationId);
});

final unreadChatCountProvider = FutureProvider<int>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return 0;
  return ref.watch(chatRepositoryProvider).getUnreadCount(user.$id);
});

// ============ Feedback Providers ============
final userRatingStatsProvider = FutureProvider.family<UserRatingStats, String>((
  ref,
  userId,
) async {
  return ref.watch(feedbackRepositoryProvider).getUserRatingStats(userId);
});

final feedbackForUserProvider =
    FutureProvider.family<List<FeedbackRating>, String>((ref, userId) async {
      return ref.watch(feedbackRepositoryProvider).getFeedbackForUser(userId);
    });

final feedbackForDonationProvider =
    FutureProvider.family<List<FeedbackRating>, String>((
      ref,
      donationId,
    ) async {
      return ref
          .watch(feedbackRepositoryProvider)
          .getFeedbackForDonation(donationId);
    });

// ============ Analytics Providers ============
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  return ref.watch(analyticsRepositoryProvider).getDashboardStats();
});

final categoryDistributionProvider = FutureProvider<List<CategoryDistribution>>(
  (ref) async {
    return ref.watch(analyticsRepositoryProvider).getCategoryDistribution();
  },
);

final topVolunteersProvider = FutureProvider<List<VolunteerPerformance>>((
  ref,
) async {
  return ref.watch(analyticsRepositoryProvider).getTopVolunteers();
});

final userStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((
  ref,
  userId,
) async {
  return ref.watch(analyticsRepositoryProvider).getUserStats(userId);
});

final donationTrendProvider =
    FutureProvider.family<
      List<TimeSeriesData>,
      ({DateTime start, DateTime end})
    >((ref, params) async {
      return ref
          .watch(analyticsRepositoryProvider)
          .getDonationTrend(startDate: params.start, endDate: params.end);
    });

// ============ Setup Providers ============
final hasAdminUserProvider = FutureProvider<bool>((ref) async {
  return ref.watch(setupRepositoryProvider).hasAdminUser();
});
