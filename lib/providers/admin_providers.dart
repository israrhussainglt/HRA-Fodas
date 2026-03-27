import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/admin_repository.dart';
import '../data/repositories/ngo_request_repository.dart';
import '../data/models/admin_report.dart';
import '../data/models/trust_score.dart';
import '../data/models/feedback_rating.dart';
import '../data/models/ngo_request.dart';
import 'providers.dart';

// Admin repository provider
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(appwriteTablesDBProvider));
});

// NGO Request repository provider
final ngoRequestRepositoryProvider = Provider<NGORequestRepository>((ref) {
  return NGORequestRepository(
    ref.watch(appwriteTablesDBProvider),
    notificationRepository: ref.watch(notificationRepositoryProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});

// Reports providers
final adminReportsProvider =
    FutureProvider.family<List<AdminReport>, ReportType?>((ref, type) async {
      return ref.watch(adminRepositoryProvider).getReports(type: type);
    });

final allAdminReportsProvider = FutureProvider<List<AdminReport>>((ref) async {
  return ref.watch(adminRepositoryProvider).getReports();
});

// Food collection report provider
final foodCollectionReportProvider =
    FutureProvider.family<
      FoodCollectionReport,
      ({DateTime startDate, DateTime endDate})
    >((ref, params) async {
      return ref
          .watch(adminRepositoryProvider)
          .generateFoodCollectionReport(
            startDate: params.startDate,
            endDate: params.endDate,
          );
    });

// Distribution impact report provider
final distributionImpactReportProvider =
    FutureProvider.family<
      DistributionImpactReport,
      ({DateTime startDate, DateTime endDate})
    >((ref, params) async {
      return ref
          .watch(adminRepositoryProvider)
          .generateDistributionImpactReport(
            startDate: params.startDate,
            endDate: params.endDate,
          );
    });

// Volunteer activity report provider
final volunteerActivityReportProvider =
    FutureProvider.family<
      VolunteerActivityReport,
      ({DateTime startDate, DateTime endDate})
    >((ref, params) async {
      return ref
          .watch(adminRepositoryProvider)
          .generateVolunteerActivityReport(
            startDate: params.startDate,
            endDate: params.endDate,
          );
    });

// Trust score providers
final userTrustScoreProvider = FutureProvider.family<TrustScore?, String>((
  ref,
  userId,
) async {
  return ref.watch(adminRepositoryProvider).getTrustScore(userId);
});

// Pending feedback provider
final pendingFeedbackProvider = FutureProvider<List<FeedbackRating>>((
  ref,
) async {
  return ref.watch(adminRepositoryProvider).getPendingFeedback();
});

// All users provider
final allUsersProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>((
      ref,
      role,
    ) async {
      return ref.watch(adminRepositoryProvider).getAllUsers(role: role);
    });

// User statistics provider
final userStatisticsProvider = FutureProvider<Map<String, int>>((ref) async {
  // Get all users including admins for statistics
  final allUsersResponse = await ref
      .watch(adminRepositoryProvider)
      .getAllUsers();

  // Also get admin count separately since getAllUsers() excludes admins by default
  final adminResponse = await ref
      .watch(adminRepositoryProvider)
      .getAllUsers(role: 'admin');

  final stats = <String, int>{
    'total': allUsersResponse.length + adminResponse.length,
    'donor': 0,
    'recipient': 0,
    'volunteer': 0,
    'admin': adminResponse.length,
  };

  for (final user in allUsersResponse) {
    final role = user['role'] as String?;
    if (role != null && stats.containsKey(role)) {
      stats[role] = (stats[role] ?? 0) + 1;
    }
  }

  return stats;
});

// ============ NGO Request Providers ============
final ngoRequestsProvider = FutureProvider<List<NGORequest>>((ref) async {
  return ref.watch(ngoRequestRepositoryProvider).getRequests();
});

final pendingNGORequestsProvider = FutureProvider<List<NGORequest>>((
  ref,
) async {
  return ref.watch(ngoRequestRepositoryProvider).getPendingRequests();
});

final ngoRequestProvider = FutureProvider.family<NGORequest, String>((
  ref,
  id,
) async {
  return ref.watch(ngoRequestRepositoryProvider).getRequestById(id);
});

// Check if user has pending request for a specific donation
final hasPendingRequestForDonationProvider =
    FutureProvider.family<bool, ({String userId, String donationId})>((
      ref,
      params,
    ) async {
      try {
        final requests = await ref
            .watch(ngoRequestRepositoryProvider)
            .getRequests(
              ngoId: params.userId,
              status: NGORequestStatus.pending,
            );

        // Check if any request is for this specific donation
        return requests.any(
          (request) => request.donationId == params.donationId,
        );
      } catch (e) {
        return false;
      }
    });
