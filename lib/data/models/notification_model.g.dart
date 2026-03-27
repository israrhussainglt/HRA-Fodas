// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
  isRead: json['is_read'] as bool? ?? false,
  relatedEntityId: json['related_entity_id'] as String?,
  relatedEntityType: json['related_entity_type'] as String?,
  actorName: json['actor_name'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'title': instance.title,
  'message': instance.message,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'is_read': instance.isRead,
  'related_entity_id': instance.relatedEntityId,
  'related_entity_type': instance.relatedEntityType,
  'actor_name': instance.actorName,
  'created_at': instance.createdAt?.toIso8601String(),
};

const _$NotificationTypeEnumMap = {
  NotificationType.newDonation: 'new_donation',
  NotificationType.pickupReminder: 'pickup_reminder',
  NotificationType.statusUpdate: 'status_update',
  NotificationType.chatMessage: 'chat_message',
  NotificationType.deliveryAssigned: 'delivery_assigned',
  NotificationType.deliveryCompleted: 'delivery_completed',
  NotificationType.volunteerAccepted: 'volunteer_accepted',
  NotificationType.ngoRequested: 'ngo_requested',
  NotificationType.donationPickedUp: 'donation_picked_up',
  NotificationType.donationDelivered: 'donation_delivered',
  NotificationType.donationCancelled: 'donation_cancelled',
  NotificationType.ngoRequestSubmitted: 'ngo_request_submitted',
  NotificationType.ngoRequestApproved: 'ngo_request_approved',
  NotificationType.ngoRequestDenied: 'ngo_request_denied',
  NotificationType.system: 'system',
};

_$NotificationPreferencesImpl _$$NotificationPreferencesImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationPreferencesImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  newDonationAlerts: json['new_donation_alerts'] as bool? ?? true,
  pickupReminders: json['pickup_reminders'] as bool? ?? true,
  statusUpdates: json['status_updates'] as bool? ?? true,
  chatMessages: json['chat_messages'] as bool? ?? true,
  allNotificationsEnabled: json['all_notifications_enabled'] as bool? ?? true,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$NotificationPreferencesImplToJson(
  _$NotificationPreferencesImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'new_donation_alerts': instance.newDonationAlerts,
  'pickup_reminders': instance.pickupReminders,
  'status_updates': instance.statusUpdates,
  'chat_messages': instance.chatMessages,
  'all_notifications_enabled': instance.allNotificationsEnabled,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_$FCMTokenImpl _$$FCMTokenImplFromJson(Map<String, dynamic> json) =>
    _$FCMTokenImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      token: json['token'] as String,
      deviceType: json['device_type'] as String,
      deviceInfo: json['device_info'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastUsedAt: DateTime.parse(json['last_used_at'] as String),
    );

Map<String, dynamic> _$$FCMTokenImplToJson(_$FCMTokenImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'token': instance.token,
      'device_type': instance.deviceType,
      'device_info': instance.deviceInfo,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'last_used_at': instance.lastUsedAt.toIso8601String(),
    };
