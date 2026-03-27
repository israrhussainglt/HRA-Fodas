import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/enums/enums.dart';

part 'ngo_request.freezed.dart';
part 'ngo_request.g.dart';

/// NGO Request Status
enum NGORequestStatus {
  pending,
  approved,
  denied,
  converted,
  cancelled;

  String get dbValue => name;
  String get displayName {
    switch (this) {
      case NGORequestStatus.pending:
        return 'Pending Review';
      case NGORequestStatus.approved:
        return 'Approved';
      case NGORequestStatus.denied:
        return 'Denied';
      case NGORequestStatus.converted:
        return 'Converted to Donation';
      case NGORequestStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Custom JSON converter for FoodCategory enum to use snake_case in database
class FoodCategoryConverter implements JsonConverter<FoodCategory, String> {
  const FoodCategoryConverter();

  @override
  FoodCategory fromJson(String json) => FoodCategoryExtension.fromString(json);

  @override
  String toJson(FoodCategory object) => object.dbValue;
}

@freezed
class NGORequest with _$NGORequest {
  const factory NGORequest({
    @JsonKey(name: '\$id') required String id,
    @JsonKey(name: 'recipient_id') required String ngoId,
    @JsonKey(name: 'ngo_name') required String ngoName,
    required String title,
    required String description,
    @FoodCategoryConverter()
    @JsonKey(name: 'food_category')
    required FoodCategory foodCategory,
    required double quantity,
    required String unit,
    @JsonKey(name: 'delivery_address') required String deliveryAddress,
    @JsonKey(name: 'needed_by') required DateTime neededBy,
    required NGORequestStatus status,
    @JsonKey(name: 'donation_id')
    String? donationId, // Link to specific donation being requested
    @JsonKey(name: 'denial_reason') String? denialReason,
    @JsonKey(name: 'reviewed_by') String? reviewedBy,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
    @JsonKey(name: 'converted_donation_id') String? convertedDonationId,
    @JsonKey(name: '\$createdAt') DateTime? createdAt,
    @JsonKey(name: '\$updatedAt') DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) = _NGORequest;

  factory NGORequest.fromJson(Map<String, dynamic> json) =>
      _$NGORequestFromJson(json);
}
