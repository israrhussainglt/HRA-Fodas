import 'package:equatable/equatable.dart';

class TrustScore extends Equatable {
  final String id;
  final String userId;
  final int trustScore; // 0-100
  final int reliabilityScore; // 0-100
  final int totalInteractions;
  final int positiveFeedbackCount;
  final int negativeFeedbackCount;
  final int completedDonations;
  final int completedDeliveries;
  final int cancelledCount;
  final DateTime lastCalculated;

  const TrustScore({
    required this.id,
    required this.userId,
    this.trustScore = 50,
    this.reliabilityScore = 50,
    this.totalInteractions = 0,
    this.positiveFeedbackCount = 0,
    this.negativeFeedbackCount = 0,
    this.completedDonations = 0,
    this.completedDeliveries = 0,
    this.cancelledCount = 0,
    required this.lastCalculated,
  });

  factory TrustScore.fromJson(Map<String, dynamic> json) {
    return TrustScore(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      trustScore: json['trust_score'] as int? ?? 50,
      reliabilityScore: json['reliability_score'] as int? ?? 50,
      totalInteractions: json['total_interactions'] as int? ?? 0,
      positiveFeedbackCount: json['positive_feedback_count'] as int? ?? 0,
      negativeFeedbackCount: json['negative_feedback_count'] as int? ?? 0,
      completedDonations: json['completed_donations'] as int? ?? 0,
      completedDeliveries: json['completed_deliveries'] as int? ?? 0,
      cancelledCount: json['cancelled_count'] as int? ?? 0,
      lastCalculated: DateTime.parse(json['last_calculated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'trust_score': trustScore,
      'reliability_score': reliabilityScore,
      'total_interactions': totalInteractions,
      'positive_feedback_count': positiveFeedbackCount,
      'negative_feedback_count': negativeFeedbackCount,
      'completed_donations': completedDonations,
      'completed_deliveries': completedDeliveries,
      'cancelled_count': cancelledCount,
      'last_calculated': lastCalculated.toIso8601String(),
    };
  }

  String get trustLevel {
    if (trustScore >= 80) return 'Excellent';
    if (trustScore >= 60) return 'Good';
    if (trustScore >= 40) return 'Fair';
    return 'Poor';
  }

  String get reliabilityLevel {
    if (reliabilityScore >= 80) return 'Highly Reliable';
    if (reliabilityScore >= 60) return 'Reliable';
    if (reliabilityScore >= 40) return 'Moderately Reliable';
    return 'Unreliable';
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    trustScore,
    reliabilityScore,
    totalInteractions,
    positiveFeedbackCount,
    negativeFeedbackCount,
    completedDonations,
    completedDeliveries,
    cancelledCount,
    lastCalculated,
  ];
}

class FeedbackModeration extends Equatable {
  final String id;
  final String feedbackId;
  final String moderatedBy;
  final String action; // approved, rejected, flagged
  final String? reason;
  final bool isFlagged;
  final bool isApproved;
  final DateTime createdAt;

  const FeedbackModeration({
    required this.id,
    required this.feedbackId,
    required this.moderatedBy,
    required this.action,
    this.reason,
    this.isFlagged = false,
    this.isApproved = true,
    required this.createdAt,
  });

  factory FeedbackModeration.fromJson(Map<String, dynamic> json) {
    return FeedbackModeration(
      id: json['id'] as String,
      feedbackId: json['feedback_id'] as String,
      moderatedBy: json['moderated_by'] as String,
      action: json['action'] as String,
      reason: json['reason'] as String?,
      isFlagged: json['is_flagged'] as bool? ?? false,
      isApproved: json['is_approved'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_id': feedbackId,
      'moderated_by': moderatedBy,
      'action': action,
      'reason': reason,
      'is_flagged': isFlagged,
      'is_approved': isApproved,
    };
  }

  @override
  List<Object?> get props => [
    id,
    feedbackId,
    moderatedBy,
    action,
    reason,
    isFlagged,
    isApproved,
    createdAt,
  ];
}

class ResourceUtilization extends Equatable {
  final String id;
  final String resourceType; // food, volunteer, vehicle, storage
  final String? resourceId;
  final DateTime date;
  final int quantityAvailable;
  final int quantityUsed;
  final int utilizationRate; // percentage
  final int efficiencyScore; // 0-100
  final int wasteAmount;

  const ResourceUtilization({
    required this.id,
    required this.resourceType,
    this.resourceId,
    required this.date,
    this.quantityAvailable = 0,
    this.quantityUsed = 0,
    this.utilizationRate = 0,
    this.efficiencyScore = 0,
    this.wasteAmount = 0,
  });

  factory ResourceUtilization.fromJson(Map<String, dynamic> json) {
    return ResourceUtilization(
      id: json['id'] as String,
      resourceType: json['resource_type'] as String,
      resourceId: json['resource_id'] as String?,
      date: DateTime.parse(json['date'] as String),
      quantityAvailable: json['quantity_available'] as int? ?? 0,
      quantityUsed: json['quantity_used'] as int? ?? 0,
      utilizationRate: json['utilization_rate'] as int? ?? 0,
      efficiencyScore: json['efficiency_score'] as int? ?? 0,
      wasteAmount: json['waste_amount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resource_type': resourceType,
      'resource_id': resourceId,
      'date': date.toIso8601String(),
      'quantity_available': quantityAvailable,
      'quantity_used': quantityUsed,
      'utilization_rate': utilizationRate,
      'efficiency_score': efficiencyScore,
      'waste_amount': wasteAmount,
    };
  }

  @override
  List<Object?> get props => [
    id,
    resourceType,
    resourceId,
    date,
    quantityAvailable,
    quantityUsed,
    utilizationRate,
    efficiencyScore,
    wasteAmount,
  ];
}
