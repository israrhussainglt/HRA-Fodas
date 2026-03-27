import 'package:equatable/equatable.dart';

enum ReportType {
  foodCollection,
  distributionImpact,
  volunteerActivity,
  resourceUtilization,
  userFeedback,
  trustScores,
  custom,
}

enum ReportStatus { pending, generating, completed, failed }

enum ExportFormat { pdf, csv, json }

class AdminReport extends Equatable {
  final String id;
  final ReportType reportType;
  final String title;
  final String? description;
  final String generatedBy;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final Map<String, dynamic>? data;
  final String? fileUrl;
  final ReportStatus status;
  final DateTime createdAt;

  const AdminReport({
    required this.id,
    required this.reportType,
    required this.title,
    this.description,
    required this.generatedBy,
    this.dateFrom,
    this.dateTo,
    this.data,
    this.fileUrl,
    this.status = ReportStatus.pending,
    required this.createdAt,
  });

  factory AdminReport.fromJson(Map<String, dynamic> json) {
    return AdminReport(
      id: json['id'] as String,
      reportType: _parseReportType(json['report_type'] as String),
      title: json['title'] as String,
      description: json['description'] as String?,
      generatedBy: json['generated_by'] as String,
      dateFrom: json['date_from'] != null
          ? DateTime.parse(json['date_from'] as String)
          : null,
      dateTo: json['date_to'] != null
          ? DateTime.parse(json['date_to'] as String)
          : null,
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
      fileUrl: json['file_url'] as String?,
      status: _parseStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static ReportType _parseReportType(String value) {
    switch (value) {
      case 'food_collection':
        return ReportType.foodCollection;
      case 'distribution_impact':
        return ReportType.distributionImpact;
      case 'volunteer_activity':
        return ReportType.volunteerActivity;
      case 'resource_utilization':
        return ReportType.resourceUtilization;
      case 'user_feedback':
        return ReportType.userFeedback;
      case 'trust_scores':
        return ReportType.trustScores;
      default:
        return ReportType.custom;
    }
  }

  static ReportStatus _parseStatus(String? value) {
    switch (value) {
      case 'generating':
        return ReportStatus.generating;
      case 'completed':
        return ReportStatus.completed;
      case 'failed':
        return ReportStatus.failed;
      default:
        return ReportStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'report_type': reportType.name,
      'title': title,
      'description': description,
      'generated_by': generatedBy,
      'date_from': dateFrom?.toIso8601String(),
      'date_to': dateTo?.toIso8601String(),
      'data': data,
      'file_url': fileUrl,
      'status': status.name,
    };
  }

  @override
  List<Object?> get props => [
    id,
    reportType,
    title,
    description,
    generatedBy,
    dateFrom,
    dateTo,
    data,
    fileUrl,
    status,
    createdAt,
  ];
}

class FoodCollectionReport extends Equatable {
  final int totalDonations;
  final double totalQuantity;
  final Map<String, int> categoryBreakdown;
  final Map<String, int> donorBreakdown;
  final List<TimeSeriesData> dailyTrend;

  const FoodCollectionReport({
    required this.totalDonations,
    required this.totalQuantity,
    required this.categoryBreakdown,
    required this.donorBreakdown,
    required this.dailyTrend,
  });

  @override
  List<Object?> get props => [
    totalDonations,
    totalQuantity,
    categoryBreakdown,
    donorBreakdown,
    dailyTrend,
  ];
}

class DistributionImpactReport extends Equatable {
  final int totalDeliveries;
  final int recipientsServed;
  final int mealsProvided;
  final double foodSaved;
  final double co2Saved;
  final Map<String, int> regionBreakdown;
  final List<TimeSeriesData> impactTrend;

  const DistributionImpactReport({
    required this.totalDeliveries,
    required this.recipientsServed,
    required this.mealsProvided,
    required this.foodSaved,
    required this.co2Saved,
    required this.regionBreakdown,
    required this.impactTrend,
  });

  @override
  List<Object?> get props => [
    totalDeliveries,
    recipientsServed,
    mealsProvided,
    foodSaved,
    co2Saved,
    regionBreakdown,
    impactTrend,
  ];
}

class VolunteerActivityReport extends Equatable {
  final int totalVolunteers;
  final int activeVolunteers;
  final int totalDeliveries;
  final double averageRating;
  final List<VolunteerPerformance> topPerformers;
  final Map<String, int> activityByRegion;

  const VolunteerActivityReport({
    required this.totalVolunteers,
    required this.activeVolunteers,
    required this.totalDeliveries,
    required this.averageRating,
    required this.topPerformers,
    required this.activityByRegion,
  });

  @override
  List<Object?> get props => [
    totalVolunteers,
    activeVolunteers,
    totalDeliveries,
    averageRating,
    topPerformers,
    activityByRegion,
  ];
}

class TimeSeriesData extends Equatable {
  final DateTime date;
  final double value;
  final String? label;

  const TimeSeriesData({required this.date, required this.value, this.label});

  @override
  List<Object?> get props => [date, value, label];
}

class VolunteerPerformance extends Equatable {
  final String volunteerId;
  final String volunteerName;
  final int totalDeliveries;
  final double averageRating;

  const VolunteerPerformance({
    required this.volunteerId,
    required this.volunteerName,
    required this.totalDeliveries,
    required this.averageRating,
  });

  @override
  List<Object?> get props => [
    volunteerId,
    volunteerName,
    totalDeliveries,
    averageRating,
  ];
}
