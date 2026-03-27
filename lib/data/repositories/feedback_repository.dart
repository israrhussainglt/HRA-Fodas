import 'package:appwrite/appwrite.dart';
import '../models/feedback_rating.dart';
import '../../appwrite_options.dart';

class FeedbackRepository {
  final TablesDB _databases; // Changed from _databases to _databases

  FeedbackRepository(this._databases);

  Future<List<FeedbackRating>> getFeedbackForUser(String userId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        queries: [
          Query.equal('to_user_id', userId),
          Query.orderDesc('created_at'),
        ],
      );

      return response.rows
          .map((doc) => FeedbackRating.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FeedbackRating>> getFeedbackByUser(String userId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        queries: [
          Query.equal('from_user_id', userId),
          Query.orderDesc('created_at'),
        ],
      );

      return response.rows
          .map((doc) => FeedbackRating.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FeedbackRating>> getFeedbackForDonation(String donationId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        queries: [
          Query.equal('donation_id', donationId),
          Query.orderDesc('created_at'),
        ],
      );

      return response.rows
          .map((doc) => FeedbackRating.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<FeedbackRating>> getFeedbackForDelivery(String deliveryId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        queries: [
          Query.equal('delivery_id', deliveryId),
          Query.orderDesc('created_at'),
        ],
      );

      return response.rows
          .map((doc) => FeedbackRating.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<FeedbackRating?> submitFeedback({
    required String fromUserId,
    required String toUserId,
    String? donationId,
    String? deliveryId,
    required FeedbackType type,
    required int rating,
    String? comment,
    bool isAnonymous = false,
  }) async {
    try {
      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        rowId: ID.unique(),
        data: {
          'from_user_id': fromUserId,
          'to_user_id': toUserId,
          'donation_id': donationId,
          'delivery_id': deliveryId,
          'type': type.name,
          'rating': rating,
          'comment': comment,
          'is_anonymous': isAnonymous,
        },
      );

      return FeedbackRating.fromJson({...response.data, 'id': response.$id});
    } catch (e) {
      return null;
    }
  }

  Future<UserRatingStats> getUserRatingStats(String userId) async {
    try {
      final feedback = await getFeedbackForUser(userId);

      if (feedback.isEmpty) {
        return UserRatingStats(
          userId: userId,
          averageRating: 0,
          totalRatings: 0,
        );
      }

      final totalRatings = feedback.length;
      final averageRating =
          feedback.map((f) => f.rating).reduce((a, b) => a + b) / totalRatings;

      int fiveStarCount = 0;
      int fourStarCount = 0;
      int threeStarCount = 0;
      int twoStarCount = 0;
      int oneStarCount = 0;

      for (final f in feedback) {
        switch (f.rating) {
          case 5:
            fiveStarCount++;
            break;
          case 4:
            fourStarCount++;
            break;
          case 3:
            threeStarCount++;
            break;
          case 2:
            twoStarCount++;
            break;
          case 1:
            oneStarCount++;
            break;
        }
      }

      return UserRatingStats(
        userId: userId,
        averageRating: averageRating,
        totalRatings: totalRatings,
        fiveStarCount: fiveStarCount,
        fourStarCount: fourStarCount,
        threeStarCount: threeStarCount,
        twoStarCount: twoStarCount,
        oneStarCount: oneStarCount,
      );
    } catch (e) {
      return UserRatingStats(userId: userId, averageRating: 0, totalRatings: 0);
    }
  }

  Future<bool> hasUserRated({
    required String fromUserId,
    String? donationId,
    String? deliveryId,
  }) async {
    try {
      final queries = [Query.equal('from_user_id', fromUserId)];

      if (donationId != null) {
        queries.add(Query.equal('donation_id', donationId));
      }
      if (deliveryId != null) {
        queries.add(Query.equal('delivery_id', deliveryId));
      }

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        queries: queries,
      );

      return response.rows.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteFeedback(String feedbackId) async {
    try {
      await _databases.deleteRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.feedbackRatingsCollection,
        rowId: feedbackId,
      );
    } catch (e) {
      // Ignore errors
    }
  }
}
