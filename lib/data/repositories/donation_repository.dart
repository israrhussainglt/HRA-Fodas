import 'package:appwrite/appwrite.dart';
import '../models/donation.dart';
import '../models/notification_model.dart';
import '../../core/enums/enums.dart';
import '../../appwrite_options.dart';
import 'auth_repository.dart';
import 'notification_repository.dart';

import '../../services/enhanced_notification_service.dart';

class DonationRepository {
  final TablesDB _databases; // Changed from _databases to _databases
  final AuthRepository? _authRepository;
  final NotificationRepository? _notificationRepository;
  final EnhancedNotificationService? _enhancedNotificationService;

  DonationRepository(
    this._databases, { // Changed from _databases to _databases
    AuthRepository? authRepository,
    NotificationRepository? notificationRepository,
    EnhancedNotificationService? enhancedNotificationService,
  }) : _authRepository = authRepository,
       _notificationRepository = notificationRepository,
       _enhancedNotificationService = enhancedNotificationService;

  Future<List<Donation>> getDonations({
    DonationStatus? status,
    String? donorId,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queries = <String>[];

      if (status != null) {
        queries.add(Query.equal('status', status.dbValue));
      }
      if (donorId != null) {
        queries.add(Query.equal('donor_id', donorId));
      }

      queries.add(Query.orderDesc('\$createdAt'));
      queries.add(Query.limit(limit));
      queries.add(Query.offset(offset));

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        queries: queries,
      );

      return response.rows.map((doc) => Donation.fromJson(doc.data)).toList();
    } on AppwriteException catch (e) {
      throw Exception('Failed to get donations: ${e.message}');
    }
  }

  Future<List<Donation>> getAvailableDonations({
    double? latitude,
    double? longitude,
    double radiusKm = 50,
  }) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        queries: [
          Query.equal('status', ['pending', 'scheduled', 'picked_up']),
          Query.greaterThanEqual('expiration_date', today),
          Query.orderDesc('\$createdAt'),
        ],
      );

      return response.rows.map((doc) => Donation.fromJson(doc.data)).toList();
    } on AppwriteException catch (e) {
      throw Exception('Failed to get available donations: ${e.message}');
    }
  }

  Future<Donation> getDonationById(String id) async {
    try {
      final response = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: id,
      );

      return Donation.fromJson(response.data);
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        throw Exception('Donation not found');
      }
      throw Exception('Failed to get donation: ${e.message}');
    }
  }

  Future<Donation> createDonation(Donation donation) async {
    try {
      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: ID.unique(),
        data: donation.toJson(),
      );

      final createdDonation = Donation.fromJson(response.data);

      // Send notifications to volunteers and recipients
      if (_authRepository != null && _notificationRepository != null) {
        await _sendNewDonationNotifications(createdDonation);
      }

      return createdDonation;
    } on AppwriteException catch (e) {
      throw Exception('Failed to create donation: ${e.message}');
    }
  }

  Future<void> _sendNewDonationNotifications(Donation donation) async {
    try {
      if (_enhancedNotificationService != null && _authRepository != null) {
        // Get all volunteers
        final volunteers = await _authRepository.getUsersByRole(
          UserRole.volunteer,
        );

        // Get all recipients (organizations)
        final recipients = await _authRepository.getUsersByRole(
          UserRole.recipient,
        );

        // Get all admins
        final admins = await _authRepository.getUsersByRole(UserRole.admin);

        // Combine all users to notify (volunteers, recipients, and admins)
        final usersToNotify = [...volunteers, ...recipients, ...admins];

        // Send enhanced notifications to all users
        final userIds = usersToNotify.map((user) => user.id).toList();

        await _enhancedNotificationService.sendNotificationToUsers(
          userIds: userIds,
          title: 'New Donation Available',
          body:
              'A new ${donation.foodCategory.displayName} donation is available for pickup',
          type: NotificationType.newDonation,
          relatedEntityId: donation.id,
          relatedEntityType: 'donation',
          data: {
            'donation_id': donation.id,
            'food_category': donation.foodCategory.dbValue,
            'quantity': donation.quantity,
            'pickup_address': donation.pickupAddress,
          },
        );
      } else {
        await _sendNewDonationNotificationsFallback(donation);
      }
    } catch (e) {
      // Fallback to old method
      await _sendNewDonationNotificationsFallback(donation);
    }
  }

  Future<void> _sendNewDonationNotificationsFallback(Donation donation) async {
    try {
      // Get all volunteers
      final volunteers =
          await _authRepository?.getUsersByRole(UserRole.volunteer) ?? [];

      // Get all recipients (organizations)
      final recipients =
          await _authRepository?.getUsersByRole(UserRole.recipient) ?? [];

      // Get all admins
      final admins =
          await _authRepository?.getUsersByRole(UserRole.admin) ?? [];

      // Combine all users to notify (volunteers, recipients, and admins)
      final usersToNotify = [...volunteers, ...recipients, ...admins];

      // Create notification for each user
      for (final user in usersToNotify) {
        try {
          // Only create database notification (local notification will be triggered by realtime subscription)
          await _notificationRepository!.createNotification(
            userId: user.id,
            title: 'New Donation Available',
            body:
                'A new ${donation.foodCategory.displayName} donation is available for pickup',
            type: NotificationType.newDonation,
            relatedEntityId: donation.id,
            relatedEntityType: 'donation',
            // REMOVED: data parameter - causes type error since Appwrite stores it as JSON string
          );
        } catch (e) {
          // Continue with other users even if one fails
        }
      }
    } catch (e) {
      // Don't throw - notification failure shouldn't prevent donation creation
    }
  }

  Future<Donation> updateDonation(Donation donation) async {
    try {
      final response = await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: donation.id,
        data: donation.toJson(),
      );

      return Donation.fromJson(response.data);
    } on AppwriteException catch (e) {
      throw Exception('Failed to update donation: ${e.message}');
    }
  }

  Future<void> updateDonationStatus(String id, DonationStatus status) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: id,
        data: {'status': status.dbValue},
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to update donation status: ${e.message}');
    }
  }

  Future<void> assignVolunteer(String donationId, String volunteerId) async {
    try {
      // First check if donation is already assigned
      final donation = await getDonationById(donationId);

      if (donation.assignedVolunteerId != null) {
        throw Exception(
          'This donation has already been accepted by another volunteer',
        );
      }

      // Update the donation
      final response = await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: donationId,
        data: {'assigned_volunteer_id': volunteerId, 'status': 'assigned'},
      );

      // Double-check the assignment was successful
      final updatedDonation = Donation.fromJson(response.data);

      if (updatedDonation.assignedVolunteerId != volunteerId) {
        throw Exception(
          'Failed to assign volunteer - database update did not apply',
        );
      }

      // Send notification to donor about volunteer acceptance
      if (_authRepository != null && _notificationRepository != null) {
        try {
          // Get volunteer details
          final volunteer = await _authRepository.getUserProfile(volunteerId);

          await _notificationRepository.createNotification(
            userId: donation.donorId,
            title: 'Volunteer Accepted Your Donation',
            body:
                '${volunteer?.fullName ?? 'A volunteer'} has accepted your "${donation.title}" donation and will pick it up soon.',
            type: NotificationType.volunteerAccepted,
            relatedEntityId: donationId,
            relatedEntityType: 'donation',
            actorName: volunteer?.fullName,
          );

          // Notify all admins about volunteer acceptance
          final admins = await _authRepository.getUsersByRole(UserRole.admin);
          for (final admin in admins) {
            await _notificationRepository.createNotification(
              userId: admin.id,
              title: 'Volunteer Accepted Donation',
              body:
                  '${volunteer?.fullName ?? 'A volunteer'} accepted "${donation.title}" donation',
              type: NotificationType.volunteerAccepted,
              relatedEntityId: donationId,
              relatedEntityType: 'donation',
              actorName: volunteer?.fullName,
            );
          }
        } catch (e) {
          // Ignore notification errors
        }
      }
    } on AppwriteException catch (e) {
      throw Exception('Failed to assign volunteer: ${e.message}');
    }
  }

  Future<void> assignRecipient(String donationId, String recipientId) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: donationId,
        data: {'assigned_recipient_id': recipientId},
      );

      // Send notification to volunteer about NGO request
      if (_authRepository != null && _notificationRepository != null) {
        try {
          final donation = await getDonationById(donationId);
          if (donation.assignedVolunteerId != null) {
            // Get NGO details
            final ngo = await _authRepository.getUserProfile(recipientId);

            await _notificationRepository.createNotification(
              userId: donation.assignedVolunteerId!,
              title: 'NGO Requested Delivery',
              body:
                  '${ngo?.fullName ?? 'An organization'} has requested delivery of the "${donation.title}" donation. Please deliver it to them.',
              type: NotificationType.ngoRequested,
              relatedEntityId: donationId,
              relatedEntityType: 'donation',
              actorName: ngo?.fullName,
            );

            // Notify all admins about NGO request
            final admins = await _authRepository.getUsersByRole(UserRole.admin);
            for (final admin in admins) {
              await _notificationRepository.createNotification(
                userId: admin.id,
                title: 'NGO Requested Delivery',
                body:
                    '${ngo?.fullName ?? 'An organization'} requested delivery of "${donation.title}"',
                type: NotificationType.ngoRequested,
                relatedEntityId: donationId,
                relatedEntityType: 'donation',
                actorName: ngo?.fullName,
              );
            }
          }
        } catch (e) {
          // Ignore notification errors
        }
      }
    } on AppwriteException catch (e) {
      throw Exception('Failed to assign recipient: ${e.message}');
    }
  }

  // Status transition methods
  Future<void> markAsPickedUp(String donationId, String volunteerId) async {
    try {
      // Verify current status and volunteer assignment
      final donation = await getDonationById(donationId);

      if (donation.assignedVolunteerId != volunteerId) {
        throw Exception('You are not assigned to this donation');
      }

      if (donation.status != DonationStatus.assigned) {
        throw Exception(
          'Can only mark as picked up when status is assigned. Current status: ${donation.status.displayName}',
        );
      }

      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: donationId,
        data: {'status': 'picked_up'},
      );

      // Send notification to donor about pickup
      if (_authRepository != null && _notificationRepository != null) {
        try {
          // Get volunteer details
          final volunteer = await _authRepository.getUserProfile(volunteerId);

          await _notificationRepository.createNotification(
            userId: donation.donorId,
            title: 'Donation Picked Up',
            body:
                '${volunteer?.fullName ?? 'The volunteer'} has picked up your "${donation.title}" donation and is on the way to deliver it.',
            type: NotificationType.donationPickedUp,
            relatedEntityId: donationId,
            relatedEntityType: 'donation',
            actorName: volunteer?.fullName,
          );

          // Notify all admins about pickup
          final admins = await _authRepository.getUsersByRole(UserRole.admin);
          for (final admin in admins) {
            await _notificationRepository.createNotification(
              userId: admin.id,
              title: 'Donation Picked Up',
              body:
                  '${volunteer?.fullName ?? 'Volunteer'} picked up "${donation.title}"',
              type: NotificationType.donationPickedUp,
              relatedEntityId: donationId,
              relatedEntityType: 'donation',
              actorName: volunteer?.fullName,
            );
          }
        } catch (e) {
          // Ignore notification errors
        }
      }
    } on AppwriteException catch (e) {
      throw Exception('Failed to mark as picked up: ${e.message}');
    }
  }

  Future<void> markAsDelivered(String donationId, String volunteerId) async {
    try {
      // Verify current status and volunteer assignment
      final donation = await getDonationById(donationId);

      if (donation.assignedVolunteerId != volunteerId) {
        throw Exception('You are not assigned to this donation');
      }

      if (donation.status != DonationStatus.pickedUp) {
        throw Exception(
          'Can only mark as delivered when status is picked up. Current status: ${donation.status.displayName}',
        );
      }

      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: donationId,
        data: {'status': 'delivered'},
      );

      // Send notifications about delivery completion
      if (_authRepository != null && _notificationRepository != null) {
        try {
          // Get volunteer details
          final volunteer = await _authRepository.getUserProfile(volunteerId);

          // Notify donor about successful delivery
          await _notificationRepository.createNotification(
            userId: donation.donorId,
            title: 'Donation Delivered Successfully',
            body:
                '${volunteer?.fullName ?? 'The volunteer'} has successfully delivered your "${donation.title}" donation${donation.assignedRecipientId != null ? ' to the recipient organization' : ''}. Thank you for your contribution!',
            type: NotificationType.donationDelivered,
            relatedEntityId: donationId,
            relatedEntityType: 'donation',
            actorName: volunteer?.fullName,
          );

          // If there's an assigned recipient, notify them too
          if (donation.assignedRecipientId != null) {
            await _notificationRepository.createNotification(
              userId: donation.assignedRecipientId!,
              title: 'Donation Delivered',
              body:
                  '${volunteer?.fullName ?? 'The volunteer'} has delivered the "${donation.title}" donation to you. Please confirm receipt.',
              type: NotificationType.donationDelivered,
              relatedEntityId: donationId,
              relatedEntityType: 'donation',
              actorName: volunteer?.fullName,
            );
          }

          // Notify all admins about delivery completion
          final admins = await _authRepository.getUsersByRole(UserRole.admin);
          for (final admin in admins) {
            await _notificationRepository.createNotification(
              userId: admin.id,
              title: 'Donation Delivered',
              body:
                  '${volunteer?.fullName ?? 'Volunteer'} delivered "${donation.title}"${donation.assignedRecipientId != null ? ' to recipient' : ''}',
              type: NotificationType.donationDelivered,
              relatedEntityId: donationId,
              relatedEntityType: 'donation',
              actorName: volunteer?.fullName,
            );
          }
        } catch (e) {
          // Ignore notification errors
        }
      }
    } on AppwriteException catch (e) {
      throw Exception('Failed to mark as delivered: ${e.message}');
    }
  }

  Future<void> cancelDonation(String donationId, String donorId) async {
    try {
      // Verify ownership before cancelling
      final donation = await getDonationById(donationId);
      if (donation.donorId != donorId) {
        throw Exception('You can only cancel your own donations');
      }

      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.donationsCollection,
        rowId: donationId,
        data: {'status': 'cancelled'},
      );

      // Send notifications about cancellation
      if (_authRepository != null && _notificationRepository != null) {
        try {
          // Get donor details
          final donor = await _authRepository.getUserProfile(donorId);

          // Notify assigned volunteer if any
          if (donation.assignedVolunteerId != null) {
            await _notificationRepository.createNotification(
              userId: donation.assignedVolunteerId!,
              title: 'Donation Cancelled',
              body:
                  'The "${donation.title}" donation you were assigned to has been cancelled by ${donor?.fullName ?? 'the donor'}.',
              type: NotificationType.donationCancelled,
              relatedEntityId: donationId,
              relatedEntityType: 'donation',
              actorName: donor?.fullName,
            );
          }

          // Notify assigned recipient if any
          if (donation.assignedRecipientId != null) {
            await _notificationRepository.createNotification(
              userId: donation.assignedRecipientId!,
              title: 'Donation Cancelled',
              body:
                  'The "${donation.title}" donation has been cancelled by the donor.',
              type: NotificationType.donationCancelled,
              relatedEntityId: donationId,
              relatedEntityType: 'donation',
              actorName: donor?.fullName,
            );
          }

          // Notify all admins about cancellation
          final admins = await _authRepository.getUsersByRole(UserRole.admin);
          for (final admin in admins) {
            await _notificationRepository.createNotification(
              userId: admin.id,
              title: 'Donation Cancelled',
              body:
                  '${donor?.fullName ?? 'Donor'} cancelled "${donation.title}" donation',
              type: NotificationType.donationCancelled,
              relatedEntityId: donationId,
              relatedEntityType: 'donation',
              actorName: donor?.fullName,
            );
          }
        } catch (e) {
          // Ignore notification errors
        }
      }
    } on AppwriteException catch (e) {
      throw Exception('Failed to cancel donation: ${e.message}');
    }
  }

  Future<void> deleteDonation(String donationId, String donorId) async {
    try {
      // Verify ownership before deleting
      final donation = await getDonationById(donationId);
      if (donation.donorId != donorId) {
        throw Exception('You can only delete your own donations');
      }

      // Try to delete with explicit permissions
      try {
        await _databases.deleteRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: AppwriteOptions.donationsCollection,
          rowId: donationId,
        );
      } catch (permissionError) {
        // In this case, the user might not have delete permissions on the collection
        // This needs to be configured in the Appwrite Console
        throw Exception(
          'Delete permission denied. Please check collection permissions in Appwrite Console.',
        );
      }
    } on AppwriteException catch (e) {
      // Provide more user-friendly error messages
      if (e.message?.contains('unauthorized') == true ||
          e.message?.contains('permission') == true) {
        throw Exception(
          'You don\'t have permission to delete this donation. Please contact support if this is your donation.',
        );
      } else if (e.message?.contains('not found') == true) {
        throw Exception(
          'Donation not found. It may have already been deleted.',
        );
      } else {
        throw Exception(
          'Failed to delete donation: ${e.message ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception(
        'An unexpected error occurred while deleting the donation.',
      );
    }
  }

  // Note: Appwrite Realtime subscriptions work differently
  // You'll need to implement this in the UI layer using Realtime service
  // Example implementation would be in the provider/controller
  Stream<List<Donation>> watchDonations(String donorId) async* {
    // Initial fetch
    yield await getDonations(donorId: donorId);

    // For real-time updates, use Appwrite Realtime in the UI layer
    // This is a placeholder that returns the initial data
  }
}
