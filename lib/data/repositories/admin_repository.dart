import 'package:appwrite/appwrite.dart';
import '../models/admin_report.dart';
import '../models/trust_score.dart';
import '../models/feedback_rating.dart';
import '../../appwrite_options.dart';

class AdminRepository {
  final TablesDB _databases;

  AdminRepository(this._databases);

  // ============ Report Management ============

  Future<List<AdminReport>> getReports({ReportType? type}) async {
    try {
      final queries = <String>[Query.orderDesc('created_at')];
      if (type != null) {
        queries.add(Query.equal('report_type', type.name));
      }

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'admin_reports',
        queries: queries,
      );

      return response.rows.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['id'] = doc.$id;
        return AdminReport.fromJson(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<AdminReport?> createReport({
    required ReportType reportType,
    required String title,
    String? description,
    required String generatedBy,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'admin_reports',
        rowId: ID.unique(),
        data: {
          'report_type': reportType.name,
          'title': title,
          'description': description,
          'generated_by': generatedBy,
          'date_from': dateFrom?.toIso8601String(),
          'date_to': dateTo?.toIso8601String(),
          'status': 'pending',
        },
      );

      final data = Map<String, dynamic>.from(response.data);
      data['id'] = response.$id;
      return AdminReport.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateReportStatus(
    String reportId,
    ReportStatus status, {
    String? fileUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'admin_reports',
        rowId: reportId,
        data: {
          'status': status.name,
          if (fileUrl != null) 'file_url': fileUrl,
          if (data != null) 'data': data,
        },
      );
    } catch (e) {
      // Ignore errors
    }
  }

  // ============ Food Collection Reports ============

  Future<FoodCollectionReport> generateFoodCollectionReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        queries: [
          Query.greaterThanEqual('created_at', startDate.toIso8601String()),
          Query.lessThanEqual('created_at', endDate.toIso8601String()),
        ],
      );

      final totalDonations = response.total;
      double totalQuantity = 0;
      final categoryBreakdown = <String, int>{};
      final donorBreakdown = <String, int>{};

      for (final doc in response.rows) {
        totalQuantity += (doc.data['quantity'] as num?)?.toDouble() ?? 0;

        final category = doc.data['food_category'] as String? ?? 'other';
        categoryBreakdown[category] = (categoryBreakdown[category] ?? 0) + 1;

        final donorId = doc.data['donor_id'] as String;
        donorBreakdown[donorId] = (donorBreakdown[donorId] ?? 0) + 1;
      }

      // Generate daily trend
      final dailyTrend = <TimeSeriesData>[];
      final dayMap = <String, int>{};

      for (final doc in response.rows) {
        final date = DateTime.parse(doc.data['created_at'] as String);
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        dayMap[dateKey] = (dayMap[dateKey] ?? 0) + 1;
      }

      dayMap.forEach((key, value) {
        dailyTrend.add(
          TimeSeriesData(date: DateTime.parse(key), value: value.toDouble()),
        );
      });

      dailyTrend.sort((a, b) => a.date.compareTo(b.date));

      return FoodCollectionReport(
        totalDonations: totalDonations,
        totalQuantity: totalQuantity,
        categoryBreakdown: categoryBreakdown,
        donorBreakdown: donorBreakdown,
        dailyTrend: dailyTrend,
      );
    } catch (e) {
      return const FoodCollectionReport(
        totalDonations: 0,
        totalQuantity: 0,
        categoryBreakdown: {},
        donorBreakdown: {},
        dailyTrend: [],
      );
    }
  }

  // ============ Distribution Impact Reports ============

  Future<DistributionImpactReport> generateDistributionImpactReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        queries: [
          Query.greaterThanEqual('created_at', startDate.toIso8601String()),
          Query.lessThanEqual('created_at', endDate.toIso8601String()),
          Query.equal('status', 'delivered'),
        ],
      );

      final totalDeliveries = response.total;
      final recipientIds = <String>{};
      double foodSaved = 0;

      for (final doc in response.rows) {
        recipientIds.add(doc.data['recipient_id'] as String);
        foodSaved += (doc.data['quantity'] as num?)?.toDouble() ?? 0;
      }

      final mealsProvided = (foodSaved / 0.5).round();
      final co2Saved = foodSaved * 2.5;

      return DistributionImpactReport(
        totalDeliveries: totalDeliveries,
        recipientsServed: recipientIds.length,
        mealsProvided: mealsProvided,
        foodSaved: foodSaved,
        co2Saved: co2Saved,
        regionBreakdown: {},
        impactTrend: [],
      );
    } catch (e) {
      return const DistributionImpactReport(
        totalDeliveries: 0,
        recipientsServed: 0,
        mealsProvided: 0,
        foodSaved: 0,
        co2Saved: 0,
        regionBreakdown: {},
        impactTrend: [],
      );
    }
  }

  // ============ Volunteer Activity Reports ============

  Future<VolunteerActivityReport> generateVolunteerActivityReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final volunteersResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        queries: [Query.equal('role', 'volunteer')],
      );

      final deliveriesResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        queries: [
          Query.greaterThanEqual('created_at', startDate.toIso8601String()),
          Query.lessThanEqual('created_at', endDate.toIso8601String()),
        ],
      );

      final activeVolunteerIds = <String>{};
      final volunteerDeliveries = <String, int>{};

      for (final doc in deliveriesResponse.rows) {
        final volunteerId = doc.data['volunteer_id'] as String?;
        if (volunteerId != null) {
          activeVolunteerIds.add(volunteerId);
          volunteerDeliveries[volunteerId] =
              (volunteerDeliveries[volunteerId] ?? 0) + 1;
        }
      }

      return VolunteerActivityReport(
        totalVolunteers: volunteersResponse.total,
        activeVolunteers: activeVolunteerIds.length,
        totalDeliveries: deliveriesResponse.total,
        averageRating: 0,
        topPerformers: [],
        activityByRegion: {},
      );
    } catch (e) {
      return const VolunteerActivityReport(
        totalVolunteers: 0,
        activeVolunteers: 0,
        totalDeliveries: 0,
        averageRating: 0,
        topPerformers: [],
        activityByRegion: {},
      );
    }
  }

  // ============ Trust Score Management ============

  Future<TrustScore?> getTrustScore(String userId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'trust_scores',
        queries: [Query.equal('user_id', userId)],
      );

      if (response.rows.isEmpty) return null;

      final data = Map<String, dynamic>.from(response.rows.first.data);
      data['id'] = response.rows.first.$id;
      return TrustScore.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<TrustScore> calculateTrustScore(String userId) async {
    try {
      // Get user's feedback
      final feedbackResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        queries: [Query.equal('to_user_id', userId)],
      );

      int positiveFeedback = 0;
      int negativeFeedback = 0;

      for (final doc in feedbackResponse.rows) {
        final rating = doc.data['rating'] as int;
        if (rating >= 4) {
          positiveFeedback++;
        } else if (rating <= 2) {
          negativeFeedback++;
        }
      }

      // Get completed donations
      final donationsResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        queries: [
          Query.equal('donor_id', userId),
          Query.equal('status', 'delivered'),
        ],
      );

      // Get completed deliveries
      final deliveriesResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        queries: [
          Query.equal('volunteer_id', userId),
          Query.equal('status', 'delivered'),
        ],
      );

      // Calculate scores
      final totalInteractions =
          feedbackResponse.total +
          donationsResponse.total +
          deliveriesResponse.total;

      int trustScore = 50;
      if (totalInteractions > 0) {
        final positiveRate =
            positiveFeedback / (positiveFeedback + negativeFeedback + 1);
        trustScore = (positiveRate * 100).round();
      }

      int reliabilityScore = 50;
      if (totalInteractions > 0) {
        final completionRate =
            (donationsResponse.total + deliveriesResponse.total) /
            (totalInteractions + 1);
        reliabilityScore = (completionRate * 100).round();
      }

      // Save or update trust score
      final existing = await getTrustScore(userId);

      final data = {
        'user_id': userId,
        'trust_score': trustScore,
        'reliability_score': reliabilityScore,
        'total_interactions': totalInteractions,
        'positive_feedback_count': positiveFeedback,
        'negative_feedback_count': negativeFeedback,
        'completed_donations': donationsResponse.total,
        'completed_deliveries': deliveriesResponse.total,
        'cancelled_count': 0,
        'last_calculated': DateTime.now().toIso8601String(),
      };

      if (existing != null) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'trust_scores',
          rowId: existing.id,
          data: data,
        );
      } else {
        await _databases.createRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'trust_scores',
          rowId: ID.unique(),
          data: data,
        );
      }

      return TrustScore(
        id: existing?.id ?? '',
        userId: userId,
        trustScore: trustScore,
        reliabilityScore: reliabilityScore,
        totalInteractions: totalInteractions,
        positiveFeedbackCount: positiveFeedback,
        negativeFeedbackCount: negativeFeedback,
        completedDonations: donationsResponse.total,
        completedDeliveries: deliveriesResponse.total,
        cancelledCount: 0,
        lastCalculated: DateTime.now(),
      );
    } catch (e) {
      return TrustScore(id: '', userId: userId, lastCalculated: DateTime.now());
    }
  }

  // ============ Feedback Moderation ============

  Future<List<FeedbackRating>> getPendingFeedback() async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        queries: [Query.orderDesc('created_at')],
      );

      return response.rows.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['id'] = doc.$id;
        return FeedbackRating.fromJson(data);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> moderateFeedback({
    required String feedbackId,
    required String moderatedBy,
    required String action,
    String? reason,
    bool isFlagged = false,
    bool isApproved = true,
  }) async {
    try {
      await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'feedback_moderation',
        rowId: ID.unique(),
        data: {
          'feedback_id': feedbackId,
          'moderated_by': moderatedBy,
          'action': action,
          'reason': reason,
          'is_flagged': isFlagged,
          'is_approved': isApproved,
        },
      );
    } catch (e) {
      // Ignore errors
    }
  }

  // ============ User Management ============

  Future<List<Map<String, dynamic>>> getAllUsers({String? role}) async {
    try {
      final queries = <String>[];
      if (role != null) {
        queries.add(Query.equal('role', role));
      } else {
        // Exclude admins from the general user list
        queries.add(Query.notEqual('role', 'admin'));
      }

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        queries: queries,
      );

      return response.rows.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['id'] = doc.$id;
        return data;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateUserStatus(String userId, bool isActive) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        rowId: userId,
        data: {'is_active': isActive},
      );
    } catch (e) {
      // Ignore errors
    }
  }
}
