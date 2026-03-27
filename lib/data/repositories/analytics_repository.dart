import 'package:appwrite/appwrite.dart';
import '../models/analytics_data.dart';
import '../../appwrite_options.dart';

class AnalyticsRepository {
  final TablesDB _databases; // Changed from _databases to _databases

  AnalyticsRepository(this._databases);

  Future<DashboardStats> getDashboardStats() async {
    try {
      // Get total donations
      final donationsResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
      );
      final totalDonations = donationsResponse.total;

      // Get pending donations
      final pendingResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        queries: [Query.equal('status', 'pending')],
      );
      final pendingDonations = pendingResponse.total;

      // Get delivered donations
      final deliveredResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        queries: [Query.equal('status', 'delivered')],
      );
      final deliveredDonations = deliveredResponse.total;

      // Calculate total food saved (sum of delivered quantities)
      double totalFoodSaved = 0;
      for (final doc in deliveredResponse.rows) {
        totalFoodSaved += (doc.data['quantity'] as num?)?.toDouble() ?? 0;
      }

      // Get active volunteers
      final volunteersResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        queries: [
          Query.equal('role', 'volunteer'),
          Query.equal('is_active', true),
        ],
      );
      final activeVolunteers = volunteersResponse.total;

      // Get total recipients
      final recipientsResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.userProfilesCollection,
        queries: [Query.equal('role', 'recipient')],
      );
      final totalRecipients = recipientsResponse.total;

      // Estimate meals provided (assuming 0.5kg per meal)
      final mealsProvided = (totalFoodSaved / 0.5).round();

      // Estimate CO2 saved (approximately 2.5kg CO2 per kg of food saved)
      final co2Saved = totalFoodSaved * 2.5;

      return DashboardStats(
        totalDonations: totalDonations,
        pendingDonations: pendingDonations,
        deliveredDonations: deliveredDonations,
        activeVolunteers: activeVolunteers,
        totalRecipients: totalRecipients,
        totalFoodSaved: totalFoodSaved,
        mealsProvided: mealsProvided,
        co2Saved: co2Saved,
      );
    } catch (e) {
      return DashboardStats(
        totalDonations: 0,
        pendingDonations: 0,
        deliveredDonations: 0,
        activeVolunteers: 0,
        totalRecipients: 0,
        totalFoodSaved: 0,
        mealsProvided: 0,
        co2Saved: 0,
      );
    }
  }

  Future<List<TimeSeriesData>> getDonationTrend({
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
          Query.orderAsc('created_at'),
        ],
      );

      // Group by date
      final Map<String, int> countByDate = {};
      for (final doc in response.rows) {
        final date = DateTime.parse(doc.data['created_at'] as String);
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        countByDate[dateKey] = (countByDate[dateKey] ?? 0) + 1;
      }

      return countByDate.entries
          .map(
            (e) => TimeSeriesData(
              date: DateTime.parse(e.key),
              value: e.value.toDouble(),
            ),
          )
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoryDistribution>> getCategoryDistribution() async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
      );

      final Map<String, int> countByCategory = {};
      for (final doc in response.rows) {
        final category = doc.data['food_category'] as String? ?? 'other';
        countByCategory[category] = (countByCategory[category] ?? 0) + 1;
      }

      final total = countByCategory.values.fold(0, (a, b) => a + b);

      return countByCategory.entries
          .map(
            (e) => CategoryDistribution(
              category: e.key,
              count: e.value,
              percentage: total > 0 ? (e.value / total * 100) : 0,
            ),
          )
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));
    } catch (e) {
      return [];
    }
  }

  Future<List<GeographicData>> getDonationHeatmap() async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        queries: [Query.isNotNull('latitude'), Query.isNotNull('longitude')],
      );

      // Group by approximate location (rounded to 2 decimal places)
      final Map<String, GeographicData> locationCounts = {};
      for (final doc in response.rows) {
        final lat = (doc.data['latitude'] as num).toDouble();
        final lng = (doc.data['longitude'] as num).toDouble();
        final key = '${lat.toStringAsFixed(2)},${lng.toStringAsFixed(2)}';

        if (locationCounts.containsKey(key)) {
          final existing = locationCounts[key]!;
          locationCounts[key] = GeographicData(
            latitude: existing.latitude,
            longitude: existing.longitude,
            count: existing.count + 1,
          );
        } else {
          locationCounts[key] = GeographicData(
            latitude: lat,
            longitude: lng,
            count: 1,
          );
        }
      }

      return locationCounts.values.toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<VolunteerPerformance>> getTopVolunteers({int limit = 10}) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        queries: [Query.equal('status', 'delivered')],
      );

      // Count deliveries per volunteer
      final Map<String, int> deliveryCounts = {};
      for (final doc in response.rows) {
        final volunteerId = doc.data['volunteer_id'] as String;
        deliveryCounts[volunteerId] = (deliveryCounts[volunteerId] ?? 0) + 1;
      }

      // Get volunteer names
      final volunteerIds = deliveryCounts.keys.toList();
      if (volunteerIds.isEmpty) return [];

      final performances = <VolunteerPerformance>[];
      for (final volunteerId in volunteerIds) {
        try {
          final profile = await _databases.getRow(
            databaseId: AppwriteOptions.databaseId,
            tableId: AppwriteOptions.userProfilesCollection,
            rowId: volunteerId,
          );

          performances.add(
            VolunteerPerformance(
              volunteerId: volunteerId,
              volunteerName: profile.data['full_name'] as String? ?? 'Unknown',
              totalDeliveries: deliveryCounts[volunteerId]!,
              successfulDeliveries: deliveryCounts[volunteerId]!,
            ),
          );
        } catch (e) {
          // Skip if profile not found
          continue;
        }
      }

      performances.sort(
        (a, b) => b.totalDeliveries.compareTo(a.totalDeliveries),
      );
      return performances.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      // Get user's donations
      final donationsResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        queries: [Query.equal('donor_id', userId)],
      );

      final totalDonations = donationsResponse.total;
      int deliveredDonations = 0;
      double totalQuantity = 0;

      for (final doc in donationsResponse.rows) {
        if (doc.data['status'] == 'delivered') {
          deliveredDonations++;
          totalQuantity += (doc.data['quantity'] as num?)?.toDouble() ?? 0;
        }
      }

      // Get user's deliveries (if volunteer)
      final deliveriesResponse = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        queries: [Query.equal('volunteer_id', userId)],
      );

      final totalDeliveries = deliveriesResponse.total;
      int completedDeliveries = 0;

      for (final doc in deliveriesResponse.rows) {
        if (doc.data['status'] == 'delivered') {
          completedDeliveries++;
        }
      }

      return {
        'total_donations': totalDonations,
        'delivered_donations': deliveredDonations,
        'total_quantity_donated': totalQuantity,
        'total_deliveries': totalDeliveries,
        'completed_deliveries': completedDeliveries,
        'impact_meals': (totalQuantity / 0.5).round(),
        'impact_co2': totalQuantity * 2.5,
      };
    } catch (e) {
      return {
        'total_donations': 0,
        'delivered_donations': 0,
        'total_quantity_donated': 0.0,
        'total_deliveries': 0,
        'completed_deliveries': 0,
        'impact_meals': 0,
        'impact_co2': 0.0,
      };
    }
  }
}
