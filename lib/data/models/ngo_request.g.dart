// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ngo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NGORequestImpl _$$NGORequestImplFromJson(Map<String, dynamic> json) =>
    _$NGORequestImpl(
      id: json[r'$id'] as String,
      ngoId: json['recipient_id'] as String,
      ngoName: json['ngo_name'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      foodCategory: const FoodCategoryConverter().fromJson(
        json['food_category'] as String,
      ),
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      deliveryAddress: json['delivery_address'] as String,
      neededBy: DateTime.parse(json['needed_by'] as String),
      status: $enumDecode(_$NGORequestStatusEnumMap, json['status']),
      donationId: json['donation_id'] as String?,
      denialReason: json['denial_reason'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      convertedDonationId: json['converted_donation_id'] as String?,
      createdAt: json[r'$createdAt'] == null
          ? null
          : DateTime.parse(json[r'$createdAt'] as String),
      updatedAt: json[r'$updatedAt'] == null
          ? null
          : DateTime.parse(json[r'$updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$NGORequestImplToJson(
  _$NGORequestImpl instance,
) => <String, dynamic>{
  r'$id': instance.id,
  'recipient_id': instance.ngoId,
  'ngo_name': instance.ngoName,
  'title': instance.title,
  'description': instance.description,
  'food_category': const FoodCategoryConverter().toJson(instance.foodCategory),
  'quantity': instance.quantity,
  'unit': instance.unit,
  'delivery_address': instance.deliveryAddress,
  'needed_by': instance.neededBy.toIso8601String(),
  'status': _$NGORequestStatusEnumMap[instance.status]!,
  'donation_id': instance.donationId,
  'denial_reason': instance.denialReason,
  'reviewed_by': instance.reviewedBy,
  'reviewed_at': instance.reviewedAt?.toIso8601String(),
  'converted_donation_id': instance.convertedDonationId,
  r'$createdAt': instance.createdAt?.toIso8601String(),
  r'$updatedAt': instance.updatedAt?.toIso8601String(),
  'metadata': instance.metadata,
};

const _$NGORequestStatusEnumMap = {
  NGORequestStatus.pending: 'pending',
  NGORequestStatus.approved: 'approved',
  NGORequestStatus.denied: 'denied',
  NGORequestStatus.converted: 'converted',
  NGORequestStatus.cancelled: 'cancelled',
};
