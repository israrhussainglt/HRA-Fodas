import 'package:equatable/equatable.dart';
import '../../core/enums/enums.dart';

class Delivery extends Equatable {
  final String id;
  final String donationId;
  final String volunteerId;
  final String? recipientId;
  final DeliveryStatus status;
  final DateTime? pickupTime;
  final DateTime? deliveryTime;
  final double? currentLatitude;
  final double? currentLongitude;
  final Map<String, dynamic>? routeData;
  final DateTime? estimatedArrival;
  final String? pickupPhotoUrl;
  final String? deliveryPhotoUrl;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Delivery({
    required this.id,
    required this.donationId,
    required this.volunteerId,
    this.recipientId, // Made optional
    this.status = DeliveryStatus.assigned,
    this.pickupTime,
    this.deliveryTime,
    this.currentLatitude,
    this.currentLongitude,
    this.routeData,
    this.estimatedArrival,
    this.pickupPhotoUrl,
    this.deliveryPhotoUrl,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['\$id'] ?? json['id'] ?? '',
      donationId: json['donation_id'] as String? ?? '',
      volunteerId: json['volunteer_id'] as String? ?? '',
      recipientId: json['recipient_id'] as String?,
      status: _parseStatus(json['status'] as String?),
      pickupTime: json['pickup_time'] != null
          ? DateTime.tryParse(json['pickup_time'] as String)
          : null,
      deliveryTime: json['delivery_time'] != null
          ? DateTime.tryParse(json['delivery_time'] as String)
          : null,
      currentLatitude: (json['current_latitude'] as num?)?.toDouble(),
      currentLongitude: (json['current_longitude'] as num?)?.toDouble(),
      routeData: json['route_data'] as Map<String, dynamic>?,
      estimatedArrival: json['estimated_arrival'] != null
          ? DateTime.tryParse(json['estimated_arrival'] as String)
          : null,
      pickupPhotoUrl: json['pickup_photo_url'] as String?,
      deliveryPhotoUrl: json['delivery_photo_url'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['\$createdAt'] != null
          ? DateTime.tryParse(json['\$createdAt'] as String) ?? DateTime.now()
          : (json['created_at'] != null
                ? DateTime.tryParse(json['created_at'] as String) ??
                      DateTime.now()
                : DateTime.now()),
      updatedAt: json['\$updatedAt'] != null
          ? DateTime.tryParse(json['\$updatedAt'] as String) ?? DateTime.now()
          : (json['updated_at'] != null
                ? DateTime.tryParse(json['updated_at'] as String) ??
                      DateTime.now()
                : DateTime.now()),
    );
  }

  static DeliveryStatus _parseStatus(String? value) {
    if (value == null) return DeliveryStatus.assigned;

    switch (value.toLowerCase()) {
      case 'assigned':
        return DeliveryStatus.assigned;
      case 'en_route_pickup':
      case 'enroutepickup':
        return DeliveryStatus.enRoutePickup;
      case 'picked_up':
      case 'pickedup':
        return DeliveryStatus.pickedUp;
      case 'en_route_delivery':
      case 'enroutedelivery':
        return DeliveryStatus.enRouteDelivery;
      case 'delivered':
        return DeliveryStatus.delivered;
      case 'failed':
        return DeliveryStatus.failed;
      case 'cancelled':
        return DeliveryStatus.cancelled;
      default:
        return DeliveryStatus.assigned;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'donation_id': donationId,
      'volunteer_id': volunteerId,
      'recipient_id': recipientId,
      'status': status.dbValue,
      'pickup_time': pickupTime?.toIso8601String(),
      'delivery_time': deliveryTime?.toIso8601String(),
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'route_data': routeData,
      'estimated_arrival': estimatedArrival?.toIso8601String(),
      'pickup_photo_url': pickupPhotoUrl,
      'delivery_photo_url': deliveryPhotoUrl,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [id, donationId, volunteerId, status];
}
