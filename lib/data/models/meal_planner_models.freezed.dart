// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_planner_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserDietaryProfile _$UserDietaryProfileFromJson(Map<String, dynamic> json) {
  return _UserDietaryProfile.fromJson(json);
}

/// @nodoc
mixin _$UserDietaryProfile {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'household_size')
  int get householdSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'dietary_preferences')
  List<String> get dietaryPreferences => throw _privateConstructorUsedError;
  List<String> get allergies => throw _privateConstructorUsedError;
  @JsonKey(name: 'health_conditions')
  List<String> get healthConditions => throw _privateConstructorUsedError;
  @JsonKey(name: 'cultural_preferences')
  List<String> get culturalPreferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_range')
  String? get budgetRange => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferred_language')
  String get preferredLanguage => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserDietaryProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDietaryProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDietaryProfileCopyWith<UserDietaryProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDietaryProfileCopyWith<$Res> {
  factory $UserDietaryProfileCopyWith(
    UserDietaryProfile value,
    $Res Function(UserDietaryProfile) then,
  ) = _$UserDietaryProfileCopyWithImpl<$Res, UserDietaryProfile>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'household_size') int householdSize,
    @JsonKey(name: 'dietary_preferences') List<String> dietaryPreferences,
    List<String> allergies,
    @JsonKey(name: 'health_conditions') List<String> healthConditions,
    @JsonKey(name: 'cultural_preferences') List<String> culturalPreferences,
    @JsonKey(name: 'budget_range') String? budgetRange,
    @JsonKey(name: 'preferred_language') String preferredLanguage,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$UserDietaryProfileCopyWithImpl<$Res, $Val extends UserDietaryProfile>
    implements $UserDietaryProfileCopyWith<$Res> {
  _$UserDietaryProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDietaryProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? householdSize = null,
    Object? dietaryPreferences = null,
    Object? allergies = null,
    Object? healthConditions = null,
    Object? culturalPreferences = null,
    Object? budgetRange = freezed,
    Object? preferredLanguage = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            householdSize: null == householdSize
                ? _value.householdSize
                : householdSize // ignore: cast_nullable_to_non_nullable
                      as int,
            dietaryPreferences: null == dietaryPreferences
                ? _value.dietaryPreferences
                : dietaryPreferences // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            allergies: null == allergies
                ? _value.allergies
                : allergies // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            healthConditions: null == healthConditions
                ? _value.healthConditions
                : healthConditions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            culturalPreferences: null == culturalPreferences
                ? _value.culturalPreferences
                : culturalPreferences // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            budgetRange: freezed == budgetRange
                ? _value.budgetRange
                : budgetRange // ignore: cast_nullable_to_non_nullable
                      as String?,
            preferredLanguage: null == preferredLanguage
                ? _value.preferredLanguage
                : preferredLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserDietaryProfileImplCopyWith<$Res>
    implements $UserDietaryProfileCopyWith<$Res> {
  factory _$$UserDietaryProfileImplCopyWith(
    _$UserDietaryProfileImpl value,
    $Res Function(_$UserDietaryProfileImpl) then,
  ) = __$$UserDietaryProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'household_size') int householdSize,
    @JsonKey(name: 'dietary_preferences') List<String> dietaryPreferences,
    List<String> allergies,
    @JsonKey(name: 'health_conditions') List<String> healthConditions,
    @JsonKey(name: 'cultural_preferences') List<String> culturalPreferences,
    @JsonKey(name: 'budget_range') String? budgetRange,
    @JsonKey(name: 'preferred_language') String preferredLanguage,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$UserDietaryProfileImplCopyWithImpl<$Res>
    extends _$UserDietaryProfileCopyWithImpl<$Res, _$UserDietaryProfileImpl>
    implements _$$UserDietaryProfileImplCopyWith<$Res> {
  __$$UserDietaryProfileImplCopyWithImpl(
    _$UserDietaryProfileImpl _value,
    $Res Function(_$UserDietaryProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDietaryProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? householdSize = null,
    Object? dietaryPreferences = null,
    Object? allergies = null,
    Object? healthConditions = null,
    Object? culturalPreferences = null,
    Object? budgetRange = freezed,
    Object? preferredLanguage = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$UserDietaryProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        householdSize: null == householdSize
            ? _value.householdSize
            : householdSize // ignore: cast_nullable_to_non_nullable
                  as int,
        dietaryPreferences: null == dietaryPreferences
            ? _value._dietaryPreferences
            : dietaryPreferences // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        allergies: null == allergies
            ? _value._allergies
            : allergies // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        healthConditions: null == healthConditions
            ? _value._healthConditions
            : healthConditions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        culturalPreferences: null == culturalPreferences
            ? _value._culturalPreferences
            : culturalPreferences // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        budgetRange: freezed == budgetRange
            ? _value.budgetRange
            : budgetRange // ignore: cast_nullable_to_non_nullable
                  as String?,
        preferredLanguage: null == preferredLanguage
            ? _value.preferredLanguage
            : preferredLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDietaryProfileImpl implements _UserDietaryProfile {
  const _$UserDietaryProfileImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'household_size') this.householdSize = 1,
    @JsonKey(name: 'dietary_preferences')
    final List<String> dietaryPreferences = const [],
    final List<String> allergies = const [],
    @JsonKey(name: 'health_conditions')
    final List<String> healthConditions = const [],
    @JsonKey(name: 'cultural_preferences')
    final List<String> culturalPreferences = const [],
    @JsonKey(name: 'budget_range') this.budgetRange,
    @JsonKey(name: 'preferred_language') this.preferredLanguage = 'English',
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _dietaryPreferences = dietaryPreferences,
       _allergies = allergies,
       _healthConditions = healthConditions,
       _culturalPreferences = culturalPreferences;

  factory _$UserDietaryProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDietaryProfileImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'household_size')
  final int householdSize;
  final List<String> _dietaryPreferences;
  @override
  @JsonKey(name: 'dietary_preferences')
  List<String> get dietaryPreferences {
    if (_dietaryPreferences is EqualUnmodifiableListView)
      return _dietaryPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryPreferences);
  }

  final List<String> _allergies;
  @override
  @JsonKey()
  List<String> get allergies {
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  final List<String> _healthConditions;
  @override
  @JsonKey(name: 'health_conditions')
  List<String> get healthConditions {
    if (_healthConditions is EqualUnmodifiableListView)
      return _healthConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthConditions);
  }

  final List<String> _culturalPreferences;
  @override
  @JsonKey(name: 'cultural_preferences')
  List<String> get culturalPreferences {
    if (_culturalPreferences is EqualUnmodifiableListView)
      return _culturalPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_culturalPreferences);
  }

  @override
  @JsonKey(name: 'budget_range')
  final String? budgetRange;
  @override
  @JsonKey(name: 'preferred_language')
  final String preferredLanguage;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserDietaryProfile(id: $id, userId: $userId, householdSize: $householdSize, dietaryPreferences: $dietaryPreferences, allergies: $allergies, healthConditions: $healthConditions, culturalPreferences: $culturalPreferences, budgetRange: $budgetRange, preferredLanguage: $preferredLanguage, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDietaryProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.householdSize, householdSize) ||
                other.householdSize == householdSize) &&
            const DeepCollectionEquality().equals(
              other._dietaryPreferences,
              _dietaryPreferences,
            ) &&
            const DeepCollectionEquality().equals(
              other._allergies,
              _allergies,
            ) &&
            const DeepCollectionEquality().equals(
              other._healthConditions,
              _healthConditions,
            ) &&
            const DeepCollectionEquality().equals(
              other._culturalPreferences,
              _culturalPreferences,
            ) &&
            (identical(other.budgetRange, budgetRange) ||
                other.budgetRange == budgetRange) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                other.preferredLanguage == preferredLanguage) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    householdSize,
    const DeepCollectionEquality().hash(_dietaryPreferences),
    const DeepCollectionEquality().hash(_allergies),
    const DeepCollectionEquality().hash(_healthConditions),
    const DeepCollectionEquality().hash(_culturalPreferences),
    budgetRange,
    preferredLanguage,
    createdAt,
    updatedAt,
  );

  /// Create a copy of UserDietaryProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDietaryProfileImplCopyWith<_$UserDietaryProfileImpl> get copyWith =>
      __$$UserDietaryProfileImplCopyWithImpl<_$UserDietaryProfileImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDietaryProfileImplToJson(this);
  }
}

abstract class _UserDietaryProfile implements UserDietaryProfile {
  const factory _UserDietaryProfile({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'household_size') final int householdSize,
    @JsonKey(name: 'dietary_preferences') final List<String> dietaryPreferences,
    final List<String> allergies,
    @JsonKey(name: 'health_conditions') final List<String> healthConditions,
    @JsonKey(name: 'cultural_preferences')
    final List<String> culturalPreferences,
    @JsonKey(name: 'budget_range') final String? budgetRange,
    @JsonKey(name: 'preferred_language') final String preferredLanguage,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$UserDietaryProfileImpl;

  factory _UserDietaryProfile.fromJson(Map<String, dynamic> json) =
      _$UserDietaryProfileImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'household_size')
  int get householdSize;
  @override
  @JsonKey(name: 'dietary_preferences')
  List<String> get dietaryPreferences;
  @override
  List<String> get allergies;
  @override
  @JsonKey(name: 'health_conditions')
  List<String> get healthConditions;
  @override
  @JsonKey(name: 'cultural_preferences')
  List<String> get culturalPreferences;
  @override
  @JsonKey(name: 'budget_range')
  String? get budgetRange;
  @override
  @JsonKey(name: 'preferred_language')
  String get preferredLanguage;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of UserDietaryProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDietaryProfileImplCopyWith<_$UserDietaryProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealPlan _$MealPlanFromJson(Map<String, dynamic> json) {
  return _MealPlan.fromJson(json);
}

/// @nodoc
mixin _$MealPlan {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'plan_type')
  String get planType => throw _privateConstructorUsedError; // 'daily', 'weekly', 'monthly'
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_calories')
  int? get totalCalories => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_protein')
  double? get totalProtein => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_carbs')
  double? get totalCarbs => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_fat')
  double? get totalFat => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_fiber')
  double? get totalFiber => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MealPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlanCopyWith<MealPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanCopyWith<$Res> {
  factory $MealPlanCopyWith(MealPlan value, $Res Function(MealPlan) then) =
      _$MealPlanCopyWithImpl<$Res, MealPlan>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String title,
    String? description,
    @JsonKey(name: 'plan_type') String planType,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime endDate,
    @JsonKey(name: 'total_calories') int? totalCalories,
    @JsonKey(name: 'total_protein') double? totalProtein,
    @JsonKey(name: 'total_carbs') double? totalCarbs,
    @JsonKey(name: 'total_fat') double? totalFat,
    @JsonKey(name: 'total_fiber') double? totalFiber,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$MealPlanCopyWithImpl<$Res, $Val extends MealPlan>
    implements $MealPlanCopyWith<$Res> {
  _$MealPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? planType = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalCalories = freezed,
    Object? totalProtein = freezed,
    Object? totalCarbs = freezed,
    Object? totalFat = freezed,
    Object? totalFiber = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            planType: null == planType
                ? _value.planType
                : planType // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            totalCalories: freezed == totalCalories
                ? _value.totalCalories
                : totalCalories // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalProtein: freezed == totalProtein
                ? _value.totalProtein
                : totalProtein // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalCarbs: freezed == totalCarbs
                ? _value.totalCarbs
                : totalCarbs // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalFat: freezed == totalFat
                ? _value.totalFat
                : totalFat // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalFiber: freezed == totalFiber
                ? _value.totalFiber
                : totalFiber // ignore: cast_nullable_to_non_nullable
                      as double?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealPlanImplCopyWith<$Res>
    implements $MealPlanCopyWith<$Res> {
  factory _$$MealPlanImplCopyWith(
    _$MealPlanImpl value,
    $Res Function(_$MealPlanImpl) then,
  ) = __$$MealPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    String title,
    String? description,
    @JsonKey(name: 'plan_type') String planType,
    @JsonKey(name: 'start_date') DateTime startDate,
    @JsonKey(name: 'end_date') DateTime endDate,
    @JsonKey(name: 'total_calories') int? totalCalories,
    @JsonKey(name: 'total_protein') double? totalProtein,
    @JsonKey(name: 'total_carbs') double? totalCarbs,
    @JsonKey(name: 'total_fat') double? totalFat,
    @JsonKey(name: 'total_fiber') double? totalFiber,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$MealPlanImplCopyWithImpl<$Res>
    extends _$MealPlanCopyWithImpl<$Res, _$MealPlanImpl>
    implements _$$MealPlanImplCopyWith<$Res> {
  __$$MealPlanImplCopyWithImpl(
    _$MealPlanImpl _value,
    $Res Function(_$MealPlanImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? description = freezed,
    Object? planType = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? totalCalories = freezed,
    Object? totalProtein = freezed,
    Object? totalCarbs = freezed,
    Object? totalFat = freezed,
    Object? totalFiber = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MealPlanImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        planType: null == planType
            ? _value.planType
            : planType // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        totalCalories: freezed == totalCalories
            ? _value.totalCalories
            : totalCalories // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalProtein: freezed == totalProtein
            ? _value.totalProtein
            : totalProtein // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalCarbs: freezed == totalCarbs
            ? _value.totalCarbs
            : totalCarbs // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalFat: freezed == totalFat
            ? _value.totalFat
            : totalFat // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalFiber: freezed == totalFiber
            ? _value.totalFiber
            : totalFiber // ignore: cast_nullable_to_non_nullable
                  as double?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlanImpl implements _MealPlan {
  const _$MealPlanImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    required this.title,
    this.description,
    @JsonKey(name: 'plan_type') required this.planType,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'end_date') required this.endDate,
    @JsonKey(name: 'total_calories') this.totalCalories,
    @JsonKey(name: 'total_protein') this.totalProtein,
    @JsonKey(name: 'total_carbs') this.totalCarbs,
    @JsonKey(name: 'total_fat') this.totalFat,
    @JsonKey(name: 'total_fiber') this.totalFiber,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$MealPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlanImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'plan_type')
  final String planType;
  // 'daily', 'weekly', 'monthly'
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime endDate;
  @override
  @JsonKey(name: 'total_calories')
  final int? totalCalories;
  @override
  @JsonKey(name: 'total_protein')
  final double? totalProtein;
  @override
  @JsonKey(name: 'total_carbs')
  final double? totalCarbs;
  @override
  @JsonKey(name: 'total_fat')
  final double? totalFat;
  @override
  @JsonKey(name: 'total_fiber')
  final double? totalFiber;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MealPlan(id: $id, userId: $userId, title: $title, description: $description, planType: $planType, startDate: $startDate, endDate: $endDate, totalCalories: $totalCalories, totalProtein: $totalProtein, totalCarbs: $totalCarbs, totalFat: $totalFat, totalFiber: $totalFiber, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.planType, planType) ||
                other.planType == planType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.totalProtein, totalProtein) ||
                other.totalProtein == totalProtein) &&
            (identical(other.totalCarbs, totalCarbs) ||
                other.totalCarbs == totalCarbs) &&
            (identical(other.totalFat, totalFat) ||
                other.totalFat == totalFat) &&
            (identical(other.totalFiber, totalFiber) ||
                other.totalFiber == totalFiber) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    title,
    description,
    planType,
    startDate,
    endDate,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFat,
    totalFiber,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanImplCopyWith<_$MealPlanImpl> get copyWith =>
      __$$MealPlanImplCopyWithImpl<_$MealPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanImplToJson(this);
  }
}

abstract class _MealPlan implements MealPlan {
  const factory _MealPlan({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    required final String title,
    final String? description,
    @JsonKey(name: 'plan_type') required final String planType,
    @JsonKey(name: 'start_date') required final DateTime startDate,
    @JsonKey(name: 'end_date') required final DateTime endDate,
    @JsonKey(name: 'total_calories') final int? totalCalories,
    @JsonKey(name: 'total_protein') final double? totalProtein,
    @JsonKey(name: 'total_carbs') final double? totalCarbs,
    @JsonKey(name: 'total_fat') final double? totalFat,
    @JsonKey(name: 'total_fiber') final double? totalFiber,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$MealPlanImpl;

  factory _MealPlan.fromJson(Map<String, dynamic> json) =
      _$MealPlanImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'plan_type')
  String get planType; // 'daily', 'weekly', 'monthly'
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime get endDate;
  @override
  @JsonKey(name: 'total_calories')
  int? get totalCalories;
  @override
  @JsonKey(name: 'total_protein')
  double? get totalProtein;
  @override
  @JsonKey(name: 'total_carbs')
  double? get totalCarbs;
  @override
  @JsonKey(name: 'total_fat')
  double? get totalFat;
  @override
  @JsonKey(name: 'total_fiber')
  double? get totalFiber;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of MealPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlanImplCopyWith<_$MealPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealIngredient _$MealIngredientFromJson(Map<String, dynamic> json) {
  return _MealIngredient.fromJson(json);
}

/// @nodoc
mixin _$MealIngredient {
  String get name => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_donation')
  bool get fromDonation => throw _privateConstructorUsedError;

  /// Serializes this MealIngredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealIngredientCopyWith<MealIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealIngredientCopyWith<$Res> {
  factory $MealIngredientCopyWith(
    MealIngredient value,
    $Res Function(MealIngredient) then,
  ) = _$MealIngredientCopyWithImpl<$Res, MealIngredient>;
  @useResult
  $Res call({
    String name,
    double quantity,
    String unit,
    @JsonKey(name: 'from_donation') bool fromDonation,
  });
}

/// @nodoc
class _$MealIngredientCopyWithImpl<$Res, $Val extends MealIngredient>
    implements $MealIngredientCopyWith<$Res> {
  _$MealIngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? fromDonation = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            fromDonation: null == fromDonation
                ? _value.fromDonation
                : fromDonation // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealIngredientImplCopyWith<$Res>
    implements $MealIngredientCopyWith<$Res> {
  factory _$$MealIngredientImplCopyWith(
    _$MealIngredientImpl value,
    $Res Function(_$MealIngredientImpl) then,
  ) = __$$MealIngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    double quantity,
    String unit,
    @JsonKey(name: 'from_donation') bool fromDonation,
  });
}

/// @nodoc
class __$$MealIngredientImplCopyWithImpl<$Res>
    extends _$MealIngredientCopyWithImpl<$Res, _$MealIngredientImpl>
    implements _$$MealIngredientImplCopyWith<$Res> {
  __$$MealIngredientImplCopyWithImpl(
    _$MealIngredientImpl _value,
    $Res Function(_$MealIngredientImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? unit = null,
    Object? fromDonation = null,
  }) {
    return _then(
      _$MealIngredientImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        fromDonation: null == fromDonation
            ? _value.fromDonation
            : fromDonation // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealIngredientImpl implements _MealIngredient {
  const _$MealIngredientImpl({
    required this.name,
    required this.quantity,
    required this.unit,
    @JsonKey(name: 'from_donation') this.fromDonation = false,
  });

  factory _$MealIngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealIngredientImplFromJson(json);

  @override
  final String name;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  @JsonKey(name: 'from_donation')
  final bool fromDonation;

  @override
  String toString() {
    return 'MealIngredient(name: $name, quantity: $quantity, unit: $unit, fromDonation: $fromDonation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealIngredientImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.fromDonation, fromDonation) ||
                other.fromDonation == fromDonation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, quantity, unit, fromDonation);

  /// Create a copy of MealIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealIngredientImplCopyWith<_$MealIngredientImpl> get copyWith =>
      __$$MealIngredientImplCopyWithImpl<_$MealIngredientImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MealIngredientImplToJson(this);
  }
}

abstract class _MealIngredient implements MealIngredient {
  const factory _MealIngredient({
    required final String name,
    required final double quantity,
    required final String unit,
    @JsonKey(name: 'from_donation') final bool fromDonation,
  }) = _$MealIngredientImpl;

  factory _MealIngredient.fromJson(Map<String, dynamic> json) =
      _$MealIngredientImpl.fromJson;

  @override
  String get name;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  @JsonKey(name: 'from_donation')
  bool get fromDonation;

  /// Create a copy of MealIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealIngredientImplCopyWith<_$MealIngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VitaminsMinerals _$VitaminsMineralsFromJson(Map<String, dynamic> json) {
  return _VitaminsMinerals.fromJson(json);
}

/// @nodoc
mixin _$VitaminsMinerals {
  @JsonKey(name: 'vitamin_a')
  double? get vitaminA => throw _privateConstructorUsedError;
  @JsonKey(name: 'vitamin_c')
  double? get vitaminC => throw _privateConstructorUsedError;
  @JsonKey(name: 'vitamin_d')
  double? get vitaminD => throw _privateConstructorUsedError;
  double? get calcium => throw _privateConstructorUsedError;
  double? get iron => throw _privateConstructorUsedError;
  double? get potassium => throw _privateConstructorUsedError;
  double? get sodium => throw _privateConstructorUsedError;

  /// Serializes this VitaminsMinerals to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VitaminsMinerals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VitaminsMineralsCopyWith<VitaminsMinerals> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VitaminsMineralsCopyWith<$Res> {
  factory $VitaminsMineralsCopyWith(
    VitaminsMinerals value,
    $Res Function(VitaminsMinerals) then,
  ) = _$VitaminsMineralsCopyWithImpl<$Res, VitaminsMinerals>;
  @useResult
  $Res call({
    @JsonKey(name: 'vitamin_a') double? vitaminA,
    @JsonKey(name: 'vitamin_c') double? vitaminC,
    @JsonKey(name: 'vitamin_d') double? vitaminD,
    double? calcium,
    double? iron,
    double? potassium,
    double? sodium,
  });
}

/// @nodoc
class _$VitaminsMineralsCopyWithImpl<$Res, $Val extends VitaminsMinerals>
    implements $VitaminsMineralsCopyWith<$Res> {
  _$VitaminsMineralsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VitaminsMinerals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vitaminA = freezed,
    Object? vitaminC = freezed,
    Object? vitaminD = freezed,
    Object? calcium = freezed,
    Object? iron = freezed,
    Object? potassium = freezed,
    Object? sodium = freezed,
  }) {
    return _then(
      _value.copyWith(
            vitaminA: freezed == vitaminA
                ? _value.vitaminA
                : vitaminA // ignore: cast_nullable_to_non_nullable
                      as double?,
            vitaminC: freezed == vitaminC
                ? _value.vitaminC
                : vitaminC // ignore: cast_nullable_to_non_nullable
                      as double?,
            vitaminD: freezed == vitaminD
                ? _value.vitaminD
                : vitaminD // ignore: cast_nullable_to_non_nullable
                      as double?,
            calcium: freezed == calcium
                ? _value.calcium
                : calcium // ignore: cast_nullable_to_non_nullable
                      as double?,
            iron: freezed == iron
                ? _value.iron
                : iron // ignore: cast_nullable_to_non_nullable
                      as double?,
            potassium: freezed == potassium
                ? _value.potassium
                : potassium // ignore: cast_nullable_to_non_nullable
                      as double?,
            sodium: freezed == sodium
                ? _value.sodium
                : sodium // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VitaminsMineralsImplCopyWith<$Res>
    implements $VitaminsMineralsCopyWith<$Res> {
  factory _$$VitaminsMineralsImplCopyWith(
    _$VitaminsMineralsImpl value,
    $Res Function(_$VitaminsMineralsImpl) then,
  ) = __$$VitaminsMineralsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'vitamin_a') double? vitaminA,
    @JsonKey(name: 'vitamin_c') double? vitaminC,
    @JsonKey(name: 'vitamin_d') double? vitaminD,
    double? calcium,
    double? iron,
    double? potassium,
    double? sodium,
  });
}

/// @nodoc
class __$$VitaminsMineralsImplCopyWithImpl<$Res>
    extends _$VitaminsMineralsCopyWithImpl<$Res, _$VitaminsMineralsImpl>
    implements _$$VitaminsMineralsImplCopyWith<$Res> {
  __$$VitaminsMineralsImplCopyWithImpl(
    _$VitaminsMineralsImpl _value,
    $Res Function(_$VitaminsMineralsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VitaminsMinerals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vitaminA = freezed,
    Object? vitaminC = freezed,
    Object? vitaminD = freezed,
    Object? calcium = freezed,
    Object? iron = freezed,
    Object? potassium = freezed,
    Object? sodium = freezed,
  }) {
    return _then(
      _$VitaminsMineralsImpl(
        vitaminA: freezed == vitaminA
            ? _value.vitaminA
            : vitaminA // ignore: cast_nullable_to_non_nullable
                  as double?,
        vitaminC: freezed == vitaminC
            ? _value.vitaminC
            : vitaminC // ignore: cast_nullable_to_non_nullable
                  as double?,
        vitaminD: freezed == vitaminD
            ? _value.vitaminD
            : vitaminD // ignore: cast_nullable_to_non_nullable
                  as double?,
        calcium: freezed == calcium
            ? _value.calcium
            : calcium // ignore: cast_nullable_to_non_nullable
                  as double?,
        iron: freezed == iron
            ? _value.iron
            : iron // ignore: cast_nullable_to_non_nullable
                  as double?,
        potassium: freezed == potassium
            ? _value.potassium
            : potassium // ignore: cast_nullable_to_non_nullable
                  as double?,
        sodium: freezed == sodium
            ? _value.sodium
            : sodium // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VitaminsMineralsImpl implements _VitaminsMinerals {
  const _$VitaminsMineralsImpl({
    @JsonKey(name: 'vitamin_a') this.vitaminA,
    @JsonKey(name: 'vitamin_c') this.vitaminC,
    @JsonKey(name: 'vitamin_d') this.vitaminD,
    this.calcium,
    this.iron,
    this.potassium,
    this.sodium,
  });

  factory _$VitaminsMineralsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VitaminsMineralsImplFromJson(json);

  @override
  @JsonKey(name: 'vitamin_a')
  final double? vitaminA;
  @override
  @JsonKey(name: 'vitamin_c')
  final double? vitaminC;
  @override
  @JsonKey(name: 'vitamin_d')
  final double? vitaminD;
  @override
  final double? calcium;
  @override
  final double? iron;
  @override
  final double? potassium;
  @override
  final double? sodium;

  @override
  String toString() {
    return 'VitaminsMinerals(vitaminA: $vitaminA, vitaminC: $vitaminC, vitaminD: $vitaminD, calcium: $calcium, iron: $iron, potassium: $potassium, sodium: $sodium)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VitaminsMineralsImpl &&
            (identical(other.vitaminA, vitaminA) ||
                other.vitaminA == vitaminA) &&
            (identical(other.vitaminC, vitaminC) ||
                other.vitaminC == vitaminC) &&
            (identical(other.vitaminD, vitaminD) ||
                other.vitaminD == vitaminD) &&
            (identical(other.calcium, calcium) || other.calcium == calcium) &&
            (identical(other.iron, iron) || other.iron == iron) &&
            (identical(other.potassium, potassium) ||
                other.potassium == potassium) &&
            (identical(other.sodium, sodium) || other.sodium == sodium));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    vitaminA,
    vitaminC,
    vitaminD,
    calcium,
    iron,
    potassium,
    sodium,
  );

  /// Create a copy of VitaminsMinerals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VitaminsMineralsImplCopyWith<_$VitaminsMineralsImpl> get copyWith =>
      __$$VitaminsMineralsImplCopyWithImpl<_$VitaminsMineralsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VitaminsMineralsImplToJson(this);
  }
}

abstract class _VitaminsMinerals implements VitaminsMinerals {
  const factory _VitaminsMinerals({
    @JsonKey(name: 'vitamin_a') final double? vitaminA,
    @JsonKey(name: 'vitamin_c') final double? vitaminC,
    @JsonKey(name: 'vitamin_d') final double? vitaminD,
    final double? calcium,
    final double? iron,
    final double? potassium,
    final double? sodium,
  }) = _$VitaminsMineralsImpl;

  factory _VitaminsMinerals.fromJson(Map<String, dynamic> json) =
      _$VitaminsMineralsImpl.fromJson;

  @override
  @JsonKey(name: 'vitamin_a')
  double? get vitaminA;
  @override
  @JsonKey(name: 'vitamin_c')
  double? get vitaminC;
  @override
  @JsonKey(name: 'vitamin_d')
  double? get vitaminD;
  @override
  double? get calcium;
  @override
  double? get iron;
  @override
  double? get potassium;
  @override
  double? get sodium;

  /// Create a copy of VitaminsMinerals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VitaminsMineralsImplCopyWith<_$VitaminsMineralsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Meal _$MealFromJson(Map<String, dynamic> json) {
  return _Meal.fromJson(json);
}

/// @nodoc
mixin _$Meal {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_plan_id')
  String get mealPlanId => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_type')
  String get mealType => throw _privateConstructorUsedError; // 'breakfast', 'lunch', 'dinner', 'snack'
  @JsonKey(name: 'meal_date')
  DateTime get mealDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_name')
  String get recipeName => throw _privateConstructorUsedError;
  List<MealIngredient> get ingredients => throw _privateConstructorUsedError;
  List<String> get instructions => throw _privateConstructorUsedError;
  @JsonKey(name: 'cooking_time_minutes')
  int? get cookingTimeMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'prep_time_minutes')
  int? get prepTimeMinutes => throw _privateConstructorUsedError;
  int get servings => throw _privateConstructorUsedError;
  int? get calories => throw _privateConstructorUsedError;
  double? get protein => throw _privateConstructorUsedError;
  double? get carbs => throw _privateConstructorUsedError;
  double? get fat => throw _privateConstructorUsedError;
  double? get fiber => throw _privateConstructorUsedError;
  @JsonKey(name: 'vitamins_minerals')
  VitaminsMinerals? get vitaminsMinerals => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipe_image_url')
  String? get recipeImageUrl => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Meal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealCopyWith<Meal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealCopyWith<$Res> {
  factory $MealCopyWith(Meal value, $Res Function(Meal) then) =
      _$MealCopyWithImpl<$Res, Meal>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'meal_plan_id') String mealPlanId,
    @JsonKey(name: 'meal_type') String mealType,
    @JsonKey(name: 'meal_date') DateTime mealDate,
    @JsonKey(name: 'recipe_name') String recipeName,
    List<MealIngredient> ingredients,
    List<String> instructions,
    @JsonKey(name: 'cooking_time_minutes') int? cookingTimeMinutes,
    @JsonKey(name: 'prep_time_minutes') int? prepTimeMinutes,
    int servings,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    @JsonKey(name: 'vitamins_minerals') VitaminsMinerals? vitaminsMinerals,
    @JsonKey(name: 'recipe_image_url') String? recipeImageUrl,
    String? notes,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });

  $VitaminsMineralsCopyWith<$Res>? get vitaminsMinerals;
}

/// @nodoc
class _$MealCopyWithImpl<$Res, $Val extends Meal>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mealPlanId = null,
    Object? mealType = null,
    Object? mealDate = null,
    Object? recipeName = null,
    Object? ingredients = null,
    Object? instructions = null,
    Object? cookingTimeMinutes = freezed,
    Object? prepTimeMinutes = freezed,
    Object? servings = null,
    Object? calories = freezed,
    Object? protein = freezed,
    Object? carbs = freezed,
    Object? fat = freezed,
    Object? fiber = freezed,
    Object? vitaminsMinerals = freezed,
    Object? recipeImageUrl = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            mealPlanId: null == mealPlanId
                ? _value.mealPlanId
                : mealPlanId // ignore: cast_nullable_to_non_nullable
                      as String,
            mealType: null == mealType
                ? _value.mealType
                : mealType // ignore: cast_nullable_to_non_nullable
                      as String,
            mealDate: null == mealDate
                ? _value.mealDate
                : mealDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            recipeName: null == recipeName
                ? _value.recipeName
                : recipeName // ignore: cast_nullable_to_non_nullable
                      as String,
            ingredients: null == ingredients
                ? _value.ingredients
                : ingredients // ignore: cast_nullable_to_non_nullable
                      as List<MealIngredient>,
            instructions: null == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            cookingTimeMinutes: freezed == cookingTimeMinutes
                ? _value.cookingTimeMinutes
                : cookingTimeMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            prepTimeMinutes: freezed == prepTimeMinutes
                ? _value.prepTimeMinutes
                : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            servings: null == servings
                ? _value.servings
                : servings // ignore: cast_nullable_to_non_nullable
                      as int,
            calories: freezed == calories
                ? _value.calories
                : calories // ignore: cast_nullable_to_non_nullable
                      as int?,
            protein: freezed == protein
                ? _value.protein
                : protein // ignore: cast_nullable_to_non_nullable
                      as double?,
            carbs: freezed == carbs
                ? _value.carbs
                : carbs // ignore: cast_nullable_to_non_nullable
                      as double?,
            fat: freezed == fat
                ? _value.fat
                : fat // ignore: cast_nullable_to_non_nullable
                      as double?,
            fiber: freezed == fiber
                ? _value.fiber
                : fiber // ignore: cast_nullable_to_non_nullable
                      as double?,
            vitaminsMinerals: freezed == vitaminsMinerals
                ? _value.vitaminsMinerals
                : vitaminsMinerals // ignore: cast_nullable_to_non_nullable
                      as VitaminsMinerals?,
            recipeImageUrl: freezed == recipeImageUrl
                ? _value.recipeImageUrl
                : recipeImageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VitaminsMineralsCopyWith<$Res>? get vitaminsMinerals {
    if (_value.vitaminsMinerals == null) {
      return null;
    }

    return $VitaminsMineralsCopyWith<$Res>(_value.vitaminsMinerals!, (value) {
      return _then(_value.copyWith(vitaminsMinerals: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MealImplCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$$MealImplCopyWith(
    _$MealImpl value,
    $Res Function(_$MealImpl) then,
  ) = __$$MealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'meal_plan_id') String mealPlanId,
    @JsonKey(name: 'meal_type') String mealType,
    @JsonKey(name: 'meal_date') DateTime mealDate,
    @JsonKey(name: 'recipe_name') String recipeName,
    List<MealIngredient> ingredients,
    List<String> instructions,
    @JsonKey(name: 'cooking_time_minutes') int? cookingTimeMinutes,
    @JsonKey(name: 'prep_time_minutes') int? prepTimeMinutes,
    int servings,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    @JsonKey(name: 'vitamins_minerals') VitaminsMinerals? vitaminsMinerals,
    @JsonKey(name: 'recipe_image_url') String? recipeImageUrl,
    String? notes,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });

  @override
  $VitaminsMineralsCopyWith<$Res>? get vitaminsMinerals;
}

/// @nodoc
class __$$MealImplCopyWithImpl<$Res>
    extends _$MealCopyWithImpl<$Res, _$MealImpl>
    implements _$$MealImplCopyWith<$Res> {
  __$$MealImplCopyWithImpl(_$MealImpl _value, $Res Function(_$MealImpl) _then)
    : super(_value, _then);

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mealPlanId = null,
    Object? mealType = null,
    Object? mealDate = null,
    Object? recipeName = null,
    Object? ingredients = null,
    Object? instructions = null,
    Object? cookingTimeMinutes = freezed,
    Object? prepTimeMinutes = freezed,
    Object? servings = null,
    Object? calories = freezed,
    Object? protein = freezed,
    Object? carbs = freezed,
    Object? fat = freezed,
    Object? fiber = freezed,
    Object? vitaminsMinerals = freezed,
    Object? recipeImageUrl = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MealImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        mealPlanId: null == mealPlanId
            ? _value.mealPlanId
            : mealPlanId // ignore: cast_nullable_to_non_nullable
                  as String,
        mealType: null == mealType
            ? _value.mealType
            : mealType // ignore: cast_nullable_to_non_nullable
                  as String,
        mealDate: null == mealDate
            ? _value.mealDate
            : mealDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        recipeName: null == recipeName
            ? _value.recipeName
            : recipeName // ignore: cast_nullable_to_non_nullable
                  as String,
        ingredients: null == ingredients
            ? _value._ingredients
            : ingredients // ignore: cast_nullable_to_non_nullable
                  as List<MealIngredient>,
        instructions: null == instructions
            ? _value._instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        cookingTimeMinutes: freezed == cookingTimeMinutes
            ? _value.cookingTimeMinutes
            : cookingTimeMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        prepTimeMinutes: freezed == prepTimeMinutes
            ? _value.prepTimeMinutes
            : prepTimeMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        servings: null == servings
            ? _value.servings
            : servings // ignore: cast_nullable_to_non_nullable
                  as int,
        calories: freezed == calories
            ? _value.calories
            : calories // ignore: cast_nullable_to_non_nullable
                  as int?,
        protein: freezed == protein
            ? _value.protein
            : protein // ignore: cast_nullable_to_non_nullable
                  as double?,
        carbs: freezed == carbs
            ? _value.carbs
            : carbs // ignore: cast_nullable_to_non_nullable
                  as double?,
        fat: freezed == fat
            ? _value.fat
            : fat // ignore: cast_nullable_to_non_nullable
                  as double?,
        fiber: freezed == fiber
            ? _value.fiber
            : fiber // ignore: cast_nullable_to_non_nullable
                  as double?,
        vitaminsMinerals: freezed == vitaminsMinerals
            ? _value.vitaminsMinerals
            : vitaminsMinerals // ignore: cast_nullable_to_non_nullable
                  as VitaminsMinerals?,
        recipeImageUrl: freezed == recipeImageUrl
            ? _value.recipeImageUrl
            : recipeImageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealImpl implements _Meal {
  const _$MealImpl({
    required this.id,
    @JsonKey(name: 'meal_plan_id') required this.mealPlanId,
    @JsonKey(name: 'meal_type') required this.mealType,
    @JsonKey(name: 'meal_date') required this.mealDate,
    @JsonKey(name: 'recipe_name') required this.recipeName,
    final List<MealIngredient> ingredients = const [],
    final List<String> instructions = const [],
    @JsonKey(name: 'cooking_time_minutes') this.cookingTimeMinutes,
    @JsonKey(name: 'prep_time_minutes') this.prepTimeMinutes,
    this.servings = 1,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
    @JsonKey(name: 'vitamins_minerals') this.vitaminsMinerals,
    @JsonKey(name: 'recipe_image_url') this.recipeImageUrl,
    this.notes,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _ingredients = ingredients,
       _instructions = instructions;

  factory _$MealImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'meal_plan_id')
  final String mealPlanId;
  @override
  @JsonKey(name: 'meal_type')
  final String mealType;
  // 'breakfast', 'lunch', 'dinner', 'snack'
  @override
  @JsonKey(name: 'meal_date')
  final DateTime mealDate;
  @override
  @JsonKey(name: 'recipe_name')
  final String recipeName;
  final List<MealIngredient> _ingredients;
  @override
  @JsonKey()
  List<MealIngredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<String> _instructions;
  @override
  @JsonKey()
  List<String> get instructions {
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructions);
  }

  @override
  @JsonKey(name: 'cooking_time_minutes')
  final int? cookingTimeMinutes;
  @override
  @JsonKey(name: 'prep_time_minutes')
  final int? prepTimeMinutes;
  @override
  @JsonKey()
  final int servings;
  @override
  final int? calories;
  @override
  final double? protein;
  @override
  final double? carbs;
  @override
  final double? fat;
  @override
  final double? fiber;
  @override
  @JsonKey(name: 'vitamins_minerals')
  final VitaminsMinerals? vitaminsMinerals;
  @override
  @JsonKey(name: 'recipe_image_url')
  final String? recipeImageUrl;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Meal(id: $id, mealPlanId: $mealPlanId, mealType: $mealType, mealDate: $mealDate, recipeName: $recipeName, ingredients: $ingredients, instructions: $instructions, cookingTimeMinutes: $cookingTimeMinutes, prepTimeMinutes: $prepTimeMinutes, servings: $servings, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, fiber: $fiber, vitaminsMinerals: $vitaminsMinerals, recipeImageUrl: $recipeImageUrl, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mealPlanId, mealPlanId) ||
                other.mealPlanId == mealPlanId) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.mealDate, mealDate) ||
                other.mealDate == mealDate) &&
            (identical(other.recipeName, recipeName) ||
                other.recipeName == recipeName) &&
            const DeepCollectionEquality().equals(
              other._ingredients,
              _ingredients,
            ) &&
            const DeepCollectionEquality().equals(
              other._instructions,
              _instructions,
            ) &&
            (identical(other.cookingTimeMinutes, cookingTimeMinutes) ||
                other.cookingTimeMinutes == cookingTimeMinutes) &&
            (identical(other.prepTimeMinutes, prepTimeMinutes) ||
                other.prepTimeMinutes == prepTimeMinutes) &&
            (identical(other.servings, servings) ||
                other.servings == servings) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.fiber, fiber) || other.fiber == fiber) &&
            (identical(other.vitaminsMinerals, vitaminsMinerals) ||
                other.vitaminsMinerals == vitaminsMinerals) &&
            (identical(other.recipeImageUrl, recipeImageUrl) ||
                other.recipeImageUrl == recipeImageUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    mealPlanId,
    mealType,
    mealDate,
    recipeName,
    const DeepCollectionEquality().hash(_ingredients),
    const DeepCollectionEquality().hash(_instructions),
    cookingTimeMinutes,
    prepTimeMinutes,
    servings,
    calories,
    protein,
    carbs,
    fat,
    fiber,
    vitaminsMinerals,
    recipeImageUrl,
    notes,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      __$$MealImplCopyWithImpl<_$MealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealImplToJson(this);
  }
}

abstract class _Meal implements Meal {
  const factory _Meal({
    required final String id,
    @JsonKey(name: 'meal_plan_id') required final String mealPlanId,
    @JsonKey(name: 'meal_type') required final String mealType,
    @JsonKey(name: 'meal_date') required final DateTime mealDate,
    @JsonKey(name: 'recipe_name') required final String recipeName,
    final List<MealIngredient> ingredients,
    final List<String> instructions,
    @JsonKey(name: 'cooking_time_minutes') final int? cookingTimeMinutes,
    @JsonKey(name: 'prep_time_minutes') final int? prepTimeMinutes,
    final int servings,
    final int? calories,
    final double? protein,
    final double? carbs,
    final double? fat,
    final double? fiber,
    @JsonKey(name: 'vitamins_minerals')
    final VitaminsMinerals? vitaminsMinerals,
    @JsonKey(name: 'recipe_image_url') final String? recipeImageUrl,
    final String? notes,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$MealImpl;

  factory _Meal.fromJson(Map<String, dynamic> json) = _$MealImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'meal_plan_id')
  String get mealPlanId;
  @override
  @JsonKey(name: 'meal_type')
  String get mealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  @override
  @JsonKey(name: 'meal_date')
  DateTime get mealDate;
  @override
  @JsonKey(name: 'recipe_name')
  String get recipeName;
  @override
  List<MealIngredient> get ingredients;
  @override
  List<String> get instructions;
  @override
  @JsonKey(name: 'cooking_time_minutes')
  int? get cookingTimeMinutes;
  @override
  @JsonKey(name: 'prep_time_minutes')
  int? get prepTimeMinutes;
  @override
  int get servings;
  @override
  int? get calories;
  @override
  double? get protein;
  @override
  double? get carbs;
  @override
  double? get fat;
  @override
  double? get fiber;
  @override
  @JsonKey(name: 'vitamins_minerals')
  VitaminsMinerals? get vitaminsMinerals;
  @override
  @JsonKey(name: 'recipe_image_url')
  String? get recipeImageUrl;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FoodInventoryItem _$FoodInventoryItemFromJson(Map<String, dynamic> json) {
  return _FoodInventoryItem.fromJson(json);
}

/// @nodoc
mixin _$FoodInventoryItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'donation_id')
  String? get donationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient_id')
  String get recipientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_item')
  String get foodItem => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutritional_info')
  Map<String, dynamic>? get nutritionalInfo =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'used_quantity')
  double get usedQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this FoodInventoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FoodInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FoodInventoryItemCopyWith<FoodInventoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodInventoryItemCopyWith<$Res> {
  factory $FoodInventoryItemCopyWith(
    FoodInventoryItem value,
    $Res Function(FoodInventoryItem) then,
  ) = _$FoodInventoryItemCopyWithImpl<$Res, FoodInventoryItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'donation_id') String? donationId,
    @JsonKey(name: 'recipient_id') String recipientId,
    @JsonKey(name: 'food_item') String foodItem,
    double quantity,
    String unit,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    String? category,
    @JsonKey(name: 'nutritional_info') Map<String, dynamic>? nutritionalInfo,
    @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'used_quantity') double usedQuantity,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$FoodInventoryItemCopyWithImpl<$Res, $Val extends FoodInventoryItem>
    implements $FoodInventoryItemCopyWith<$Res> {
  _$FoodInventoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FoodInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? donationId = freezed,
    Object? recipientId = null,
    Object? foodItem = null,
    Object? quantity = null,
    Object? unit = null,
    Object? expiryDate = freezed,
    Object? category = freezed,
    Object? nutritionalInfo = freezed,
    Object? isAvailable = null,
    Object? usedQuantity = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            donationId: freezed == donationId
                ? _value.donationId
                : donationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            recipientId: null == recipientId
                ? _value.recipientId
                : recipientId // ignore: cast_nullable_to_non_nullable
                      as String,
            foodItem: null == foodItem
                ? _value.foodItem
                : foodItem // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            nutritionalInfo: freezed == nutritionalInfo
                ? _value.nutritionalInfo
                : nutritionalInfo // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            usedQuantity: null == usedQuantity
                ? _value.usedQuantity
                : usedQuantity // ignore: cast_nullable_to_non_nullable
                      as double,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FoodInventoryItemImplCopyWith<$Res>
    implements $FoodInventoryItemCopyWith<$Res> {
  factory _$$FoodInventoryItemImplCopyWith(
    _$FoodInventoryItemImpl value,
    $Res Function(_$FoodInventoryItemImpl) then,
  ) = __$$FoodInventoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'donation_id') String? donationId,
    @JsonKey(name: 'recipient_id') String recipientId,
    @JsonKey(name: 'food_item') String foodItem,
    double quantity,
    String unit,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
    String? category,
    @JsonKey(name: 'nutritional_info') Map<String, dynamic>? nutritionalInfo,
    @JsonKey(name: 'is_available') bool isAvailable,
    @JsonKey(name: 'used_quantity') double usedQuantity,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$FoodInventoryItemImplCopyWithImpl<$Res>
    extends _$FoodInventoryItemCopyWithImpl<$Res, _$FoodInventoryItemImpl>
    implements _$$FoodInventoryItemImplCopyWith<$Res> {
  __$$FoodInventoryItemImplCopyWithImpl(
    _$FoodInventoryItemImpl _value,
    $Res Function(_$FoodInventoryItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FoodInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? donationId = freezed,
    Object? recipientId = null,
    Object? foodItem = null,
    Object? quantity = null,
    Object? unit = null,
    Object? expiryDate = freezed,
    Object? category = freezed,
    Object? nutritionalInfo = freezed,
    Object? isAvailable = null,
    Object? usedQuantity = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$FoodInventoryItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        donationId: freezed == donationId
            ? _value.donationId
            : donationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        recipientId: null == recipientId
            ? _value.recipientId
            : recipientId // ignore: cast_nullable_to_non_nullable
                  as String,
        foodItem: null == foodItem
            ? _value.foodItem
            : foodItem // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        nutritionalInfo: freezed == nutritionalInfo
            ? _value._nutritionalInfo
            : nutritionalInfo // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        usedQuantity: null == usedQuantity
            ? _value.usedQuantity
            : usedQuantity // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodInventoryItemImpl implements _FoodInventoryItem {
  const _$FoodInventoryItemImpl({
    required this.id,
    @JsonKey(name: 'donation_id') this.donationId,
    @JsonKey(name: 'recipient_id') required this.recipientId,
    @JsonKey(name: 'food_item') required this.foodItem,
    required this.quantity,
    required this.unit,
    @JsonKey(name: 'expiry_date') this.expiryDate,
    this.category,
    @JsonKey(name: 'nutritional_info')
    final Map<String, dynamic>? nutritionalInfo,
    @JsonKey(name: 'is_available') this.isAvailable = true,
    @JsonKey(name: 'used_quantity') this.usedQuantity = 0.0,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _nutritionalInfo = nutritionalInfo;

  factory _$FoodInventoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodInventoryItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'donation_id')
  final String? donationId;
  @override
  @JsonKey(name: 'recipient_id')
  final String recipientId;
  @override
  @JsonKey(name: 'food_item')
  final String foodItem;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;
  @override
  final String? category;
  final Map<String, dynamic>? _nutritionalInfo;
  @override
  @JsonKey(name: 'nutritional_info')
  Map<String, dynamic>? get nutritionalInfo {
    final value = _nutritionalInfo;
    if (value == null) return null;
    if (_nutritionalInfo is EqualUnmodifiableMapView) return _nutritionalInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'used_quantity')
  final double usedQuantity;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'FoodInventoryItem(id: $id, donationId: $donationId, recipientId: $recipientId, foodItem: $foodItem, quantity: $quantity, unit: $unit, expiryDate: $expiryDate, category: $category, nutritionalInfo: $nutritionalInfo, isAvailable: $isAvailable, usedQuantity: $usedQuantity, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodInventoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.donationId, donationId) ||
                other.donationId == donationId) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.foodItem, foodItem) ||
                other.foodItem == foodItem) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
              other._nutritionalInfo,
              _nutritionalInfo,
            ) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.usedQuantity, usedQuantity) ||
                other.usedQuantity == usedQuantity) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    donationId,
    recipientId,
    foodItem,
    quantity,
    unit,
    expiryDate,
    category,
    const DeepCollectionEquality().hash(_nutritionalInfo),
    isAvailable,
    usedQuantity,
    createdAt,
    updatedAt,
  );

  /// Create a copy of FoodInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodInventoryItemImplCopyWith<_$FoodInventoryItemImpl> get copyWith =>
      __$$FoodInventoryItemImplCopyWithImpl<_$FoodInventoryItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodInventoryItemImplToJson(this);
  }
}

abstract class _FoodInventoryItem implements FoodInventoryItem {
  const factory _FoodInventoryItem({
    required final String id,
    @JsonKey(name: 'donation_id') final String? donationId,
    @JsonKey(name: 'recipient_id') required final String recipientId,
    @JsonKey(name: 'food_item') required final String foodItem,
    required final double quantity,
    required final String unit,
    @JsonKey(name: 'expiry_date') final DateTime? expiryDate,
    final String? category,
    @JsonKey(name: 'nutritional_info')
    final Map<String, dynamic>? nutritionalInfo,
    @JsonKey(name: 'is_available') final bool isAvailable,
    @JsonKey(name: 'used_quantity') final double usedQuantity,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$FoodInventoryItemImpl;

  factory _FoodInventoryItem.fromJson(Map<String, dynamic> json) =
      _$FoodInventoryItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'donation_id')
  String? get donationId;
  @override
  @JsonKey(name: 'recipient_id')
  String get recipientId;
  @override
  @JsonKey(name: 'food_item')
  String get foodItem;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate;
  @override
  String? get category;
  @override
  @JsonKey(name: 'nutritional_info')
  Map<String, dynamic>? get nutritionalInfo;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'used_quantity')
  double get usedQuantity;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of FoodInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoodInventoryItemImplCopyWith<_$FoodInventoryItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealPlannerMessage _$MealPlannerMessageFromJson(Map<String, dynamic> json) {
  return _MealPlannerMessage.fromJson(json);
}

/// @nodoc
mixin _$MealPlannerMessage {
  String get role =>
      throw _privateConstructorUsedError; // 'user' or 'assistant'
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this MealPlannerMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlannerMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlannerMessageCopyWith<MealPlannerMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlannerMessageCopyWith<$Res> {
  factory $MealPlannerMessageCopyWith(
    MealPlannerMessage value,
    $Res Function(MealPlannerMessage) then,
  ) = _$MealPlannerMessageCopyWithImpl<$Res, MealPlannerMessage>;
  @useResult
  $Res call({String role, String content, DateTime timestamp});
}

/// @nodoc
class _$MealPlannerMessageCopyWithImpl<$Res, $Val extends MealPlannerMessage>
    implements $MealPlannerMessageCopyWith<$Res> {
  _$MealPlannerMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlannerMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealPlannerMessageImplCopyWith<$Res>
    implements $MealPlannerMessageCopyWith<$Res> {
  factory _$$MealPlannerMessageImplCopyWith(
    _$MealPlannerMessageImpl value,
    $Res Function(_$MealPlannerMessageImpl) then,
  ) = __$$MealPlannerMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String role, String content, DateTime timestamp});
}

/// @nodoc
class __$$MealPlannerMessageImplCopyWithImpl<$Res>
    extends _$MealPlannerMessageCopyWithImpl<$Res, _$MealPlannerMessageImpl>
    implements _$$MealPlannerMessageImplCopyWith<$Res> {
  __$$MealPlannerMessageImplCopyWithImpl(
    _$MealPlannerMessageImpl _value,
    $Res Function(_$MealPlannerMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealPlannerMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? content = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$MealPlannerMessageImpl(
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlannerMessageImpl implements _MealPlannerMessage {
  const _$MealPlannerMessageImpl({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory _$MealPlannerMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlannerMessageImplFromJson(json);

  @override
  final String role;
  // 'user' or 'assistant'
  @override
  final String content;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'MealPlannerMessage(role: $role, content: $content, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealPlannerMessageImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, role, content, timestamp);

  /// Create a copy of MealPlannerMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlannerMessageImplCopyWith<_$MealPlannerMessageImpl> get copyWith =>
      __$$MealPlannerMessageImplCopyWithImpl<_$MealPlannerMessageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlannerMessageImplToJson(this);
  }
}

abstract class _MealPlannerMessage implements MealPlannerMessage {
  const factory _MealPlannerMessage({
    required final String role,
    required final String content,
    required final DateTime timestamp,
  }) = _$MealPlannerMessageImpl;

  factory _MealPlannerMessage.fromJson(Map<String, dynamic> json) =
      _$MealPlannerMessageImpl.fromJson;

  @override
  String get role; // 'user' or 'assistant'
  @override
  String get content;
  @override
  DateTime get timestamp;

  /// Create a copy of MealPlannerMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlannerMessageImplCopyWith<_$MealPlannerMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MealPlannerConversation _$MealPlannerConversationFromJson(
  Map<String, dynamic> json,
) {
  return _MealPlannerConversation.fromJson(json);
}

/// @nodoc
mixin _$MealPlannerConversation {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'conversation_title')
  String? get conversationTitle => throw _privateConstructorUsedError;
  List<MealPlannerMessage> get messages => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_used')
  String? get modelUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MealPlannerConversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlannerConversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlannerConversationCopyWith<MealPlannerConversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlannerConversationCopyWith<$Res> {
  factory $MealPlannerConversationCopyWith(
    MealPlannerConversation value,
    $Res Function(MealPlannerConversation) then,
  ) = _$MealPlannerConversationCopyWithImpl<$Res, MealPlannerConversation>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'conversation_title') String? conversationTitle,
    List<MealPlannerMessage> messages,
    @JsonKey(name: 'model_used') String? modelUsed,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$MealPlannerConversationCopyWithImpl<
  $Res,
  $Val extends MealPlannerConversation
>
    implements $MealPlannerConversationCopyWith<$Res> {
  _$MealPlannerConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlannerConversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? conversationTitle = freezed,
    Object? messages = null,
    Object? modelUsed = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationTitle: freezed == conversationTitle
                ? _value.conversationTitle
                : conversationTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            messages: null == messages
                ? _value.messages
                : messages // ignore: cast_nullable_to_non_nullable
                      as List<MealPlannerMessage>,
            modelUsed: freezed == modelUsed
                ? _value.modelUsed
                : modelUsed // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealPlannerConversationImplCopyWith<$Res>
    implements $MealPlannerConversationCopyWith<$Res> {
  factory _$$MealPlannerConversationImplCopyWith(
    _$MealPlannerConversationImpl value,
    $Res Function(_$MealPlannerConversationImpl) then,
  ) = __$$MealPlannerConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'conversation_title') String? conversationTitle,
    List<MealPlannerMessage> messages,
    @JsonKey(name: 'model_used') String? modelUsed,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$MealPlannerConversationImplCopyWithImpl<$Res>
    extends
        _$MealPlannerConversationCopyWithImpl<
          $Res,
          _$MealPlannerConversationImpl
        >
    implements _$$MealPlannerConversationImplCopyWith<$Res> {
  __$$MealPlannerConversationImplCopyWithImpl(
    _$MealPlannerConversationImpl _value,
    $Res Function(_$MealPlannerConversationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealPlannerConversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? conversationTitle = freezed,
    Object? messages = null,
    Object? modelUsed = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MealPlannerConversationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationTitle: freezed == conversationTitle
            ? _value.conversationTitle
            : conversationTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        messages: null == messages
            ? _value._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<MealPlannerMessage>,
        modelUsed: freezed == modelUsed
            ? _value.modelUsed
            : modelUsed // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlannerConversationImpl implements _MealPlannerConversation {
  const _$MealPlannerConversationImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'conversation_title') this.conversationTitle,
    final List<MealPlannerMessage> messages = const [],
    @JsonKey(name: 'model_used') this.modelUsed,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _messages = messages;

  factory _$MealPlannerConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlannerConversationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'conversation_title')
  final String? conversationTitle;
  final List<MealPlannerMessage> _messages;
  @override
  @JsonKey()
  List<MealPlannerMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey(name: 'model_used')
  final String? modelUsed;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MealPlannerConversation(id: $id, userId: $userId, conversationTitle: $conversationTitle, messages: $messages, modelUsed: $modelUsed, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealPlannerConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.conversationTitle, conversationTitle) ||
                other.conversationTitle == conversationTitle) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.modelUsed, modelUsed) ||
                other.modelUsed == modelUsed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    conversationTitle,
    const DeepCollectionEquality().hash(_messages),
    modelUsed,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MealPlannerConversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlannerConversationImplCopyWith<_$MealPlannerConversationImpl>
  get copyWith =>
      __$$MealPlannerConversationImplCopyWithImpl<
        _$MealPlannerConversationImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlannerConversationImplToJson(this);
  }
}

abstract class _MealPlannerConversation implements MealPlannerConversation {
  const factory _MealPlannerConversation({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'conversation_title') final String? conversationTitle,
    final List<MealPlannerMessage> messages,
    @JsonKey(name: 'model_used') final String? modelUsed,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$MealPlannerConversationImpl;

  factory _MealPlannerConversation.fromJson(Map<String, dynamic> json) =
      _$MealPlannerConversationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'conversation_title')
  String? get conversationTitle;
  @override
  List<MealPlannerMessage> get messages;
  @override
  @JsonKey(name: 'model_used')
  String? get modelUsed;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of MealPlannerConversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlannerConversationImplCopyWith<_$MealPlannerConversationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MealPlanTemplate _$MealPlanTemplateFromJson(Map<String, dynamic> json) {
  return _MealPlanTemplate.fromJson(json);
}

/// @nodoc
mixin _$MealPlanTemplate {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_name')
  String get templateName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get meals => throw _privateConstructorUsedError;
  @JsonKey(name: 'dietary_tags')
  List<String> get dietaryTags => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: 'usage_count')
  int get usageCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MealPlanTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealPlanTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealPlanTemplateCopyWith<MealPlanTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealPlanTemplateCopyWith<$Res> {
  factory $MealPlanTemplateCopyWith(
    MealPlanTemplate value,
    $Res Function(MealPlanTemplate) then,
  ) = _$MealPlanTemplateCopyWithImpl<$Res, MealPlanTemplate>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'template_name') String templateName,
    String? description,
    List<Map<String, dynamic>> meals,
    @JsonKey(name: 'dietary_tags') List<String> dietaryTags,
    @JsonKey(name: 'is_public') bool isPublic,
    @JsonKey(name: 'usage_count') int usageCount,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$MealPlanTemplateCopyWithImpl<$Res, $Val extends MealPlanTemplate>
    implements $MealPlanTemplateCopyWith<$Res> {
  _$MealPlanTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealPlanTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? templateName = null,
    Object? description = freezed,
    Object? meals = null,
    Object? dietaryTags = null,
    Object? isPublic = null,
    Object? usageCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            templateName: null == templateName
                ? _value.templateName
                : templateName // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            meals: null == meals
                ? _value.meals
                : meals // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
            dietaryTags: null == dietaryTags
                ? _value.dietaryTags
                : dietaryTags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isPublic: null == isPublic
                ? _value.isPublic
                : isPublic // ignore: cast_nullable_to_non_nullable
                      as bool,
            usageCount: null == usageCount
                ? _value.usageCount
                : usageCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MealPlanTemplateImplCopyWith<$Res>
    implements $MealPlanTemplateCopyWith<$Res> {
  factory _$$MealPlanTemplateImplCopyWith(
    _$MealPlanTemplateImpl value,
    $Res Function(_$MealPlanTemplateImpl) then,
  ) = __$$MealPlanTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'template_name') String templateName,
    String? description,
    List<Map<String, dynamic>> meals,
    @JsonKey(name: 'dietary_tags') List<String> dietaryTags,
    @JsonKey(name: 'is_public') bool isPublic,
    @JsonKey(name: 'usage_count') int usageCount,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$MealPlanTemplateImplCopyWithImpl<$Res>
    extends _$MealPlanTemplateCopyWithImpl<$Res, _$MealPlanTemplateImpl>
    implements _$$MealPlanTemplateImplCopyWith<$Res> {
  __$$MealPlanTemplateImplCopyWithImpl(
    _$MealPlanTemplateImpl _value,
    $Res Function(_$MealPlanTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MealPlanTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? templateName = null,
    Object? description = freezed,
    Object? meals = null,
    Object? dietaryTags = null,
    Object? isPublic = null,
    Object? usageCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$MealPlanTemplateImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        templateName: null == templateName
            ? _value.templateName
            : templateName // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        meals: null == meals
            ? _value._meals
            : meals // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
        dietaryTags: null == dietaryTags
            ? _value._dietaryTags
            : dietaryTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isPublic: null == isPublic
            ? _value.isPublic
            : isPublic // ignore: cast_nullable_to_non_nullable
                  as bool,
        usageCount: null == usageCount
            ? _value.usageCount
            : usageCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MealPlanTemplateImpl implements _MealPlanTemplate {
  const _$MealPlanTemplateImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'template_name') required this.templateName,
    this.description,
    final List<Map<String, dynamic>> meals = const [],
    @JsonKey(name: 'dietary_tags') final List<String> dietaryTags = const [],
    @JsonKey(name: 'is_public') this.isPublic = false,
    @JsonKey(name: 'usage_count') this.usageCount = 0,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _meals = meals,
       _dietaryTags = dietaryTags;

  factory _$MealPlanTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealPlanTemplateImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'template_name')
  final String templateName;
  @override
  final String? description;
  final List<Map<String, dynamic>> _meals;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get meals {
    if (_meals is EqualUnmodifiableListView) return _meals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_meals);
  }

  final List<String> _dietaryTags;
  @override
  @JsonKey(name: 'dietary_tags')
  List<String> get dietaryTags {
    if (_dietaryTags is EqualUnmodifiableListView) return _dietaryTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dietaryTags);
  }

  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  @JsonKey(name: 'usage_count')
  final int usageCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'MealPlanTemplate(id: $id, userId: $userId, templateName: $templateName, description: $description, meals: $meals, dietaryTags: $dietaryTags, isPublic: $isPublic, usageCount: $usageCount, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealPlanTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._meals, _meals) &&
            const DeepCollectionEquality().equals(
              other._dietaryTags,
              _dietaryTags,
            ) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.usageCount, usageCount) ||
                other.usageCount == usageCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    templateName,
    description,
    const DeepCollectionEquality().hash(_meals),
    const DeepCollectionEquality().hash(_dietaryTags),
    isPublic,
    usageCount,
    createdAt,
    updatedAt,
  );

  /// Create a copy of MealPlanTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealPlanTemplateImplCopyWith<_$MealPlanTemplateImpl> get copyWith =>
      __$$MealPlanTemplateImplCopyWithImpl<_$MealPlanTemplateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MealPlanTemplateImplToJson(this);
  }
}

abstract class _MealPlanTemplate implements MealPlanTemplate {
  const factory _MealPlanTemplate({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'template_name') required final String templateName,
    final String? description,
    final List<Map<String, dynamic>> meals,
    @JsonKey(name: 'dietary_tags') final List<String> dietaryTags,
    @JsonKey(name: 'is_public') final bool isPublic,
    @JsonKey(name: 'usage_count') final int usageCount,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$MealPlanTemplateImpl;

  factory _MealPlanTemplate.fromJson(Map<String, dynamic> json) =
      _$MealPlanTemplateImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'template_name')
  String get templateName;
  @override
  String? get description;
  @override
  List<Map<String, dynamic>> get meals;
  @override
  @JsonKey(name: 'dietary_tags')
  List<String> get dietaryTags;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  @JsonKey(name: 'usage_count')
  int get usageCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of MealPlanTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealPlanTemplateImplCopyWith<_$MealPlanTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroceryListItem _$GroceryListItemFromJson(Map<String, dynamic> json) {
  return _GroceryListItem.fromJson(json);
}

/// @nodoc
mixin _$GroceryListItem {
  String get item => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  bool get checked => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_donation')
  bool get fromDonation => throw _privateConstructorUsedError;

  /// Serializes this GroceryListItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroceryListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroceryListItemCopyWith<GroceryListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroceryListItemCopyWith<$Res> {
  factory $GroceryListItemCopyWith(
    GroceryListItem value,
    $Res Function(GroceryListItem) then,
  ) = _$GroceryListItemCopyWithImpl<$Res, GroceryListItem>;
  @useResult
  $Res call({
    String item,
    double quantity,
    String unit,
    String? category,
    bool checked,
    @JsonKey(name: 'from_donation') bool fromDonation,
  });
}

/// @nodoc
class _$GroceryListItemCopyWithImpl<$Res, $Val extends GroceryListItem>
    implements $GroceryListItemCopyWith<$Res> {
  _$GroceryListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroceryListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = freezed,
    Object? checked = null,
    Object? fromDonation = null,
  }) {
    return _then(
      _value.copyWith(
            item: null == item
                ? _value.item
                : item // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            checked: null == checked
                ? _value.checked
                : checked // ignore: cast_nullable_to_non_nullable
                      as bool,
            fromDonation: null == fromDonation
                ? _value.fromDonation
                : fromDonation // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroceryListItemImplCopyWith<$Res>
    implements $GroceryListItemCopyWith<$Res> {
  factory _$$GroceryListItemImplCopyWith(
    _$GroceryListItemImpl value,
    $Res Function(_$GroceryListItemImpl) then,
  ) = __$$GroceryListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String item,
    double quantity,
    String unit,
    String? category,
    bool checked,
    @JsonKey(name: 'from_donation') bool fromDonation,
  });
}

/// @nodoc
class __$$GroceryListItemImplCopyWithImpl<$Res>
    extends _$GroceryListItemCopyWithImpl<$Res, _$GroceryListItemImpl>
    implements _$$GroceryListItemImplCopyWith<$Res> {
  __$$GroceryListItemImplCopyWithImpl(
    _$GroceryListItemImpl _value,
    $Res Function(_$GroceryListItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroceryListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = freezed,
    Object? checked = null,
    Object? fromDonation = null,
  }) {
    return _then(
      _$GroceryListItemImpl(
        item: null == item
            ? _value.item
            : item // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        checked: null == checked
            ? _value.checked
            : checked // ignore: cast_nullable_to_non_nullable
                  as bool,
        fromDonation: null == fromDonation
            ? _value.fromDonation
            : fromDonation // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroceryListItemImpl implements _GroceryListItem {
  const _$GroceryListItemImpl({
    required this.item,
    required this.quantity,
    required this.unit,
    this.category,
    this.checked = false,
    @JsonKey(name: 'from_donation') this.fromDonation = false,
  });

  factory _$GroceryListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroceryListItemImplFromJson(json);

  @override
  final String item;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final String? category;
  @override
  @JsonKey()
  final bool checked;
  @override
  @JsonKey(name: 'from_donation')
  final bool fromDonation;

  @override
  String toString() {
    return 'GroceryListItem(item: $item, quantity: $quantity, unit: $unit, category: $category, checked: $checked, fromDonation: $fromDonation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroceryListItemImpl &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.checked, checked) || other.checked == checked) &&
            (identical(other.fromDonation, fromDonation) ||
                other.fromDonation == fromDonation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    item,
    quantity,
    unit,
    category,
    checked,
    fromDonation,
  );

  /// Create a copy of GroceryListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroceryListItemImplCopyWith<_$GroceryListItemImpl> get copyWith =>
      __$$GroceryListItemImplCopyWithImpl<_$GroceryListItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroceryListItemImplToJson(this);
  }
}

abstract class _GroceryListItem implements GroceryListItem {
  const factory _GroceryListItem({
    required final String item,
    required final double quantity,
    required final String unit,
    final String? category,
    final bool checked,
    @JsonKey(name: 'from_donation') final bool fromDonation,
  }) = _$GroceryListItemImpl;

  factory _GroceryListItem.fromJson(Map<String, dynamic> json) =
      _$GroceryListItemImpl.fromJson;

  @override
  String get item;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  String? get category;
  @override
  bool get checked;
  @override
  @JsonKey(name: 'from_donation')
  bool get fromDonation;

  /// Create a copy of GroceryListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroceryListItemImplCopyWith<_$GroceryListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroceryList _$GroceryListFromJson(Map<String, dynamic> json) {
  return _GroceryList.fromJson(json);
}

/// @nodoc
mixin _$GroceryList {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_plan_id')
  String get mealPlanId => throw _privateConstructorUsedError;
  @JsonKey(name: 'list_name')
  String get listName => throw _privateConstructorUsedError;
  List<GroceryListItem> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GroceryList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroceryList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroceryListCopyWith<GroceryList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroceryListCopyWith<$Res> {
  factory $GroceryListCopyWith(
    GroceryList value,
    $Res Function(GroceryList) then,
  ) = _$GroceryListCopyWithImpl<$Res, GroceryList>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'meal_plan_id') String mealPlanId,
    @JsonKey(name: 'list_name') String listName,
    List<GroceryListItem> items,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$GroceryListCopyWithImpl<$Res, $Val extends GroceryList>
    implements $GroceryListCopyWith<$Res> {
  _$GroceryListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroceryList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? mealPlanId = null,
    Object? listName = null,
    Object? items = null,
    Object? isCompleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            mealPlanId: null == mealPlanId
                ? _value.mealPlanId
                : mealPlanId // ignore: cast_nullable_to_non_nullable
                      as String,
            listName: null == listName
                ? _value.listName
                : listName // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<GroceryListItem>,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroceryListImplCopyWith<$Res>
    implements $GroceryListCopyWith<$Res> {
  factory _$$GroceryListImplCopyWith(
    _$GroceryListImpl value,
    $Res Function(_$GroceryListImpl) then,
  ) = __$$GroceryListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'meal_plan_id') String mealPlanId,
    @JsonKey(name: 'list_name') String listName,
    List<GroceryListItem> items,
    @JsonKey(name: 'is_completed') bool isCompleted,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$GroceryListImplCopyWithImpl<$Res>
    extends _$GroceryListCopyWithImpl<$Res, _$GroceryListImpl>
    implements _$$GroceryListImplCopyWith<$Res> {
  __$$GroceryListImplCopyWithImpl(
    _$GroceryListImpl _value,
    $Res Function(_$GroceryListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroceryList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? mealPlanId = null,
    Object? listName = null,
    Object? items = null,
    Object? isCompleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$GroceryListImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        mealPlanId: null == mealPlanId
            ? _value.mealPlanId
            : mealPlanId // ignore: cast_nullable_to_non_nullable
                  as String,
        listName: null == listName
            ? _value.listName
            : listName // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<GroceryListItem>,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroceryListImpl implements _GroceryList {
  const _$GroceryListImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'meal_plan_id') required this.mealPlanId,
    @JsonKey(name: 'list_name') required this.listName,
    final List<GroceryListItem> items = const [],
    @JsonKey(name: 'is_completed') this.isCompleted = false,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _items = items;

  factory _$GroceryListImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroceryListImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'meal_plan_id')
  final String mealPlanId;
  @override
  @JsonKey(name: 'list_name')
  final String listName;
  final List<GroceryListItem> _items;
  @override
  @JsonKey()
  List<GroceryListItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'GroceryList(id: $id, userId: $userId, mealPlanId: $mealPlanId, listName: $listName, items: $items, isCompleted: $isCompleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroceryListImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.mealPlanId, mealPlanId) ||
                other.mealPlanId == mealPlanId) &&
            (identical(other.listName, listName) ||
                other.listName == listName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    mealPlanId,
    listName,
    const DeepCollectionEquality().hash(_items),
    isCompleted,
    createdAt,
    updatedAt,
  );

  /// Create a copy of GroceryList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroceryListImplCopyWith<_$GroceryListImpl> get copyWith =>
      __$$GroceryListImplCopyWithImpl<_$GroceryListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroceryListImplToJson(this);
  }
}

abstract class _GroceryList implements GroceryList {
  const factory _GroceryList({
    required final String id,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'meal_plan_id') required final String mealPlanId,
    @JsonKey(name: 'list_name') required final String listName,
    final List<GroceryListItem> items,
    @JsonKey(name: 'is_completed') final bool isCompleted,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$GroceryListImpl;

  factory _GroceryList.fromJson(Map<String, dynamic> json) =
      _$GroceryListImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'meal_plan_id')
  String get mealPlanId;
  @override
  @JsonKey(name: 'list_name')
  String get listName;
  @override
  List<GroceryListItem> get items;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of GroceryList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroceryListImplCopyWith<_$GroceryListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExpiringInventoryItem _$ExpiringInventoryItemFromJson(
  Map<String, dynamic> json,
) {
  return _ExpiringInventoryItem.fromJson(json);
}

/// @nodoc
mixin _$ExpiringInventoryItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_item')
  String get foodItem => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  DateTime get expiryDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'days_until_expiry')
  int get daysUntilExpiry => throw _privateConstructorUsedError;

  /// Serializes this ExpiringInventoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpiringInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpiringInventoryItemCopyWith<ExpiringInventoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpiringInventoryItemCopyWith<$Res> {
  factory $ExpiringInventoryItemCopyWith(
    ExpiringInventoryItem value,
    $Res Function(ExpiringInventoryItem) then,
  ) = _$ExpiringInventoryItemCopyWithImpl<$Res, ExpiringInventoryItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'food_item') String foodItem,
    double quantity,
    String unit,
    @JsonKey(name: 'expiry_date') DateTime expiryDate,
    @JsonKey(name: 'days_until_expiry') int daysUntilExpiry,
  });
}

/// @nodoc
class _$ExpiringInventoryItemCopyWithImpl<
  $Res,
  $Val extends ExpiringInventoryItem
>
    implements $ExpiringInventoryItemCopyWith<$Res> {
  _$ExpiringInventoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpiringInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodItem = null,
    Object? quantity = null,
    Object? unit = null,
    Object? expiryDate = null,
    Object? daysUntilExpiry = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            foodItem: null == foodItem
                ? _value.foodItem
                : foodItem // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            expiryDate: null == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            daysUntilExpiry: null == daysUntilExpiry
                ? _value.daysUntilExpiry
                : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExpiringInventoryItemImplCopyWith<$Res>
    implements $ExpiringInventoryItemCopyWith<$Res> {
  factory _$$ExpiringInventoryItemImplCopyWith(
    _$ExpiringInventoryItemImpl value,
    $Res Function(_$ExpiringInventoryItemImpl) then,
  ) = __$$ExpiringInventoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'food_item') String foodItem,
    double quantity,
    String unit,
    @JsonKey(name: 'expiry_date') DateTime expiryDate,
    @JsonKey(name: 'days_until_expiry') int daysUntilExpiry,
  });
}

/// @nodoc
class __$$ExpiringInventoryItemImplCopyWithImpl<$Res>
    extends
        _$ExpiringInventoryItemCopyWithImpl<$Res, _$ExpiringInventoryItemImpl>
    implements _$$ExpiringInventoryItemImplCopyWith<$Res> {
  __$$ExpiringInventoryItemImplCopyWithImpl(
    _$ExpiringInventoryItemImpl _value,
    $Res Function(_$ExpiringInventoryItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExpiringInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodItem = null,
    Object? quantity = null,
    Object? unit = null,
    Object? expiryDate = null,
    Object? daysUntilExpiry = null,
  }) {
    return _then(
      _$ExpiringInventoryItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        foodItem: null == foodItem
            ? _value.foodItem
            : foodItem // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        expiryDate: null == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        daysUntilExpiry: null == daysUntilExpiry
            ? _value.daysUntilExpiry
            : daysUntilExpiry // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpiringInventoryItemImpl implements _ExpiringInventoryItem {
  const _$ExpiringInventoryItemImpl({
    required this.id,
    @JsonKey(name: 'food_item') required this.foodItem,
    required this.quantity,
    required this.unit,
    @JsonKey(name: 'expiry_date') required this.expiryDate,
    @JsonKey(name: 'days_until_expiry') required this.daysUntilExpiry,
  });

  factory _$ExpiringInventoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpiringInventoryItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'food_item')
  final String foodItem;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  @JsonKey(name: 'expiry_date')
  final DateTime expiryDate;
  @override
  @JsonKey(name: 'days_until_expiry')
  final int daysUntilExpiry;

  @override
  String toString() {
    return 'ExpiringInventoryItem(id: $id, foodItem: $foodItem, quantity: $quantity, unit: $unit, expiryDate: $expiryDate, daysUntilExpiry: $daysUntilExpiry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpiringInventoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.foodItem, foodItem) ||
                other.foodItem == foodItem) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.daysUntilExpiry, daysUntilExpiry) ||
                other.daysUntilExpiry == daysUntilExpiry));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    foodItem,
    quantity,
    unit,
    expiryDate,
    daysUntilExpiry,
  );

  /// Create a copy of ExpiringInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpiringInventoryItemImplCopyWith<_$ExpiringInventoryItemImpl>
  get copyWith =>
      __$$ExpiringInventoryItemImplCopyWithImpl<_$ExpiringInventoryItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpiringInventoryItemImplToJson(this);
  }
}

abstract class _ExpiringInventoryItem implements ExpiringInventoryItem {
  const factory _ExpiringInventoryItem({
    required final String id,
    @JsonKey(name: 'food_item') required final String foodItem,
    required final double quantity,
    required final String unit,
    @JsonKey(name: 'expiry_date') required final DateTime expiryDate,
    @JsonKey(name: 'days_until_expiry') required final int daysUntilExpiry,
  }) = _$ExpiringInventoryItemImpl;

  factory _ExpiringInventoryItem.fromJson(Map<String, dynamic> json) =
      _$ExpiringInventoryItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'food_item')
  String get foodItem;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  @JsonKey(name: 'expiry_date')
  DateTime get expiryDate;
  @override
  @JsonKey(name: 'days_until_expiry')
  int get daysUntilExpiry;

  /// Create a copy of ExpiringInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpiringInventoryItemImplCopyWith<_$ExpiringInventoryItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AvailableInventoryItem _$AvailableInventoryItemFromJson(
  Map<String, dynamic> json,
) {
  return _AvailableInventoryItem.fromJson(json);
}

/// @nodoc
mixin _$AvailableInventoryItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_item')
  String get foodItem => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate => throw _privateConstructorUsedError;

  /// Serializes this AvailableInventoryItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvailableInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvailableInventoryItemCopyWith<AvailableInventoryItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvailableInventoryItemCopyWith<$Res> {
  factory $AvailableInventoryItemCopyWith(
    AvailableInventoryItem value,
    $Res Function(AvailableInventoryItem) then,
  ) = _$AvailableInventoryItemCopyWithImpl<$Res, AvailableInventoryItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'food_item') String foodItem,
    double quantity,
    String unit,
    String? category,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
  });
}

/// @nodoc
class _$AvailableInventoryItemCopyWithImpl<
  $Res,
  $Val extends AvailableInventoryItem
>
    implements $AvailableInventoryItemCopyWith<$Res> {
  _$AvailableInventoryItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvailableInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodItem = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = freezed,
    Object? expiryDate = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            foodItem: null == foodItem
                ? _value.foodItem
                : foodItem // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as double,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            expiryDate: freezed == expiryDate
                ? _value.expiryDate
                : expiryDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvailableInventoryItemImplCopyWith<$Res>
    implements $AvailableInventoryItemCopyWith<$Res> {
  factory _$$AvailableInventoryItemImplCopyWith(
    _$AvailableInventoryItemImpl value,
    $Res Function(_$AvailableInventoryItemImpl) then,
  ) = __$$AvailableInventoryItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'food_item') String foodItem,
    double quantity,
    String unit,
    String? category,
    @JsonKey(name: 'expiry_date') DateTime? expiryDate,
  });
}

/// @nodoc
class __$$AvailableInventoryItemImplCopyWithImpl<$Res>
    extends
        _$AvailableInventoryItemCopyWithImpl<$Res, _$AvailableInventoryItemImpl>
    implements _$$AvailableInventoryItemImplCopyWith<$Res> {
  __$$AvailableInventoryItemImplCopyWithImpl(
    _$AvailableInventoryItemImpl _value,
    $Res Function(_$AvailableInventoryItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvailableInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodItem = null,
    Object? quantity = null,
    Object? unit = null,
    Object? category = freezed,
    Object? expiryDate = freezed,
  }) {
    return _then(
      _$AvailableInventoryItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        foodItem: null == foodItem
            ? _value.foodItem
            : foodItem // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as double,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        expiryDate: freezed == expiryDate
            ? _value.expiryDate
            : expiryDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvailableInventoryItemImpl implements _AvailableInventoryItem {
  const _$AvailableInventoryItemImpl({
    required this.id,
    @JsonKey(name: 'food_item') required this.foodItem,
    required this.quantity,
    required this.unit,
    this.category,
    @JsonKey(name: 'expiry_date') this.expiryDate,
  });

  factory _$AvailableInventoryItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvailableInventoryItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'food_item')
  final String foodItem;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final String? category;
  @override
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;

  @override
  String toString() {
    return 'AvailableInventoryItem(id: $id, foodItem: $foodItem, quantity: $quantity, unit: $unit, category: $category, expiryDate: $expiryDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvailableInventoryItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.foodItem, foodItem) ||
                other.foodItem == foodItem) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    foodItem,
    quantity,
    unit,
    category,
    expiryDate,
  );

  /// Create a copy of AvailableInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvailableInventoryItemImplCopyWith<_$AvailableInventoryItemImpl>
  get copyWith =>
      __$$AvailableInventoryItemImplCopyWithImpl<_$AvailableInventoryItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvailableInventoryItemImplToJson(this);
  }
}

abstract class _AvailableInventoryItem implements AvailableInventoryItem {
  const factory _AvailableInventoryItem({
    required final String id,
    @JsonKey(name: 'food_item') required final String foodItem,
    required final double quantity,
    required final String unit,
    final String? category,
    @JsonKey(name: 'expiry_date') final DateTime? expiryDate,
  }) = _$AvailableInventoryItemImpl;

  factory _AvailableInventoryItem.fromJson(Map<String, dynamic> json) =
      _$AvailableInventoryItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'food_item')
  String get foodItem;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  String? get category;
  @override
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate;

  /// Create a copy of AvailableInventoryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvailableInventoryItemImplCopyWith<_$AvailableInventoryItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}
