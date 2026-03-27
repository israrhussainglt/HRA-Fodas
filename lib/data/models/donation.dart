import 'package:equatable/equatable.dart';
import 'dart:convert';
import '../../core/enums/enums.dart';

class Donation extends Equatable {
  final String id;
  final String donorId;
  final String title;
  final String? description;
  final FoodCategory foodCategory;
  final double quantity;
  final String unit;
  final DateTime expirationDate;
  final String pickupAddress;
  final double latitude;
  final double longitude;
  final DateTime pickupStartTime;
  final DateTime pickupEndTime;
  final String? specialInstructions;
  final List<String> images;
  final DonationStatus status;
  final String? assignedVolunteerId;
  final String? assignedRecipientId;
  final DateTime? pickupTime;
  final DateTime? deliveryTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Donation({
    required this.id,
    required this.donorId,
    required this.title,
    this.description,
    required this.foodCategory,
    required this.quantity,
    required this.unit,
    required this.expirationDate,
    required this.pickupAddress,
    required this.latitude,
    required this.longitude,
    required this.pickupStartTime,
    required this.pickupEndTime,
    this.specialInstructions,
    this.images = const [],
    this.status = DonationStatus.pending,
    this.assignedVolunteerId,
    this.assignedRecipientId,
    this.pickupTime,
    this.deliveryTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['\$id'] as String? ?? json['id'] as String,
      donorId: json['donor_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      foodCategory: FoodCategoryExtension.fromString(
        json['food_category'] as String,
      ),
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      expirationDate: DateTime.parse(json['expiration_date'] as String),
      pickupAddress: json['pickup_address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      pickupStartTime: DateTime.parse(json['pickup_start_time'] as String),
      pickupEndTime: DateTime.parse(json['pickup_end_time'] as String),
      specialInstructions: json['special_instructions'] as String?,
      images: _parseImages(json['images']),
      status: DonationStatusExtension.fromString(
        json['status'] as String? ?? 'pending',
      ),
      assignedVolunteerId: json['assigned_volunteer_id'] as String?,
      assignedRecipientId: json['assigned_recipient_id'] as String?,
      pickupTime: json['pickup_time'] != null
          ? DateTime.parse(json['pickup_time'] as String)
          : null,
      deliveryTime: json['delivery_time'] != null
          ? DateTime.parse(json['delivery_time'] as String)
          : null,
      createdAt: json['\$createdAt'] != null
          ? DateTime.parse(json['\$createdAt'] as String)
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'] as String)
                : DateTime.now()),
      updatedAt: json['\$updatedAt'] != null
          ? DateTime.parse(json['\$updatedAt'] as String)
          : (json['updated_at'] != null
                ? DateTime.parse(json['updated_at'] as String)
                : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'donor_id': donorId,
      'title': title,
      'description': description,
      'food_category': foodCategory.dbValue,
      'quantity': quantity,
      'unit': unit,
      'expiration_date': expirationDate.toIso8601String().split('T')[0],
      'pickup_address': pickupAddress,
      'latitude': latitude,
      'longitude': longitude,
      'pickup_start_time': pickupStartTime.toIso8601String(),
      'pickup_end_time': pickupEndTime.toIso8601String(),
      'special_instructions': specialInstructions,
      'images': _encodeImages(images),
      'status': status.dbValue,
    };
  }

  Donation copyWith({
    String? title,
    String? description,
    FoodCategory? foodCategory,
    double? quantity,
    String? unit,
    DateTime? expirationDate,
    String? pickupAddress,
    double? latitude,
    double? longitude,
    DateTime? pickupStartTime,
    DateTime? pickupEndTime,
    String? specialInstructions,
    List<String>? images,
    DonationStatus? status,
    String? assignedVolunteerId,
    String? assignedRecipientId,
    DateTime? pickupTime,
    DateTime? deliveryTime,
  }) {
    return Donation(
      id: id,
      donorId: donorId,
      title: title ?? this.title,
      description: description ?? this.description,
      foodCategory: foodCategory ?? this.foodCategory,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expirationDate: expirationDate ?? this.expirationDate,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pickupStartTime: pickupStartTime ?? this.pickupStartTime,
      pickupEndTime: pickupEndTime ?? this.pickupEndTime,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      images: images ?? this.images,
      status: status ?? this.status,
      assignedVolunteerId: assignedVolunteerId ?? this.assignedVolunteerId,
      assignedRecipientId: assignedRecipientId ?? this.assignedRecipientId,
      pickupTime: pickupTime ?? this.pickupTime,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, donorId, title, status];

  // Helper methods for images serialization
  static List<String> _parseImages(dynamic imagesData) {
    if (imagesData == null) return [];
    if (imagesData is String) {
      if (imagesData.isEmpty) return [];
      try {
        final decoded = jsonDecode(imagesData);
        if (decoded is List) {
          return decoded.cast<String>();
        }
      } catch (e) {
        // If JSON decode fails, treat as comma-separated string
        return imagesData.split(',').where((s) => s.isNotEmpty).toList();
      }
    }
    if (imagesData is List) {
      return imagesData.cast<String>();
    }
    return [];
  }

  static String _encodeImages(List<String> images) {
    if (images.isEmpty) return '';
    return jsonEncode(images);
  }
}
