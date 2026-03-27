import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  @JsonValue('new_donation')
  newDonation,
  @JsonValue('pickup_reminder')
  pickupReminder,
  @JsonValue('status_update')
  statusUpdate,
  @JsonValue('chat_message')
  chatMessage,
  @JsonValue('delivery_assigned')
  deliveryAssigned,
  @JsonValue('delivery_completed')
  deliveryCompleted,
  @JsonValue('volunteer_accepted')
  volunteerAccepted,
  @JsonValue('ngo_requested')
  ngoRequested,
  @JsonValue('donation_picked_up')
  donationPickedUp,
  @JsonValue('donation_delivered')
  donationDelivered,
  @JsonValue('donation_cancelled')
  donationCancelled,
  @JsonValue('ngo_request_submitted')
  ngoRequestSubmitted,
  @JsonValue('ngo_request_approved')
  ngoRequestApproved,
  @JsonValue('ngo_request_denied')
  ngoRequestDenied,
  @JsonValue('system')
  system,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.newDonation:
        return 'New Donation';
      case NotificationType.pickupReminder:
        return 'Pickup Reminder';
      case NotificationType.statusUpdate:
        return 'Status Update';
      case NotificationType.chatMessage:
        return 'Chat Message';
      case NotificationType.deliveryAssigned:
        return 'Delivery Assigned';
      case NotificationType.deliveryCompleted:
        return 'Delivery Completed';
      case NotificationType.volunteerAccepted:
        return 'Volunteer Accepted';
      case NotificationType.ngoRequested:
        return 'NGO Requested';
      case NotificationType.donationPickedUp:
        return 'Donation Picked Up';
      case NotificationType.donationDelivered:
        return 'Donation Delivered';
      case NotificationType.donationCancelled:
        return 'Donation Cancelled';
      case NotificationType.ngoRequestSubmitted:
        return 'NGO Request Submitted';
      case NotificationType.ngoRequestApproved:
        return 'Request Approved';
      case NotificationType.ngoRequestDenied:
        return 'Request Denied';
      case NotificationType.system:
        return 'System';
    }
  }

  String get jsonValue {
    switch (this) {
      case NotificationType.newDonation:
        return 'new_donation';
      case NotificationType.pickupReminder:
        return 'pickup_reminder';
      case NotificationType.statusUpdate:
        return 'status_update';
      case NotificationType.chatMessage:
        return 'chat_message';
      case NotificationType.deliveryAssigned:
        return 'delivery_assigned';
      case NotificationType.deliveryCompleted:
        return 'delivery_completed';
      case NotificationType.volunteerAccepted:
        return 'volunteer_accepted';
      case NotificationType.ngoRequested:
        return 'ngo_requested';
      case NotificationType.donationPickedUp:
        return 'donation_picked_up';
      case NotificationType.donationDelivered:
        return 'donation_delivered';
      case NotificationType.donationCancelled:
        return 'donation_cancelled';
      case NotificationType.ngoRequestSubmitted:
        return 'ngo_request_submitted';
      case NotificationType.ngoRequestApproved:
        return 'ngo_request_approved';
      case NotificationType.ngoRequestDenied:
        return 'ngo_request_denied';
      case NotificationType.system:
        return 'system';
    }
  }

  String get category {
    switch (this) {
      case NotificationType.newDonation:
      case NotificationType.volunteerAccepted:
      case NotificationType.ngoRequested:
      case NotificationType.ngoRequestSubmitted:
      case NotificationType.ngoRequestApproved:
      case NotificationType.ngoRequestDenied:
        return 'Donations';
      case NotificationType.donationPickedUp:
      case NotificationType.donationDelivered:
      case NotificationType.deliveryAssigned:
      case NotificationType.deliveryCompleted:
        return 'Deliveries';
      case NotificationType.statusUpdate:
      case NotificationType.donationCancelled:
        return 'Status Updates';
      case NotificationType.pickupReminder:
        return 'Reminders';
      case NotificationType.chatMessage:
        return 'Messages';
      case NotificationType.system:
        return 'System';
    }
  }
}

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String message,
    required NotificationType type,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'related_entity_id') String? relatedEntityId,
    @JsonKey(name: 'related_entity_type') String? relatedEntityType,
    @JsonKey(name: 'actor_name')
    String? actorName, // Name of person who triggered the notification
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Ignore the 'data' field from database - it's a JSON string that we don't need
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(null)
    String? data,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'new_donation_alerts') @Default(true) bool newDonationAlerts,
    @JsonKey(name: 'pickup_reminders') @Default(true) bool pickupReminders,
    @JsonKey(name: 'status_updates') @Default(true) bool statusUpdates,
    @JsonKey(name: 'chat_messages') @Default(true) bool chatMessages,
    @JsonKey(name: 'all_notifications_enabled')
    @Default(true)
    bool allNotificationsEnabled,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}

@freezed
class FCMToken with _$FCMToken {
  const factory FCMToken({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String token,
    @JsonKey(name: 'device_type') required String deviceType,
    @JsonKey(name: 'device_info') String? deviceInfo,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'last_used_at') required DateTime lastUsedAt,
  }) = _FCMToken;

  factory FCMToken.fromJson(Map<String, dynamic> json) =>
      _$FCMTokenFromJson(json);
}
