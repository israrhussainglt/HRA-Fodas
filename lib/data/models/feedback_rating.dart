import 'package:equatable/equatable.dart';

enum FeedbackType { donation, delivery, volunteer, donor, recipient }

class FeedbackRating extends Equatable {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String? donationId;
  final String? deliveryId;
  final FeedbackType type;
  final int rating; // 1-5
  final String? comment;
  final bool isAnonymous;
  final DateTime createdAt;

  const FeedbackRating({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    this.donationId,
    this.deliveryId,
    required this.type,
    required this.rating,
    this.comment,
    this.isAnonymous = false,
    required this.createdAt,
  });

  factory FeedbackRating.fromJson(Map<String, dynamic> json) {
    return FeedbackRating(
      id: json['id'] as String,
      fromUserId: json['from_user_id'] as String,
      toUserId: json['to_user_id'] as String,
      donationId: json['donation_id'] as String?,
      deliveryId: json['delivery_id'] as String?,
      type: _parseType(json['type'] as String),
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static FeedbackType _parseType(String value) {
    switch (value) {
      case 'donation':
        return FeedbackType.donation;
      case 'delivery':
        return FeedbackType.delivery;
      case 'volunteer':
        return FeedbackType.volunteer;
      case 'donor':
        return FeedbackType.donor;
      case 'recipient':
        return FeedbackType.recipient;
      default:
        return FeedbackType.donation;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'donation_id': donationId,
      'delivery_id': deliveryId,
      'type': type.name,
      'rating': rating,
      'comment': comment,
      'is_anonymous': isAnonymous,
    };
  }

  @override
  List<Object?> get props => [
        id,
        fromUserId,
        toUserId,
        donationId,
        deliveryId,
        type,
        rating,
        comment,
        isAnonymous,
        createdAt,
      ];
}

class UserRatingStats extends Equatable {
  final String userId;
  final double averageRating;
  final int totalRatings;
  final int fiveStarCount;
  final int fourStarCount;
  final int threeStarCount;
  final int twoStarCount;
  final int oneStarCount;

  const UserRatingStats({
    required this.userId,
    required this.averageRating,
    required this.totalRatings,
    this.fiveStarCount = 0,
    this.fourStarCount = 0,
    this.threeStarCount = 0,
    this.twoStarCount = 0,
    this.oneStarCount = 0,
  });

  factory UserRatingStats.fromJson(Map<String, dynamic> json) {
    return UserRatingStats(
      userId: json['user_id'] as String,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['total_ratings'] as int? ?? 0,
      fiveStarCount: json['five_star_count'] as int? ?? 0,
      fourStarCount: json['four_star_count'] as int? ?? 0,
      threeStarCount: json['three_star_count'] as int? ?? 0,
      twoStarCount: json['two_star_count'] as int? ?? 0,
      oneStarCount: json['one_star_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        averageRating,
        totalRatings,
        fiveStarCount,
        fourStarCount,
        threeStarCount,
        twoStarCount,
        oneStarCount,
      ];
}
