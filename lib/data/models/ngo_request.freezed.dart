// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ngo_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NGORequest _$NGORequestFromJson(Map<String, dynamic> json) {
  return _NGORequest.fromJson(json);
}

/// @nodoc
mixin _$NGORequest {
  @JsonKey(name: '\$id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient_id')
  String get ngoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ngo_name')
  String get ngoName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @FoodCategoryConverter()
  @JsonKey(name: 'food_category')
  FoodCategory get foodCategory => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'delivery_address')
  String get deliveryAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'needed_by')
  DateTime get neededBy => throw _privateConstructorUsedError;
  NGORequestStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'donation_id')
  String? get donationId => throw _privateConstructorUsedError; // Link to specific donation being requested
  @JsonKey(name: 'denial_reason')
  String? get denialReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewed_by')
  String? get reviewedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewed_at')
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'converted_donation_id')
  String? get convertedDonationId => throw _privateConstructorUsedError;
  @JsonKey(name: '\$createdAt')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: '\$updatedAt')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this NGORequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NGORequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NGORequestCopyWith<NGORequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NGORequestCopyWith<$Res> {
  factory $NGORequestCopyWith(
    NGORequest value,
    $Res Function(NGORequest) then,
  ) = _$NGORequestCopyWithImpl<$Res, NGORequest>;
  @useResult
  $Res call({
    @JsonKey(name: '\$id') String id,
    @JsonKey(name: 'recipient_id') String ngoId,
    @JsonKey(name: 'ngo_name') String ngoName,
    String title,
    String description,
    @FoodCategoryConverter()
    @JsonKey(name: 'food_category')
    FoodCategory foodCategory,
    double quantity,
    String unit,
    @JsonKey(name: 'delivery_address') String deliveryAddress,
    @JsonKey(name: 'needed_by') DateTime neededBy,
    NGORequestStatus status,
    @JsonKey(name: 'donation_id') String? donationId,
    @JsonKey(name: 'denial_reason') String? denialReason,
    @JsonKey(name: 'reviewed_by') String? reviewedBy,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
    @JsonKey(name: 'converted_donation_id') String? convertedDonationId,
    @JsonKey(name: '\$createdAt') DateTime? createdAt,
    @JsonKey(name: '\$updatedAt') DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$NGORequestCopyWithImpl<$Res, $Val extends NGORequest>
    implements $NGORequestCopyWith<$Res> {
  _$NGORequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NGORequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ngoId = null,
    Object? ngoName = null,
    Object? title = null,
    Object? description = null,
    Object? foodCategory = null,
    Object? quantity = null,
    Object? unit = null,
    Object? deliveryAddress = null,
    Object? neededBy = null,
    Object? status = null,
    Object? donationId = freezed,
    Object? denialReason = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? convertedDonationId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ngoId: null == ngoId
                ? _value.ngoId
                : ngoId // ignore: cast_nullable_to_non_nullable
                      as String,
            ngoName: null == ngoName
                ? _value.ngoName
                : ngoName // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            foodCategory: null == foodCategory
                ? _value.foodCategory
                : foodCategory // ignore: cast_nullable_to_non_nullable
                      as FoodCategory,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryAddress: null == deliveryAddress
                ? _value.deliveryAddress
                : deliveryAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            neededBy: null == neededBy
                ? _value.neededBy
                : neededBy // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as NGORequestStatus,
            donationId: freezed == donationId
                ? _value.donationId
                : donationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            denialReason: freezed == denialReason
                ? _value.denialReason
                : denialReason // ignore: cast_nullable_to_non_nullable
                      as String?,
            reviewedBy: freezed == reviewedBy
                ? _value.reviewedBy
                : reviewedBy // ignore: cast_nullable_to_non_nullable
                      as String?,
            reviewedAt: freezed == reviewedAt
                ? _value.reviewedAt
                : reviewedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            convertedDonationId: freezed == convertedDonationId
                ? _value.convertedDonationId
                : convertedDonationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NGORequestImplCopyWith<$Res>
    implements $NGORequestCopyWith<$Res> {
  factory _$$NGORequestImplCopyWith(
    _$NGORequestImpl value,
    $Res Function(_$NGORequestImpl) then,
  ) = __$$NGORequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: '\$id') String id,
    @JsonKey(name: 'recipient_id') String ngoId,
    @JsonKey(name: 'ngo_name') String ngoName,
    String title,
    String description,
    @FoodCategoryConverter()
    @JsonKey(name: 'food_category')
    FoodCategory foodCategory,
    double quantity,
    String unit,
    @JsonKey(name: 'delivery_address') String deliveryAddress,
    @JsonKey(name: 'needed_by') DateTime neededBy,
    NGORequestStatus status,
    @JsonKey(name: 'donation_id') String? donationId,
    @JsonKey(name: 'denial_reason') String? denialReason,
    @JsonKey(name: 'reviewed_by') String? reviewedBy,
    @JsonKey(name: 'reviewed_at') DateTime? reviewedAt,
    @JsonKey(name: 'converted_donation_id') String? convertedDonationId,
    @JsonKey(name: '\$createdAt') DateTime? createdAt,
    @JsonKey(name: '\$updatedAt') DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$NGORequestImplCopyWithImpl<$Res>
    extends _$NGORequestCopyWithImpl<$Res, _$NGORequestImpl>
    implements _$$NGORequestImplCopyWith<$Res> {
  __$$NGORequestImplCopyWithImpl(
    _$NGORequestImpl _value,
    $Res Function(_$NGORequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NGORequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ngoId = null,
    Object? ngoName = null,
    Object? title = null,
    Object? description = null,
    Object? foodCategory = null,
    Object? quantity = null,
    Object? unit = null,
    Object? deliveryAddress = null,
    Object? neededBy = null,
    Object? status = null,
    Object? donationId = freezed,
    Object? denialReason = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? convertedDonationId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$NGORequestImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ngoId: null == ngoId
            ? _value.ngoId
            : ngoId // ignore: cast_nullable_to_non_nullable
                  as String,
        ngoName: null == ngoName
            ? _value.ngoName
            : ngoName // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        foodCategory: null == foodCategory
            ? _value.foodCategory
            : foodCategory // ignore: cast_nullable_to_non_nullable
                  as FoodCategory,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryAddress: null == deliveryAddress
            ? _value.deliveryAddress
            : deliveryAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        neededBy: null == neededBy
            ? _value.neededBy
            : neededBy // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as NGORequestStatus,
        donationId: freezed == donationId
            ? _value.donationId
            : donationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        denialReason: freezed == denialReason
            ? _value.denialReason
            : denialReason // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewedBy: freezed == reviewedBy
            ? _value.reviewedBy
            : reviewedBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        reviewedAt: freezed == reviewedAt
            ? _value.reviewedAt
            : reviewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        convertedDonationId: freezed == convertedDonationId
            ? _value.convertedDonationId
            : convertedDonationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NGORequestImpl implements _NGORequest {
  const _$NGORequestImpl({
    @JsonKey(name: '\$id') required this.id,
    @JsonKey(name: 'recipient_id') required this.ngoId,
    @JsonKey(name: 'ngo_name') required this.ngoName,
    required this.title,
    required this.description,
    @FoodCategoryConverter()
    @JsonKey(name: 'food_category')
    required this.foodCategory,
    required this.quantity,
    required this.unit,
    @JsonKey(name: 'delivery_address') required this.deliveryAddress,
    @JsonKey(name: 'needed_by') required this.neededBy,
    required this.status,
    @JsonKey(name: 'donation_id') this.donationId,
    @JsonKey(name: 'denial_reason') this.denialReason,
    @JsonKey(name: 'reviewed_by') this.reviewedBy,
    @JsonKey(name: 'reviewed_at') this.reviewedAt,
    @JsonKey(name: 'converted_donation_id') this.convertedDonationId,
    @JsonKey(name: '\$createdAt') this.createdAt,
    @JsonKey(name: '\$updatedAt') this.updatedAt,
    final Map<String, dynamic>? metadata,
  }) : _metadata = metadata;

  factory _$NGORequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$NGORequestImplFromJson(json);

  @override
  @JsonKey(name: '\$id')
  final String id;
  @override
  @JsonKey(name: 'recipient_id')
  final String ngoId;
  @override
  @JsonKey(name: 'ngo_name')
  final String ngoName;
  @override
  final String title;
  @override
  final String description;
  @override
  @FoodCategoryConverter()
  @JsonKey(name: 'food_category')
  final FoodCategory foodCategory;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  @JsonKey(name: 'delivery_address')
  final String deliveryAddress;
  @override
  @JsonKey(name: 'needed_by')
  final DateTime neededBy;
  @override
  final NGORequestStatus status;
  @override
  @JsonKey(name: 'donation_id')
  final String? donationId;
  // Link to specific donation being requested
  @override
  @JsonKey(name: 'denial_reason')
  final String? denialReason;
  @override
  @JsonKey(name: 'reviewed_by')
  final String? reviewedBy;
  @override
  @JsonKey(name: 'reviewed_at')
  final DateTime? reviewedAt;
  @override
  @JsonKey(name: 'converted_donation_id')
  final String? convertedDonationId;
  @override
  @JsonKey(name: '\$createdAt')
  final DateTime? createdAt;
  @override
  @JsonKey(name: '\$updatedAt')
  final DateTime? updatedAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NGORequest(id: $id, ngoId: $ngoId, ngoName: $ngoName, title: $title, description: $description, foodCategory: $foodCategory, quantity: $quantity, unit: $unit, deliveryAddress: $deliveryAddress, neededBy: $neededBy, status: $status, donationId: $donationId, denialReason: $denialReason, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, convertedDonationId: $convertedDonationId, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NGORequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ngoId, ngoId) || other.ngoId == ngoId) &&
            (identical(other.ngoName, ngoName) || other.ngoName == ngoName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.foodCategory, foodCategory) ||
                other.foodCategory == foodCategory) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.neededBy, neededBy) ||
                other.neededBy == neededBy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.donationId, donationId) ||
                other.donationId == donationId) &&
            (identical(other.denialReason, denialReason) ||
                other.denialReason == denialReason) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.convertedDonationId, convertedDonationId) ||
                other.convertedDonationId == convertedDonationId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    ngoId,
    ngoName,
    title,
    description,
    foodCategory,
    quantity,
    unit,
    deliveryAddress,
    neededBy,
    status,
    donationId,
    denialReason,
    reviewedBy,
    reviewedAt,
    convertedDonationId,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_metadata),
  ]);

  /// Create a copy of NGORequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NGORequestImplCopyWith<_$NGORequestImpl> get copyWith =>
      __$$NGORequestImplCopyWithImpl<_$NGORequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NGORequestImplToJson(this);
  }
}

abstract class _NGORequest implements NGORequest {
  const factory _NGORequest({
    @JsonKey(name: '\$id') required final String id,
    @JsonKey(name: 'recipient_id') required final String ngoId,
    @JsonKey(name: 'ngo_name') required final String ngoName,
    required final String title,
    required final String description,
    @FoodCategoryConverter()
    @JsonKey(name: 'food_category')
    required final FoodCategory foodCategory,
    required final double quantity,
    required final String unit,
    @JsonKey(name: 'delivery_address') required final String deliveryAddress,
    @JsonKey(name: 'needed_by') required final DateTime neededBy,
    required final NGORequestStatus status,
    @JsonKey(name: 'donation_id') final String? donationId,
    @JsonKey(name: 'denial_reason') final String? denialReason,
    @JsonKey(name: 'reviewed_by') final String? reviewedBy,
    @JsonKey(name: 'reviewed_at') final DateTime? reviewedAt,
    @JsonKey(name: 'converted_donation_id') final String? convertedDonationId,
    @JsonKey(name: '\$createdAt') final DateTime? createdAt,
    @JsonKey(name: '\$updatedAt') final DateTime? updatedAt,
    final Map<String, dynamic>? metadata,
  }) = _$NGORequestImpl;

  factory _NGORequest.fromJson(Map<String, dynamic> json) =
      _$NGORequestImpl.fromJson;

  @override
  @JsonKey(name: '\$id')
  String get id;
  @override
  @JsonKey(name: 'recipient_id')
  String get ngoId;
  @override
  @JsonKey(name: 'ngo_name')
  String get ngoName;
  @override
  String get title;
  @override
  String get description;
  @override
  @FoodCategoryConverter()
  @JsonKey(name: 'food_category')
  FoodCategory get foodCategory;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  @JsonKey(name: 'delivery_address')
  String get deliveryAddress;
  @override
  @JsonKey(name: 'needed_by')
  DateTime get neededBy;
  @override
  NGORequestStatus get status;
  @override
  @JsonKey(name: 'donation_id')
  String? get donationId; // Link to specific donation being requested
  @override
  @JsonKey(name: 'denial_reason')
  String? get denialReason;
  @override
  @JsonKey(name: 'reviewed_by')
  String? get reviewedBy;
  @override
  @JsonKey(name: 'reviewed_at')
  DateTime? get reviewedAt;
  @override
  @JsonKey(name: 'converted_donation_id')
  String? get convertedDonationId;
  @override
  @JsonKey(name: '\$createdAt')
  DateTime? get createdAt;
  @override
  @JsonKey(name: '\$updatedAt')
  DateTime? get updatedAt;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of NGORequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NGORequestImplCopyWith<_$NGORequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
