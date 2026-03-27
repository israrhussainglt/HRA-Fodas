import 'package:equatable/equatable.dart';

class DashboardStats extends Equatable {
  final int totalDonations;
  final int pendingDonations;
  final int deliveredDonations;
  final int activeVolunteers;
  final int totalRecipients;
  final double totalFoodSaved; // in kg
  final int mealsProvided;
  final double co2Saved; // in kg

  const DashboardStats({
    this.totalDonations = 0,
    this.pendingDonations = 0,
    this.deliveredDonations = 0,
    this.activeVolunteers = 0,
    this.totalRecipients = 0,
    this.totalFoodSaved = 0,
    this.mealsProvided = 0,
    this.co2Saved = 0,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalDonations: json['total_donations'] as int? ?? 0,
      pendingDonations: json['pending_donations'] as int? ?? 0,
      deliveredDonations: json['delivered_donations'] as int? ?? 0,
      activeVolunteers: json['active_volunteers'] as int? ?? 0,
      totalRecipients: json['total_recipients'] as int? ?? 0,
      totalFoodSaved: (json['total_food_saved'] as num?)?.toDouble() ?? 0,
      mealsProvided: json['meals_provided'] as int? ?? 0,
      co2Saved: (json['co2_saved'] as num?)?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        totalDonations,
        pendingDonations,
        deliveredDonations,
        activeVolunteers,
        totalRecipients,
        totalFoodSaved,
        mealsProvided,
        co2Saved,
      ];
}

class TimeSeriesData extends Equatable {
  final DateTime date;
  final double value;
  final String? label;

  const TimeSeriesData({
    required this.date,
    required this.value,
    this.label,
  });

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) {
    return TimeSeriesData(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      label: json['label'] as String?,
    );
  }

  @override
  List<Object?> get props => [date, value, label];
}

class CategoryDistribution extends Equatable {
  final String category;
  final int count;
  final double percentage;

  const CategoryDistribution({
    required this.category,
    required this.count,
    required this.percentage,
  });

  factory CategoryDistribution.fromJson(Map<String, dynamic> json) {
    return CategoryDistribution(
      category: json['category'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [category, count, percentage];
}

class GeographicData extends Equatable {
  final double latitude;
  final double longitude;
  final int count;
  final String? areaName;

  const GeographicData({
    required this.latitude,
    required this.longitude,
    required this.count,
    this.areaName,
  });

  factory GeographicData.fromJson(Map<String, dynamic> json) {
    return GeographicData(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      count: json['count'] as int,
      areaName: json['area_name'] as String?,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, count, areaName];
}

class VolunteerPerformance extends Equatable {
  final String volunteerId;
  final String volunteerName;
  final int totalDeliveries;
  final int successfulDeliveries;
  final double averageRating;
  final double totalDistanceCovered; // in km
  final Duration averageDeliveryTime;

  const VolunteerPerformance({
    required this.volunteerId,
    required this.volunteerName,
    this.totalDeliveries = 0,
    this.successfulDeliveries = 0,
    this.averageRating = 0,
    this.totalDistanceCovered = 0,
    this.averageDeliveryTime = Duration.zero,
  });

  double get successRate =>
      totalDeliveries > 0 ? successfulDeliveries / totalDeliveries * 100 : 0;

  factory VolunteerPerformance.fromJson(Map<String, dynamic> json) {
    return VolunteerPerformance(
      volunteerId: json['volunteer_id'] as String,
      volunteerName: json['volunteer_name'] as String,
      totalDeliveries: json['total_deliveries'] as int? ?? 0,
      successfulDeliveries: json['successful_deliveries'] as int? ?? 0,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0,
      totalDistanceCovered:
          (json['total_distance_covered'] as num?)?.toDouble() ?? 0,
      averageDeliveryTime: Duration(
        minutes: json['average_delivery_time_minutes'] as int? ?? 0,
      ),
    );
  }

  @override
  List<Object?> get props => [
        volunteerId,
        volunteerName,
        totalDeliveries,
        successfulDeliveries,
        averageRating,
        totalDistanceCovered,
        averageDeliveryTime,
      ];
}
