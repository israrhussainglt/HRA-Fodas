import 'package:equatable/equatable.dart';
import '../../core/enums/enums.dart';

class InventoryItem extends Equatable {
  final String id;
  final String recipientId;
  final String? organizationId;
  final String? donationId;
  final String name;
  final FoodCategory category;
  final double quantity;
  final String unit;
  final DateTime expirationDate;
  final DateTime receivedDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InventoryItem({
    required this.id,
    required this.recipientId,
    this.organizationId,
    this.donationId,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expirationDate,
    required this.receivedDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isExpiringSoon =>
      expirationDate.difference(DateTime.now()).inDays <= 3;

  bool get isExpired => expirationDate.isBefore(DateTime.now());

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      recipientId: json['organization_id'] as String,
      organizationId: json['organization_id'] as String?,
      donationId: json['donation_id'] as String?,
      name: json['item_name'] as String,
      category: FoodCategoryExtension.fromString(
        json['food_category'] as String,
      ),
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      expirationDate: DateTime.parse(json['expiration_date'] as String),
      receivedDate: DateTime.parse(json['received_date'] as String),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization_id': organizationId ?? recipientId,
      'donation_id': donationId,
      'item_name': name,
      'food_category': category.dbValue,
      'quantity': quantity,
      'unit': unit,
      'expiration_date': expirationDate.toIso8601String(),
      'received_date': receivedDate.toIso8601String(),
      'notes': notes,
    };
  }

  InventoryItem copyWith({
    String? id,
    String? recipientId,
    String? organizationId,
    String? donationId,
    String? name,
    FoodCategory? category,
    double? quantity,
    String? unit,
    DateTime? expirationDate,
    DateTime? receivedDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      organizationId: organizationId ?? this.organizationId,
      donationId: donationId ?? this.donationId,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expirationDate: expirationDate ?? this.expirationDate,
      receivedDate: receivedDate ?? this.receivedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    recipientId,
    organizationId,
    donationId,
    name,
    category,
    quantity,
    unit,
    expirationDate,
    receivedDate,
    notes,
    createdAt,
    updatedAt,
  ];
}
