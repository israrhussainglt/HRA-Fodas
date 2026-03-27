// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LocationPoint _$LocationPointFromJson(Map<String, dynamic> json) {
  return _LocationPoint.fromJson(json);
}

/// @nodoc
mixin _$LocationPoint {
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get accuracy => throw _privateConstructorUsedError;
  double? get altitude => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  double? get heading => throw _privateConstructorUsedError;

  /// Serializes this LocationPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationPointCopyWith<LocationPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationPointCopyWith<$Res> {
  factory $LocationPointCopyWith(
    LocationPoint value,
    $Res Function(LocationPoint) then,
  ) = _$LocationPointCopyWithImpl<$Res, LocationPoint>;
  @useResult
  $Res call({
    double latitude,
    double longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
  });
}

/// @nodoc
class _$LocationPointCopyWithImpl<$Res, $Val extends LocationPoint>
    implements $LocationPointCopyWith<$Res> {
  _$LocationPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracy = freezed,
    Object? altitude = freezed,
    Object? speed = freezed,
    Object? heading = freezed,
  }) {
    return _then(
      _value.copyWith(
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            accuracy: freezed == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double?,
            altitude: freezed == altitude
                ? _value.altitude
                : altitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            speed: freezed == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                      as double?,
            heading: freezed == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocationPointImplCopyWith<$Res>
    implements $LocationPointCopyWith<$Res> {
  factory _$$LocationPointImplCopyWith(
    _$LocationPointImpl value,
    $Res Function(_$LocationPointImpl) then,
  ) = __$$LocationPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double latitude,
    double longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
  });
}

/// @nodoc
class __$$LocationPointImplCopyWithImpl<$Res>
    extends _$LocationPointCopyWithImpl<$Res, _$LocationPointImpl>
    implements _$$LocationPointImplCopyWith<$Res> {
  __$$LocationPointImplCopyWithImpl(
    _$LocationPointImpl _value,
    $Res Function(_$LocationPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracy = freezed,
    Object? altitude = freezed,
    Object? speed = freezed,
    Object? heading = freezed,
  }) {
    return _then(
      _$LocationPointImpl(
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        accuracy: freezed == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double?,
        altitude: freezed == altitude
            ? _value.altitude
            : altitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        speed: freezed == speed
            ? _value.speed
            : speed // ignore: cast_nullable_to_non_nullable
                  as double?,
        heading: freezed == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationPointImpl implements _LocationPoint {
  const _$LocationPointImpl({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    this.heading,
  });

  factory _$LocationPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationPointImplFromJson(json);

  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? accuracy;
  @override
  final double? altitude;
  @override
  final double? speed;
  @override
  final double? heading;

  @override
  String toString() {
    return 'LocationPoint(latitude: $latitude, longitude: $longitude, accuracy: $accuracy, altitude: $altitude, speed: $speed, heading: $heading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationPointImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.heading, heading) || other.heading == heading));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    latitude,
    longitude,
    accuracy,
    altitude,
    speed,
    heading,
  );

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationPointImplCopyWith<_$LocationPointImpl> get copyWith =>
      __$$LocationPointImplCopyWithImpl<_$LocationPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationPointImplToJson(this);
  }
}

abstract class _LocationPoint implements LocationPoint {
  const factory _LocationPoint({
    required final double latitude,
    required final double longitude,
    final double? accuracy,
    final double? altitude,
    final double? speed,
    final double? heading,
  }) = _$LocationPointImpl;

  factory _LocationPoint.fromJson(Map<String, dynamic> json) =
      _$LocationPointImpl.fromJson;

  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get accuracy;
  @override
  double? get altitude;
  @override
  double? get speed;
  @override
  double? get heading;

  /// Create a copy of LocationPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationPointImplCopyWith<_$LocationPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeliveryRoute _$DeliveryRouteFromJson(Map<String, dynamic> json) {
  return _DeliveryRoute.fromJson(json);
}

/// @nodoc
mixin _$DeliveryRoute {
  String get id => throw _privateConstructorUsedError;
  String get volunteerId => throw _privateConstructorUsedError;
  RouteStatus get status => throw _privateConstructorUsedError;
  double? get totalDistance =>
      throw _privateConstructorUsedError; // in kilometers
  int? get totalDuration => throw _privateConstructorUsedError; // in minutes
  bool get optimized => throw _privateConstructorUsedError;
  String? get optimizationAlgorithm => throw _privateConstructorUsedError;
  double? get startLocationLat => throw _privateConstructorUsedError;
  double? get startLocationLng => throw _privateConstructorUsedError;
  String? get startAddress => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  List<RouteStop> get stops => throw _privateConstructorUsedError;

  /// Serializes this DeliveryRoute to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryRouteCopyWith<DeliveryRoute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryRouteCopyWith<$Res> {
  factory $DeliveryRouteCopyWith(
    DeliveryRoute value,
    $Res Function(DeliveryRoute) then,
  ) = _$DeliveryRouteCopyWithImpl<$Res, DeliveryRoute>;
  @useResult
  $Res call({
    String id,
    String volunteerId,
    RouteStatus status,
    double? totalDistance,
    int? totalDuration,
    bool optimized,
    String? optimizationAlgorithm,
    double? startLocationLat,
    double? startLocationLng,
    String? startAddress,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    List<RouteStop> stops,
  });
}

/// @nodoc
class _$DeliveryRouteCopyWithImpl<$Res, $Val extends DeliveryRoute>
    implements $DeliveryRouteCopyWith<$Res> {
  _$DeliveryRouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? volunteerId = null,
    Object? status = null,
    Object? totalDistance = freezed,
    Object? totalDuration = freezed,
    Object? optimized = null,
    Object? optimizationAlgorithm = freezed,
    Object? startLocationLat = freezed,
    Object? startLocationLng = freezed,
    Object? startAddress = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? stops = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            volunteerId: null == volunteerId
                ? _value.volunteerId
                : volunteerId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RouteStatus,
            totalDistance: freezed == totalDistance
                ? _value.totalDistance
                : totalDistance // ignore: cast_nullable_to_non_nullable
                      as double?,
            totalDuration: freezed == totalDuration
                ? _value.totalDuration
                : totalDuration // ignore: cast_nullable_to_non_nullable
                      as int?,
            optimized: null == optimized
                ? _value.optimized
                : optimized // ignore: cast_nullable_to_non_nullable
                      as bool,
            optimizationAlgorithm: freezed == optimizationAlgorithm
                ? _value.optimizationAlgorithm
                : optimizationAlgorithm // ignore: cast_nullable_to_non_nullable
                      as String?,
            startLocationLat: freezed == startLocationLat
                ? _value.startLocationLat
                : startLocationLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            startLocationLng: freezed == startLocationLng
                ? _value.startLocationLng
                : startLocationLng // ignore: cast_nullable_to_non_nullable
                      as double?,
            startAddress: freezed == startAddress
                ? _value.startAddress
                : startAddress // ignore: cast_nullable_to_non_nullable
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
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            stops: null == stops
                ? _value.stops
                : stops // ignore: cast_nullable_to_non_nullable
                      as List<RouteStop>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeliveryRouteImplCopyWith<$Res>
    implements $DeliveryRouteCopyWith<$Res> {
  factory _$$DeliveryRouteImplCopyWith(
    _$DeliveryRouteImpl value,
    $Res Function(_$DeliveryRouteImpl) then,
  ) = __$$DeliveryRouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String volunteerId,
    RouteStatus status,
    double? totalDistance,
    int? totalDuration,
    bool optimized,
    String? optimizationAlgorithm,
    double? startLocationLat,
    double? startLocationLng,
    String? startAddress,
    String? notes,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    List<RouteStop> stops,
  });
}

/// @nodoc
class __$$DeliveryRouteImplCopyWithImpl<$Res>
    extends _$DeliveryRouteCopyWithImpl<$Res, _$DeliveryRouteImpl>
    implements _$$DeliveryRouteImplCopyWith<$Res> {
  __$$DeliveryRouteImplCopyWithImpl(
    _$DeliveryRouteImpl _value,
    $Res Function(_$DeliveryRouteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryRoute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? volunteerId = null,
    Object? status = null,
    Object? totalDistance = freezed,
    Object? totalDuration = freezed,
    Object? optimized = null,
    Object? optimizationAlgorithm = freezed,
    Object? startLocationLat = freezed,
    Object? startLocationLng = freezed,
    Object? startAddress = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? stops = null,
  }) {
    return _then(
      _$DeliveryRouteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        volunteerId: null == volunteerId
            ? _value.volunteerId
            : volunteerId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RouteStatus,
        totalDistance: freezed == totalDistance
            ? _value.totalDistance
            : totalDistance // ignore: cast_nullable_to_non_nullable
                  as double?,
        totalDuration: freezed == totalDuration
            ? _value.totalDuration
            : totalDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
        optimized: null == optimized
            ? _value.optimized
            : optimized // ignore: cast_nullable_to_non_nullable
                  as bool,
        optimizationAlgorithm: freezed == optimizationAlgorithm
            ? _value.optimizationAlgorithm
            : optimizationAlgorithm // ignore: cast_nullable_to_non_nullable
                  as String?,
        startLocationLat: freezed == startLocationLat
            ? _value.startLocationLat
            : startLocationLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        startLocationLng: freezed == startLocationLng
            ? _value.startLocationLng
            : startLocationLng // ignore: cast_nullable_to_non_nullable
                  as double?,
        startAddress: freezed == startAddress
            ? _value.startAddress
            : startAddress // ignore: cast_nullable_to_non_nullable
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
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        stops: null == stops
            ? _value._stops
            : stops // ignore: cast_nullable_to_non_nullable
                  as List<RouteStop>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryRouteImpl implements _DeliveryRoute {
  const _$DeliveryRouteImpl({
    required this.id,
    required this.volunteerId,
    required this.status,
    this.totalDistance,
    this.totalDuration,
    this.optimized = false,
    this.optimizationAlgorithm,
    this.startLocationLat,
    this.startLocationLng,
    this.startAddress,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.startedAt,
    this.completedAt,
    final List<RouteStop> stops = const [],
  }) : _stops = stops;

  factory _$DeliveryRouteImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryRouteImplFromJson(json);

  @override
  final String id;
  @override
  final String volunteerId;
  @override
  final RouteStatus status;
  @override
  final double? totalDistance;
  // in kilometers
  @override
  final int? totalDuration;
  // in minutes
  @override
  @JsonKey()
  final bool optimized;
  @override
  final String? optimizationAlgorithm;
  @override
  final double? startLocationLat;
  @override
  final double? startLocationLng;
  @override
  final String? startAddress;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? completedAt;
  final List<RouteStop> _stops;
  @override
  @JsonKey()
  List<RouteStop> get stops {
    if (_stops is EqualUnmodifiableListView) return _stops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stops);
  }

  @override
  String toString() {
    return 'DeliveryRoute(id: $id, volunteerId: $volunteerId, status: $status, totalDistance: $totalDistance, totalDuration: $totalDuration, optimized: $optimized, optimizationAlgorithm: $optimizationAlgorithm, startLocationLat: $startLocationLat, startLocationLng: $startLocationLng, startAddress: $startAddress, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, startedAt: $startedAt, completedAt: $completedAt, stops: $stops)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryRouteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.volunteerId, volunteerId) ||
                other.volunteerId == volunteerId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration) &&
            (identical(other.optimized, optimized) ||
                other.optimized == optimized) &&
            (identical(other.optimizationAlgorithm, optimizationAlgorithm) ||
                other.optimizationAlgorithm == optimizationAlgorithm) &&
            (identical(other.startLocationLat, startLocationLat) ||
                other.startLocationLat == startLocationLat) &&
            (identical(other.startLocationLng, startLocationLng) ||
                other.startLocationLng == startLocationLng) &&
            (identical(other.startAddress, startAddress) ||
                other.startAddress == startAddress) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality().equals(other._stops, _stops));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    volunteerId,
    status,
    totalDistance,
    totalDuration,
    optimized,
    optimizationAlgorithm,
    startLocationLat,
    startLocationLng,
    startAddress,
    notes,
    createdAt,
    updatedAt,
    startedAt,
    completedAt,
    const DeepCollectionEquality().hash(_stops),
  );

  /// Create a copy of DeliveryRoute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryRouteImplCopyWith<_$DeliveryRouteImpl> get copyWith =>
      __$$DeliveryRouteImplCopyWithImpl<_$DeliveryRouteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryRouteImplToJson(this);
  }
}

abstract class _DeliveryRoute implements DeliveryRoute {
  const factory _DeliveryRoute({
    required final String id,
    required final String volunteerId,
    required final RouteStatus status,
    final double? totalDistance,
    final int? totalDuration,
    final bool optimized,
    final String? optimizationAlgorithm,
    final double? startLocationLat,
    final double? startLocationLng,
    final String? startAddress,
    final String? notes,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? startedAt,
    final DateTime? completedAt,
    final List<RouteStop> stops,
  }) = _$DeliveryRouteImpl;

  factory _DeliveryRoute.fromJson(Map<String, dynamic> json) =
      _$DeliveryRouteImpl.fromJson;

  @override
  String get id;
  @override
  String get volunteerId;
  @override
  RouteStatus get status;
  @override
  double? get totalDistance; // in kilometers
  @override
  int? get totalDuration; // in minutes
  @override
  bool get optimized;
  @override
  String? get optimizationAlgorithm;
  @override
  double? get startLocationLat;
  @override
  double? get startLocationLng;
  @override
  String? get startAddress;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get completedAt;
  @override
  List<RouteStop> get stops;

  /// Create a copy of DeliveryRoute
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryRouteImplCopyWith<_$DeliveryRouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteStop _$RouteStopFromJson(Map<String, dynamic> json) {
  return _RouteStop.fromJson(json);
}

/// @nodoc
mixin _$RouteStop {
  String get id => throw _privateConstructorUsedError;
  String get routeId => throw _privateConstructorUsedError;
  String? get deliveryId => throw _privateConstructorUsedError;
  StopType get stopType => throw _privateConstructorUsedError;
  int get sequenceOrder => throw _privateConstructorUsedError;
  double get locationLat => throw _privateConstructorUsedError;
  double get locationLng => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get contactName => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  DateTime? get estimatedArrival => throw _privateConstructorUsedError;
  DateTime? get actualArrival => throw _privateConstructorUsedError;
  int? get estimatedDuration =>
      throw _privateConstructorUsedError; // minutes at this stop
  double? get distanceFromPrevious => throw _privateConstructorUsedError; // km
  int? get durationFromPrevious =>
      throw _privateConstructorUsedError; // minutes
  StopStatus get status => throw _privateConstructorUsedError;
  String? get completionNotes => throw _privateConstructorUsedError;
  String? get completionPhotoUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RouteStop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteStopCopyWith<RouteStop> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteStopCopyWith<$Res> {
  factory $RouteStopCopyWith(RouteStop value, $Res Function(RouteStop) then) =
      _$RouteStopCopyWithImpl<$Res, RouteStop>;
  @useResult
  $Res call({
    String id,
    String routeId,
    String? deliveryId,
    StopType stopType,
    int sequenceOrder,
    double locationLat,
    double locationLng,
    String address,
    String? contactName,
    String? contactPhone,
    DateTime? estimatedArrival,
    DateTime? actualArrival,
    int? estimatedDuration,
    double? distanceFromPrevious,
    int? durationFromPrevious,
    StopStatus status,
    String? completionNotes,
    String? completionPhotoUrl,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$RouteStopCopyWithImpl<$Res, $Val extends RouteStop>
    implements $RouteStopCopyWith<$Res> {
  _$RouteStopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = null,
    Object? deliveryId = freezed,
    Object? stopType = null,
    Object? sequenceOrder = null,
    Object? locationLat = null,
    Object? locationLng = null,
    Object? address = null,
    Object? contactName = freezed,
    Object? contactPhone = freezed,
    Object? estimatedArrival = freezed,
    Object? actualArrival = freezed,
    Object? estimatedDuration = freezed,
    Object? distanceFromPrevious = freezed,
    Object? durationFromPrevious = freezed,
    Object? status = null,
    Object? completionNotes = freezed,
    Object? completionPhotoUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            routeId: null == routeId
                ? _value.routeId
                : routeId // ignore: cast_nullable_to_non_nullable
                      as String,
            deliveryId: freezed == deliveryId
                ? _value.deliveryId
                : deliveryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            stopType: null == stopType
                ? _value.stopType
                : stopType // ignore: cast_nullable_to_non_nullable
                      as StopType,
            sequenceOrder: null == sequenceOrder
                ? _value.sequenceOrder
                : sequenceOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            locationLat: null == locationLat
                ? _value.locationLat
                : locationLat // ignore: cast_nullable_to_non_nullable
                      as double,
            locationLng: null == locationLng
                ? _value.locationLng
                : locationLng // ignore: cast_nullable_to_non_nullable
                      as double,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            contactName: freezed == contactName
                ? _value.contactName
                : contactName // ignore: cast_nullable_to_non_nullable
                      as String?,
            contactPhone: freezed == contactPhone
                ? _value.contactPhone
                : contactPhone // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedArrival: freezed == estimatedArrival
                ? _value.estimatedArrival
                : estimatedArrival // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            actualArrival: freezed == actualArrival
                ? _value.actualArrival
                : actualArrival // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            estimatedDuration: freezed == estimatedDuration
                ? _value.estimatedDuration
                : estimatedDuration // ignore: cast_nullable_to_non_nullable
                      as int?,
            distanceFromPrevious: freezed == distanceFromPrevious
                ? _value.distanceFromPrevious
                : distanceFromPrevious // ignore: cast_nullable_to_non_nullable
                      as double?,
            durationFromPrevious: freezed == durationFromPrevious
                ? _value.durationFromPrevious
                : durationFromPrevious // ignore: cast_nullable_to_non_nullable
                      as int?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as StopStatus,
            completionNotes: freezed == completionNotes
                ? _value.completionNotes
                : completionNotes // ignore: cast_nullable_to_non_nullable
                      as String?,
            completionPhotoUrl: freezed == completionPhotoUrl
                ? _value.completionPhotoUrl
                : completionPhotoUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$RouteStopImplCopyWith<$Res>
    implements $RouteStopCopyWith<$Res> {
  factory _$$RouteStopImplCopyWith(
    _$RouteStopImpl value,
    $Res Function(_$RouteStopImpl) then,
  ) = __$$RouteStopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String routeId,
    String? deliveryId,
    StopType stopType,
    int sequenceOrder,
    double locationLat,
    double locationLng,
    String address,
    String? contactName,
    String? contactPhone,
    DateTime? estimatedArrival,
    DateTime? actualArrival,
    int? estimatedDuration,
    double? distanceFromPrevious,
    int? durationFromPrevious,
    StopStatus status,
    String? completionNotes,
    String? completionPhotoUrl,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$RouteStopImplCopyWithImpl<$Res>
    extends _$RouteStopCopyWithImpl<$Res, _$RouteStopImpl>
    implements _$$RouteStopImplCopyWith<$Res> {
  __$$RouteStopImplCopyWithImpl(
    _$RouteStopImpl _value,
    $Res Function(_$RouteStopImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = null,
    Object? deliveryId = freezed,
    Object? stopType = null,
    Object? sequenceOrder = null,
    Object? locationLat = null,
    Object? locationLng = null,
    Object? address = null,
    Object? contactName = freezed,
    Object? contactPhone = freezed,
    Object? estimatedArrival = freezed,
    Object? actualArrival = freezed,
    Object? estimatedDuration = freezed,
    Object? distanceFromPrevious = freezed,
    Object? durationFromPrevious = freezed,
    Object? status = null,
    Object? completionNotes = freezed,
    Object? completionPhotoUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$RouteStopImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        routeId: null == routeId
            ? _value.routeId
            : routeId // ignore: cast_nullable_to_non_nullable
                  as String,
        deliveryId: freezed == deliveryId
            ? _value.deliveryId
            : deliveryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        stopType: null == stopType
            ? _value.stopType
            : stopType // ignore: cast_nullable_to_non_nullable
                  as StopType,
        sequenceOrder: null == sequenceOrder
            ? _value.sequenceOrder
            : sequenceOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        locationLat: null == locationLat
            ? _value.locationLat
            : locationLat // ignore: cast_nullable_to_non_nullable
                  as double,
        locationLng: null == locationLng
            ? _value.locationLng
            : locationLng // ignore: cast_nullable_to_non_nullable
                  as double,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        contactName: freezed == contactName
            ? _value.contactName
            : contactName // ignore: cast_nullable_to_non_nullable
                  as String?,
        contactPhone: freezed == contactPhone
            ? _value.contactPhone
            : contactPhone // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedArrival: freezed == estimatedArrival
            ? _value.estimatedArrival
            : estimatedArrival // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        actualArrival: freezed == actualArrival
            ? _value.actualArrival
            : actualArrival // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        estimatedDuration: freezed == estimatedDuration
            ? _value.estimatedDuration
            : estimatedDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
        distanceFromPrevious: freezed == distanceFromPrevious
            ? _value.distanceFromPrevious
            : distanceFromPrevious // ignore: cast_nullable_to_non_nullable
                  as double?,
        durationFromPrevious: freezed == durationFromPrevious
            ? _value.durationFromPrevious
            : durationFromPrevious // ignore: cast_nullable_to_non_nullable
                  as int?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as StopStatus,
        completionNotes: freezed == completionNotes
            ? _value.completionNotes
            : completionNotes // ignore: cast_nullable_to_non_nullable
                  as String?,
        completionPhotoUrl: freezed == completionPhotoUrl
            ? _value.completionPhotoUrl
            : completionPhotoUrl // ignore: cast_nullable_to_non_nullable
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
class _$RouteStopImpl implements _RouteStop {
  const _$RouteStopImpl({
    required this.id,
    required this.routeId,
    this.deliveryId,
    required this.stopType,
    required this.sequenceOrder,
    required this.locationLat,
    required this.locationLng,
    required this.address,
    this.contactName,
    this.contactPhone,
    this.estimatedArrival,
    this.actualArrival,
    this.estimatedDuration,
    this.distanceFromPrevious,
    this.durationFromPrevious,
    this.status = StopStatus.pending,
    this.completionNotes,
    this.completionPhotoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory _$RouteStopImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteStopImplFromJson(json);

  @override
  final String id;
  @override
  final String routeId;
  @override
  final String? deliveryId;
  @override
  final StopType stopType;
  @override
  final int sequenceOrder;
  @override
  final double locationLat;
  @override
  final double locationLng;
  @override
  final String address;
  @override
  final String? contactName;
  @override
  final String? contactPhone;
  @override
  final DateTime? estimatedArrival;
  @override
  final DateTime? actualArrival;
  @override
  final int? estimatedDuration;
  // minutes at this stop
  @override
  final double? distanceFromPrevious;
  // km
  @override
  final int? durationFromPrevious;
  // minutes
  @override
  @JsonKey()
  final StopStatus status;
  @override
  final String? completionNotes;
  @override
  final String? completionPhotoUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'RouteStop(id: $id, routeId: $routeId, deliveryId: $deliveryId, stopType: $stopType, sequenceOrder: $sequenceOrder, locationLat: $locationLat, locationLng: $locationLng, address: $address, contactName: $contactName, contactPhone: $contactPhone, estimatedArrival: $estimatedArrival, actualArrival: $actualArrival, estimatedDuration: $estimatedDuration, distanceFromPrevious: $distanceFromPrevious, durationFromPrevious: $durationFromPrevious, status: $status, completionNotes: $completionNotes, completionPhotoUrl: $completionPhotoUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteStopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.deliveryId, deliveryId) ||
                other.deliveryId == deliveryId) &&
            (identical(other.stopType, stopType) ||
                other.stopType == stopType) &&
            (identical(other.sequenceOrder, sequenceOrder) ||
                other.sequenceOrder == sequenceOrder) &&
            (identical(other.locationLat, locationLat) ||
                other.locationLat == locationLat) &&
            (identical(other.locationLng, locationLng) ||
                other.locationLng == locationLng) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.contactName, contactName) ||
                other.contactName == contactName) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.estimatedArrival, estimatedArrival) ||
                other.estimatedArrival == estimatedArrival) &&
            (identical(other.actualArrival, actualArrival) ||
                other.actualArrival == actualArrival) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.distanceFromPrevious, distanceFromPrevious) ||
                other.distanceFromPrevious == distanceFromPrevious) &&
            (identical(other.durationFromPrevious, durationFromPrevious) ||
                other.durationFromPrevious == durationFromPrevious) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.completionNotes, completionNotes) ||
                other.completionNotes == completionNotes) &&
            (identical(other.completionPhotoUrl, completionPhotoUrl) ||
                other.completionPhotoUrl == completionPhotoUrl) &&
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
    routeId,
    deliveryId,
    stopType,
    sequenceOrder,
    locationLat,
    locationLng,
    address,
    contactName,
    contactPhone,
    estimatedArrival,
    actualArrival,
    estimatedDuration,
    distanceFromPrevious,
    durationFromPrevious,
    status,
    completionNotes,
    completionPhotoUrl,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteStopImplCopyWith<_$RouteStopImpl> get copyWith =>
      __$$RouteStopImplCopyWithImpl<_$RouteStopImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteStopImplToJson(this);
  }
}

abstract class _RouteStop implements RouteStop {
  const factory _RouteStop({
    required final String id,
    required final String routeId,
    final String? deliveryId,
    required final StopType stopType,
    required final int sequenceOrder,
    required final double locationLat,
    required final double locationLng,
    required final String address,
    final String? contactName,
    final String? contactPhone,
    final DateTime? estimatedArrival,
    final DateTime? actualArrival,
    final int? estimatedDuration,
    final double? distanceFromPrevious,
    final int? durationFromPrevious,
    final StopStatus status,
    final String? completionNotes,
    final String? completionPhotoUrl,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$RouteStopImpl;

  factory _RouteStop.fromJson(Map<String, dynamic> json) =
      _$RouteStopImpl.fromJson;

  @override
  String get id;
  @override
  String get routeId;
  @override
  String? get deliveryId;
  @override
  StopType get stopType;
  @override
  int get sequenceOrder;
  @override
  double get locationLat;
  @override
  double get locationLng;
  @override
  String get address;
  @override
  String? get contactName;
  @override
  String? get contactPhone;
  @override
  DateTime? get estimatedArrival;
  @override
  DateTime? get actualArrival;
  @override
  int? get estimatedDuration; // minutes at this stop
  @override
  double? get distanceFromPrevious; // km
  @override
  int? get durationFromPrevious; // minutes
  @override
  StopStatus get status;
  @override
  String? get completionNotes;
  @override
  String? get completionPhotoUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of RouteStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteStopImplCopyWith<_$RouteStopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteCache _$RouteCacheFromJson(Map<String, dynamic> json) {
  return _RouteCache.fromJson(json);
}

/// @nodoc
mixin _$RouteCache {
  String get id => throw _privateConstructorUsedError;
  String get routeId => throw _privateConstructorUsedError;
  String get polyline => throw _privateConstructorUsedError;
  Map<String, dynamic>? get bounds => throw _privateConstructorUsedError;
  Map<String, dynamic>? get trafficData => throw _privateConstructorUsedError;
  DateTime get cachedAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this RouteCache to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteCache
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteCacheCopyWith<RouteCache> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteCacheCopyWith<$Res> {
  factory $RouteCacheCopyWith(
    RouteCache value,
    $Res Function(RouteCache) then,
  ) = _$RouteCacheCopyWithImpl<$Res, RouteCache>;
  @useResult
  $Res call({
    String id,
    String routeId,
    String polyline,
    Map<String, dynamic>? bounds,
    Map<String, dynamic>? trafficData,
    DateTime cachedAt,
    DateTime expiresAt,
  });
}

/// @nodoc
class _$RouteCacheCopyWithImpl<$Res, $Val extends RouteCache>
    implements $RouteCacheCopyWith<$Res> {
  _$RouteCacheCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteCache
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = null,
    Object? polyline = null,
    Object? bounds = freezed,
    Object? trafficData = freezed,
    Object? cachedAt = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            routeId: null == routeId
                ? _value.routeId
                : routeId // ignore: cast_nullable_to_non_nullable
                      as String,
            polyline: null == polyline
                ? _value.polyline
                : polyline // ignore: cast_nullable_to_non_nullable
                      as String,
            bounds: freezed == bounds
                ? _value.bounds
                : bounds // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            trafficData: freezed == trafficData
                ? _value.trafficData
                : trafficData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            cachedAt: null == cachedAt
                ? _value.cachedAt
                : cachedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RouteCacheImplCopyWith<$Res>
    implements $RouteCacheCopyWith<$Res> {
  factory _$$RouteCacheImplCopyWith(
    _$RouteCacheImpl value,
    $Res Function(_$RouteCacheImpl) then,
  ) = __$$RouteCacheImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String routeId,
    String polyline,
    Map<String, dynamic>? bounds,
    Map<String, dynamic>? trafficData,
    DateTime cachedAt,
    DateTime expiresAt,
  });
}

/// @nodoc
class __$$RouteCacheImplCopyWithImpl<$Res>
    extends _$RouteCacheCopyWithImpl<$Res, _$RouteCacheImpl>
    implements _$$RouteCacheImplCopyWith<$Res> {
  __$$RouteCacheImplCopyWithImpl(
    _$RouteCacheImpl _value,
    $Res Function(_$RouteCacheImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteCache
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? routeId = null,
    Object? polyline = null,
    Object? bounds = freezed,
    Object? trafficData = freezed,
    Object? cachedAt = null,
    Object? expiresAt = null,
  }) {
    return _then(
      _$RouteCacheImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        routeId: null == routeId
            ? _value.routeId
            : routeId // ignore: cast_nullable_to_non_nullable
                  as String,
        polyline: null == polyline
            ? _value.polyline
            : polyline // ignore: cast_nullable_to_non_nullable
                  as String,
        bounds: freezed == bounds
            ? _value._bounds
            : bounds // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        trafficData: freezed == trafficData
            ? _value._trafficData
            : trafficData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        cachedAt: null == cachedAt
            ? _value.cachedAt
            : cachedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteCacheImpl implements _RouteCache {
  const _$RouteCacheImpl({
    required this.id,
    required this.routeId,
    required this.polyline,
    final Map<String, dynamic>? bounds,
    final Map<String, dynamic>? trafficData,
    required this.cachedAt,
    required this.expiresAt,
  }) : _bounds = bounds,
       _trafficData = trafficData;

  factory _$RouteCacheImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteCacheImplFromJson(json);

  @override
  final String id;
  @override
  final String routeId;
  @override
  final String polyline;
  final Map<String, dynamic>? _bounds;
  @override
  Map<String, dynamic>? get bounds {
    final value = _bounds;
    if (value == null) return null;
    if (_bounds is EqualUnmodifiableMapView) return _bounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _trafficData;
  @override
  Map<String, dynamic>? get trafficData {
    final value = _trafficData;
    if (value == null) return null;
    if (_trafficData is EqualUnmodifiableMapView) return _trafficData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime cachedAt;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'RouteCache(id: $id, routeId: $routeId, polyline: $polyline, bounds: $bounds, trafficData: $trafficData, cachedAt: $cachedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteCacheImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.polyline, polyline) ||
                other.polyline == polyline) &&
            const DeepCollectionEquality().equals(other._bounds, _bounds) &&
            const DeepCollectionEquality().equals(
              other._trafficData,
              _trafficData,
            ) &&
            (identical(other.cachedAt, cachedAt) ||
                other.cachedAt == cachedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    routeId,
    polyline,
    const DeepCollectionEquality().hash(_bounds),
    const DeepCollectionEquality().hash(_trafficData),
    cachedAt,
    expiresAt,
  );

  /// Create a copy of RouteCache
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteCacheImplCopyWith<_$RouteCacheImpl> get copyWith =>
      __$$RouteCacheImplCopyWithImpl<_$RouteCacheImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteCacheImplToJson(this);
  }
}

abstract class _RouteCache implements RouteCache {
  const factory _RouteCache({
    required final String id,
    required final String routeId,
    required final String polyline,
    final Map<String, dynamic>? bounds,
    final Map<String, dynamic>? trafficData,
    required final DateTime cachedAt,
    required final DateTime expiresAt,
  }) = _$RouteCacheImpl;

  factory _RouteCache.fromJson(Map<String, dynamic> json) =
      _$RouteCacheImpl.fromJson;

  @override
  String get id;
  @override
  String get routeId;
  @override
  String get polyline;
  @override
  Map<String, dynamic>? get bounds;
  @override
  Map<String, dynamic>? get trafficData;
  @override
  DateTime get cachedAt;
  @override
  DateTime get expiresAt;

  /// Create a copy of RouteCache
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteCacheImplCopyWith<_$RouteCacheImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VolunteerLocation _$VolunteerLocationFromJson(Map<String, dynamic> json) {
  return _VolunteerLocation.fromJson(json);
}

/// @nodoc
mixin _$VolunteerLocation {
  String get id => throw _privateConstructorUsedError;
  String get volunteerId => throw _privateConstructorUsedError;
  String? get routeId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get accuracy => throw _privateConstructorUsedError;
  double? get altitude => throw _privateConstructorUsedError;
  double? get speed => throw _privateConstructorUsedError;
  double? get heading => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this VolunteerLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VolunteerLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VolunteerLocationCopyWith<VolunteerLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VolunteerLocationCopyWith<$Res> {
  factory $VolunteerLocationCopyWith(
    VolunteerLocation value,
    $Res Function(VolunteerLocation) then,
  ) = _$VolunteerLocationCopyWithImpl<$Res, VolunteerLocation>;
  @useResult
  $Res call({
    String id,
    String volunteerId,
    String? routeId,
    double latitude,
    double longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
    DateTime timestamp,
    DateTime createdAt,
  });
}

/// @nodoc
class _$VolunteerLocationCopyWithImpl<$Res, $Val extends VolunteerLocation>
    implements $VolunteerLocationCopyWith<$Res> {
  _$VolunteerLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VolunteerLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? volunteerId = null,
    Object? routeId = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracy = freezed,
    Object? altitude = freezed,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? timestamp = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            volunteerId: null == volunteerId
                ? _value.volunteerId
                : volunteerId // ignore: cast_nullable_to_non_nullable
                      as String,
            routeId: freezed == routeId
                ? _value.routeId
                : routeId // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            accuracy: freezed == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double?,
            altitude: freezed == altitude
                ? _value.altitude
                : altitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            speed: freezed == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                      as double?,
            heading: freezed == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as double?,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VolunteerLocationImplCopyWith<$Res>
    implements $VolunteerLocationCopyWith<$Res> {
  factory _$$VolunteerLocationImplCopyWith(
    _$VolunteerLocationImpl value,
    $Res Function(_$VolunteerLocationImpl) then,
  ) = __$$VolunteerLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String volunteerId,
    String? routeId,
    double latitude,
    double longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
    DateTime timestamp,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$VolunteerLocationImplCopyWithImpl<$Res>
    extends _$VolunteerLocationCopyWithImpl<$Res, _$VolunteerLocationImpl>
    implements _$$VolunteerLocationImplCopyWith<$Res> {
  __$$VolunteerLocationImplCopyWithImpl(
    _$VolunteerLocationImpl _value,
    $Res Function(_$VolunteerLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VolunteerLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? volunteerId = null,
    Object? routeId = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? accuracy = freezed,
    Object? altitude = freezed,
    Object? speed = freezed,
    Object? heading = freezed,
    Object? timestamp = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$VolunteerLocationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        volunteerId: null == volunteerId
            ? _value.volunteerId
            : volunteerId // ignore: cast_nullable_to_non_nullable
                  as String,
        routeId: freezed == routeId
            ? _value.routeId
            : routeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        accuracy: freezed == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double?,
        altitude: freezed == altitude
            ? _value.altitude
            : altitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        speed: freezed == speed
            ? _value.speed
            : speed // ignore: cast_nullable_to_non_nullable
                  as double?,
        heading: freezed == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as double?,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VolunteerLocationImpl implements _VolunteerLocation {
  const _$VolunteerLocationImpl({
    required this.id,
    required this.volunteerId,
    this.routeId,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    this.heading,
    required this.timestamp,
    required this.createdAt,
  });

  factory _$VolunteerLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$VolunteerLocationImplFromJson(json);

  @override
  final String id;
  @override
  final String volunteerId;
  @override
  final String? routeId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? accuracy;
  @override
  final double? altitude;
  @override
  final double? speed;
  @override
  final double? heading;
  @override
  final DateTime timestamp;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'VolunteerLocation(id: $id, volunteerId: $volunteerId, routeId: $routeId, latitude: $latitude, longitude: $longitude, accuracy: $accuracy, altitude: $altitude, speed: $speed, heading: $heading, timestamp: $timestamp, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VolunteerLocationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.volunteerId, volunteerId) ||
                other.volunteerId == volunteerId) &&
            (identical(other.routeId, routeId) || other.routeId == routeId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.altitude, altitude) ||
                other.altitude == altitude) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    volunteerId,
    routeId,
    latitude,
    longitude,
    accuracy,
    altitude,
    speed,
    heading,
    timestamp,
    createdAt,
  );

  /// Create a copy of VolunteerLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VolunteerLocationImplCopyWith<_$VolunteerLocationImpl> get copyWith =>
      __$$VolunteerLocationImplCopyWithImpl<_$VolunteerLocationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VolunteerLocationImplToJson(this);
  }
}

abstract class _VolunteerLocation implements VolunteerLocation {
  const factory _VolunteerLocation({
    required final String id,
    required final String volunteerId,
    final String? routeId,
    required final double latitude,
    required final double longitude,
    final double? accuracy,
    final double? altitude,
    final double? speed,
    final double? heading,
    required final DateTime timestamp,
    required final DateTime createdAt,
  }) = _$VolunteerLocationImpl;

  factory _VolunteerLocation.fromJson(Map<String, dynamic> json) =
      _$VolunteerLocationImpl.fromJson;

  @override
  String get id;
  @override
  String get volunteerId;
  @override
  String? get routeId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get accuracy;
  @override
  double? get altitude;
  @override
  double? get speed;
  @override
  double? get heading;
  @override
  DateTime get timestamp;
  @override
  DateTime get createdAt;

  /// Create a copy of VolunteerLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VolunteerLocationImplCopyWith<_$VolunteerLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteOptimizationResult _$RouteOptimizationResultFromJson(
  Map<String, dynamic> json,
) {
  return _RouteOptimizationResult.fromJson(json);
}

/// @nodoc
mixin _$RouteOptimizationResult {
  List<RouteStop> get optimizedStops => throw _privateConstructorUsedError;
  double get totalDistance => throw _privateConstructorUsedError;
  int get totalDuration => throw _privateConstructorUsedError;
  double get distanceSaved => throw _privateConstructorUsedError;
  int get timeSaved => throw _privateConstructorUsedError;
  String get algorithm => throw _privateConstructorUsedError;
  int get optimizationTimeMs => throw _privateConstructorUsedError;

  /// Serializes this RouteOptimizationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteOptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteOptimizationResultCopyWith<RouteOptimizationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteOptimizationResultCopyWith<$Res> {
  factory $RouteOptimizationResultCopyWith(
    RouteOptimizationResult value,
    $Res Function(RouteOptimizationResult) then,
  ) = _$RouteOptimizationResultCopyWithImpl<$Res, RouteOptimizationResult>;
  @useResult
  $Res call({
    List<RouteStop> optimizedStops,
    double totalDistance,
    int totalDuration,
    double distanceSaved,
    int timeSaved,
    String algorithm,
    int optimizationTimeMs,
  });
}

/// @nodoc
class _$RouteOptimizationResultCopyWithImpl<
  $Res,
  $Val extends RouteOptimizationResult
>
    implements $RouteOptimizationResultCopyWith<$Res> {
  _$RouteOptimizationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteOptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optimizedStops = null,
    Object? totalDistance = null,
    Object? totalDuration = null,
    Object? distanceSaved = null,
    Object? timeSaved = null,
    Object? algorithm = null,
    Object? optimizationTimeMs = null,
  }) {
    return _then(
      _value.copyWith(
            optimizedStops: null == optimizedStops
                ? _value.optimizedStops
                : optimizedStops // ignore: cast_nullable_to_non_nullable
                      as List<RouteStop>,
            totalDistance: null == totalDistance
                ? _value.totalDistance
                : totalDistance // ignore: cast_nullable_to_non_nullable
                      as double,
            totalDuration: null == totalDuration
                ? _value.totalDuration
                : totalDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            distanceSaved: null == distanceSaved
                ? _value.distanceSaved
                : distanceSaved // ignore: cast_nullable_to_non_nullable
                      as double,
            timeSaved: null == timeSaved
                ? _value.timeSaved
                : timeSaved // ignore: cast_nullable_to_non_nullable
                      as int,
            algorithm: null == algorithm
                ? _value.algorithm
                : algorithm // ignore: cast_nullable_to_non_nullable
                      as String,
            optimizationTimeMs: null == optimizationTimeMs
                ? _value.optimizationTimeMs
                : optimizationTimeMs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RouteOptimizationResultImplCopyWith<$Res>
    implements $RouteOptimizationResultCopyWith<$Res> {
  factory _$$RouteOptimizationResultImplCopyWith(
    _$RouteOptimizationResultImpl value,
    $Res Function(_$RouteOptimizationResultImpl) then,
  ) = __$$RouteOptimizationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<RouteStop> optimizedStops,
    double totalDistance,
    int totalDuration,
    double distanceSaved,
    int timeSaved,
    String algorithm,
    int optimizationTimeMs,
  });
}

/// @nodoc
class __$$RouteOptimizationResultImplCopyWithImpl<$Res>
    extends
        _$RouteOptimizationResultCopyWithImpl<
          $Res,
          _$RouteOptimizationResultImpl
        >
    implements _$$RouteOptimizationResultImplCopyWith<$Res> {
  __$$RouteOptimizationResultImplCopyWithImpl(
    _$RouteOptimizationResultImpl _value,
    $Res Function(_$RouteOptimizationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteOptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optimizedStops = null,
    Object? totalDistance = null,
    Object? totalDuration = null,
    Object? distanceSaved = null,
    Object? timeSaved = null,
    Object? algorithm = null,
    Object? optimizationTimeMs = null,
  }) {
    return _then(
      _$RouteOptimizationResultImpl(
        optimizedStops: null == optimizedStops
            ? _value._optimizedStops
            : optimizedStops // ignore: cast_nullable_to_non_nullable
                  as List<RouteStop>,
        totalDistance: null == totalDistance
            ? _value.totalDistance
            : totalDistance // ignore: cast_nullable_to_non_nullable
                  as double,
        totalDuration: null == totalDuration
            ? _value.totalDuration
            : totalDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        distanceSaved: null == distanceSaved
            ? _value.distanceSaved
            : distanceSaved // ignore: cast_nullable_to_non_nullable
                  as double,
        timeSaved: null == timeSaved
            ? _value.timeSaved
            : timeSaved // ignore: cast_nullable_to_non_nullable
                  as int,
        algorithm: null == algorithm
            ? _value.algorithm
            : algorithm // ignore: cast_nullable_to_non_nullable
                  as String,
        optimizationTimeMs: null == optimizationTimeMs
            ? _value.optimizationTimeMs
            : optimizationTimeMs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteOptimizationResultImpl implements _RouteOptimizationResult {
  const _$RouteOptimizationResultImpl({
    required final List<RouteStop> optimizedStops,
    required this.totalDistance,
    required this.totalDuration,
    required this.distanceSaved,
    required this.timeSaved,
    required this.algorithm,
    required this.optimizationTimeMs,
  }) : _optimizedStops = optimizedStops;

  factory _$RouteOptimizationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteOptimizationResultImplFromJson(json);

  final List<RouteStop> _optimizedStops;
  @override
  List<RouteStop> get optimizedStops {
    if (_optimizedStops is EqualUnmodifiableListView) return _optimizedStops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_optimizedStops);
  }

  @override
  final double totalDistance;
  @override
  final int totalDuration;
  @override
  final double distanceSaved;
  @override
  final int timeSaved;
  @override
  final String algorithm;
  @override
  final int optimizationTimeMs;

  @override
  String toString() {
    return 'RouteOptimizationResult(optimizedStops: $optimizedStops, totalDistance: $totalDistance, totalDuration: $totalDuration, distanceSaved: $distanceSaved, timeSaved: $timeSaved, algorithm: $algorithm, optimizationTimeMs: $optimizationTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteOptimizationResultImpl &&
            const DeepCollectionEquality().equals(
              other._optimizedStops,
              _optimizedStops,
            ) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration) &&
            (identical(other.distanceSaved, distanceSaved) ||
                other.distanceSaved == distanceSaved) &&
            (identical(other.timeSaved, timeSaved) ||
                other.timeSaved == timeSaved) &&
            (identical(other.algorithm, algorithm) ||
                other.algorithm == algorithm) &&
            (identical(other.optimizationTimeMs, optimizationTimeMs) ||
                other.optimizationTimeMs == optimizationTimeMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_optimizedStops),
    totalDistance,
    totalDuration,
    distanceSaved,
    timeSaved,
    algorithm,
    optimizationTimeMs,
  );

  /// Create a copy of RouteOptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteOptimizationResultImplCopyWith<_$RouteOptimizationResultImpl>
  get copyWith =>
      __$$RouteOptimizationResultImplCopyWithImpl<
        _$RouteOptimizationResultImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteOptimizationResultImplToJson(this);
  }
}

abstract class _RouteOptimizationResult implements RouteOptimizationResult {
  const factory _RouteOptimizationResult({
    required final List<RouteStop> optimizedStops,
    required final double totalDistance,
    required final int totalDuration,
    required final double distanceSaved,
    required final int timeSaved,
    required final String algorithm,
    required final int optimizationTimeMs,
  }) = _$RouteOptimizationResultImpl;

  factory _RouteOptimizationResult.fromJson(Map<String, dynamic> json) =
      _$RouteOptimizationResultImpl.fromJson;

  @override
  List<RouteStop> get optimizedStops;
  @override
  double get totalDistance;
  @override
  int get totalDuration;
  @override
  double get distanceSaved;
  @override
  int get timeSaved;
  @override
  String get algorithm;
  @override
  int get optimizationTimeMs;

  /// Create a copy of RouteOptimizationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteOptimizationResultImplCopyWith<_$RouteOptimizationResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}

RouteStatistics _$RouteStatisticsFromJson(Map<String, dynamic> json) {
  return _RouteStatistics.fromJson(json);
}

/// @nodoc
mixin _$RouteStatistics {
  int get totalStops => throw _privateConstructorUsedError;
  int get completedStops => throw _privateConstructorUsedError;
  int get pendingStops => throw _privateConstructorUsedError;
  double get totalDistance => throw _privateConstructorUsedError;
  int get totalDuration => throw _privateConstructorUsedError;

  /// Serializes this RouteStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteStatisticsCopyWith<RouteStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteStatisticsCopyWith<$Res> {
  factory $RouteStatisticsCopyWith(
    RouteStatistics value,
    $Res Function(RouteStatistics) then,
  ) = _$RouteStatisticsCopyWithImpl<$Res, RouteStatistics>;
  @useResult
  $Res call({
    int totalStops,
    int completedStops,
    int pendingStops,
    double totalDistance,
    int totalDuration,
  });
}

/// @nodoc
class _$RouteStatisticsCopyWithImpl<$Res, $Val extends RouteStatistics>
    implements $RouteStatisticsCopyWith<$Res> {
  _$RouteStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalStops = null,
    Object? completedStops = null,
    Object? pendingStops = null,
    Object? totalDistance = null,
    Object? totalDuration = null,
  }) {
    return _then(
      _value.copyWith(
            totalStops: null == totalStops
                ? _value.totalStops
                : totalStops // ignore: cast_nullable_to_non_nullable
                      as int,
            completedStops: null == completedStops
                ? _value.completedStops
                : completedStops // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingStops: null == pendingStops
                ? _value.pendingStops
                : pendingStops // ignore: cast_nullable_to_non_nullable
                      as int,
            totalDistance: null == totalDistance
                ? _value.totalDistance
                : totalDistance // ignore: cast_nullable_to_non_nullable
                      as double,
            totalDuration: null == totalDuration
                ? _value.totalDuration
                : totalDuration // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RouteStatisticsImplCopyWith<$Res>
    implements $RouteStatisticsCopyWith<$Res> {
  factory _$$RouteStatisticsImplCopyWith(
    _$RouteStatisticsImpl value,
    $Res Function(_$RouteStatisticsImpl) then,
  ) = __$$RouteStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalStops,
    int completedStops,
    int pendingStops,
    double totalDistance,
    int totalDuration,
  });
}

/// @nodoc
class __$$RouteStatisticsImplCopyWithImpl<$Res>
    extends _$RouteStatisticsCopyWithImpl<$Res, _$RouteStatisticsImpl>
    implements _$$RouteStatisticsImplCopyWith<$Res> {
  __$$RouteStatisticsImplCopyWithImpl(
    _$RouteStatisticsImpl _value,
    $Res Function(_$RouteStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalStops = null,
    Object? completedStops = null,
    Object? pendingStops = null,
    Object? totalDistance = null,
    Object? totalDuration = null,
  }) {
    return _then(
      _$RouteStatisticsImpl(
        totalStops: null == totalStops
            ? _value.totalStops
            : totalStops // ignore: cast_nullable_to_non_nullable
                  as int,
        completedStops: null == completedStops
            ? _value.completedStops
            : completedStops // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingStops: null == pendingStops
            ? _value.pendingStops
            : pendingStops // ignore: cast_nullable_to_non_nullable
                  as int,
        totalDistance: null == totalDistance
            ? _value.totalDistance
            : totalDistance // ignore: cast_nullable_to_non_nullable
                  as double,
        totalDuration: null == totalDuration
            ? _value.totalDuration
            : totalDuration // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteStatisticsImpl implements _RouteStatistics {
  const _$RouteStatisticsImpl({
    required this.totalStops,
    required this.completedStops,
    required this.pendingStops,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory _$RouteStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteStatisticsImplFromJson(json);

  @override
  final int totalStops;
  @override
  final int completedStops;
  @override
  final int pendingStops;
  @override
  final double totalDistance;
  @override
  final int totalDuration;

  @override
  String toString() {
    return 'RouteStatistics(totalStops: $totalStops, completedStops: $completedStops, pendingStops: $pendingStops, totalDistance: $totalDistance, totalDuration: $totalDuration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteStatisticsImpl &&
            (identical(other.totalStops, totalStops) ||
                other.totalStops == totalStops) &&
            (identical(other.completedStops, completedStops) ||
                other.completedStops == completedStops) &&
            (identical(other.pendingStops, pendingStops) ||
                other.pendingStops == pendingStops) &&
            (identical(other.totalDistance, totalDistance) ||
                other.totalDistance == totalDistance) &&
            (identical(other.totalDuration, totalDuration) ||
                other.totalDuration == totalDuration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalStops,
    completedStops,
    pendingStops,
    totalDistance,
    totalDuration,
  );

  /// Create a copy of RouteStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteStatisticsImplCopyWith<_$RouteStatisticsImpl> get copyWith =>
      __$$RouteStatisticsImplCopyWithImpl<_$RouteStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteStatisticsImplToJson(this);
  }
}

abstract class _RouteStatistics implements RouteStatistics {
  const factory _RouteStatistics({
    required final int totalStops,
    required final int completedStops,
    required final int pendingStops,
    required final double totalDistance,
    required final int totalDuration,
  }) = _$RouteStatisticsImpl;

  factory _RouteStatistics.fromJson(Map<String, dynamic> json) =
      _$RouteStatisticsImpl.fromJson;

  @override
  int get totalStops;
  @override
  int get completedStops;
  @override
  int get pendingStops;
  @override
  double get totalDistance;
  @override
  int get totalDuration;

  /// Create a copy of RouteStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteStatisticsImplCopyWith<_$RouteStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DirectionStep _$DirectionStepFromJson(Map<String, dynamic> json) {
  return _DirectionStep.fromJson(json);
}

/// @nodoc
mixin _$DirectionStep {
  String get instructions => throw _privateConstructorUsedError;
  double get distanceMeters => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  LocationPoint get startLocation => throw _privateConstructorUsedError;
  LocationPoint get endLocation => throw _privateConstructorUsedError;
  String? get polyline => throw _privateConstructorUsedError;
  String? get maneuver => throw _privateConstructorUsedError;

  /// Serializes this DirectionStep to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DirectionStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DirectionStepCopyWith<DirectionStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DirectionStepCopyWith<$Res> {
  factory $DirectionStepCopyWith(
    DirectionStep value,
    $Res Function(DirectionStep) then,
  ) = _$DirectionStepCopyWithImpl<$Res, DirectionStep>;
  @useResult
  $Res call({
    String instructions,
    double distanceMeters,
    int durationSeconds,
    LocationPoint startLocation,
    LocationPoint endLocation,
    String? polyline,
    String? maneuver,
  });

  $LocationPointCopyWith<$Res> get startLocation;
  $LocationPointCopyWith<$Res> get endLocation;
}

/// @nodoc
class _$DirectionStepCopyWithImpl<$Res, $Val extends DirectionStep>
    implements $DirectionStepCopyWith<$Res> {
  _$DirectionStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DirectionStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instructions = null,
    Object? distanceMeters = null,
    Object? durationSeconds = null,
    Object? startLocation = null,
    Object? endLocation = null,
    Object? polyline = freezed,
    Object? maneuver = freezed,
  }) {
    return _then(
      _value.copyWith(
            instructions: null == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as String,
            distanceMeters: null == distanceMeters
                ? _value.distanceMeters
                : distanceMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            durationSeconds: null == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            startLocation: null == startLocation
                ? _value.startLocation
                : startLocation // ignore: cast_nullable_to_non_nullable
                      as LocationPoint,
            endLocation: null == endLocation
                ? _value.endLocation
                : endLocation // ignore: cast_nullable_to_non_nullable
                      as LocationPoint,
            polyline: freezed == polyline
                ? _value.polyline
                : polyline // ignore: cast_nullable_to_non_nullable
                      as String?,
            maneuver: freezed == maneuver
                ? _value.maneuver
                : maneuver // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of DirectionStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationPointCopyWith<$Res> get startLocation {
    return $LocationPointCopyWith<$Res>(_value.startLocation, (value) {
      return _then(_value.copyWith(startLocation: value) as $Val);
    });
  }

  /// Create a copy of DirectionStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationPointCopyWith<$Res> get endLocation {
    return $LocationPointCopyWith<$Res>(_value.endLocation, (value) {
      return _then(_value.copyWith(endLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DirectionStepImplCopyWith<$Res>
    implements $DirectionStepCopyWith<$Res> {
  factory _$$DirectionStepImplCopyWith(
    _$DirectionStepImpl value,
    $Res Function(_$DirectionStepImpl) then,
  ) = __$$DirectionStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String instructions,
    double distanceMeters,
    int durationSeconds,
    LocationPoint startLocation,
    LocationPoint endLocation,
    String? polyline,
    String? maneuver,
  });

  @override
  $LocationPointCopyWith<$Res> get startLocation;
  @override
  $LocationPointCopyWith<$Res> get endLocation;
}

/// @nodoc
class __$$DirectionStepImplCopyWithImpl<$Res>
    extends _$DirectionStepCopyWithImpl<$Res, _$DirectionStepImpl>
    implements _$$DirectionStepImplCopyWith<$Res> {
  __$$DirectionStepImplCopyWithImpl(
    _$DirectionStepImpl _value,
    $Res Function(_$DirectionStepImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DirectionStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instructions = null,
    Object? distanceMeters = null,
    Object? durationSeconds = null,
    Object? startLocation = null,
    Object? endLocation = null,
    Object? polyline = freezed,
    Object? maneuver = freezed,
  }) {
    return _then(
      _$DirectionStepImpl(
        instructions: null == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as String,
        distanceMeters: null == distanceMeters
            ? _value.distanceMeters
            : distanceMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        durationSeconds: null == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        startLocation: null == startLocation
            ? _value.startLocation
            : startLocation // ignore: cast_nullable_to_non_nullable
                  as LocationPoint,
        endLocation: null == endLocation
            ? _value.endLocation
            : endLocation // ignore: cast_nullable_to_non_nullable
                  as LocationPoint,
        polyline: freezed == polyline
            ? _value.polyline
            : polyline // ignore: cast_nullable_to_non_nullable
                  as String?,
        maneuver: freezed == maneuver
            ? _value.maneuver
            : maneuver // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DirectionStepImpl implements _DirectionStep {
  const _$DirectionStepImpl({
    required this.instructions,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.startLocation,
    required this.endLocation,
    this.polyline,
    this.maneuver,
  });

  factory _$DirectionStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$DirectionStepImplFromJson(json);

  @override
  final String instructions;
  @override
  final double distanceMeters;
  @override
  final int durationSeconds;
  @override
  final LocationPoint startLocation;
  @override
  final LocationPoint endLocation;
  @override
  final String? polyline;
  @override
  final String? maneuver;

  @override
  String toString() {
    return 'DirectionStep(instructions: $instructions, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds, startLocation: $startLocation, endLocation: $endLocation, polyline: $polyline, maneuver: $maneuver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DirectionStepImpl &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            (identical(other.startLocation, startLocation) ||
                other.startLocation == startLocation) &&
            (identical(other.endLocation, endLocation) ||
                other.endLocation == endLocation) &&
            (identical(other.polyline, polyline) ||
                other.polyline == polyline) &&
            (identical(other.maneuver, maneuver) ||
                other.maneuver == maneuver));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    instructions,
    distanceMeters,
    durationSeconds,
    startLocation,
    endLocation,
    polyline,
    maneuver,
  );

  /// Create a copy of DirectionStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DirectionStepImplCopyWith<_$DirectionStepImpl> get copyWith =>
      __$$DirectionStepImplCopyWithImpl<_$DirectionStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DirectionStepImplToJson(this);
  }
}

abstract class _DirectionStep implements DirectionStep {
  const factory _DirectionStep({
    required final String instructions,
    required final double distanceMeters,
    required final int durationSeconds,
    required final LocationPoint startLocation,
    required final LocationPoint endLocation,
    final String? polyline,
    final String? maneuver,
  }) = _$DirectionStepImpl;

  factory _DirectionStep.fromJson(Map<String, dynamic> json) =
      _$DirectionStepImpl.fromJson;

  @override
  String get instructions;
  @override
  double get distanceMeters;
  @override
  int get durationSeconds;
  @override
  LocationPoint get startLocation;
  @override
  LocationPoint get endLocation;
  @override
  String? get polyline;
  @override
  String? get maneuver;

  /// Create a copy of DirectionStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DirectionStepImplCopyWith<_$DirectionStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteLeg _$RouteLegFromJson(Map<String, dynamic> json) {
  return _RouteLeg.fromJson(json);
}

/// @nodoc
mixin _$RouteLeg {
  LocationPoint get startLocation => throw _privateConstructorUsedError;
  LocationPoint get endLocation => throw _privateConstructorUsedError;
  double get distanceMeters => throw _privateConstructorUsedError;
  int get durationSeconds => throw _privateConstructorUsedError;
  List<DirectionStep> get steps => throw _privateConstructorUsedError;
  String? get polyline => throw _privateConstructorUsedError;

  /// Serializes this RouteLeg to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteLeg
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteLegCopyWith<RouteLeg> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteLegCopyWith<$Res> {
  factory $RouteLegCopyWith(RouteLeg value, $Res Function(RouteLeg) then) =
      _$RouteLegCopyWithImpl<$Res, RouteLeg>;
  @useResult
  $Res call({
    LocationPoint startLocation,
    LocationPoint endLocation,
    double distanceMeters,
    int durationSeconds,
    List<DirectionStep> steps,
    String? polyline,
  });

  $LocationPointCopyWith<$Res> get startLocation;
  $LocationPointCopyWith<$Res> get endLocation;
}

/// @nodoc
class _$RouteLegCopyWithImpl<$Res, $Val extends RouteLeg>
    implements $RouteLegCopyWith<$Res> {
  _$RouteLegCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteLeg
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startLocation = null,
    Object? endLocation = null,
    Object? distanceMeters = null,
    Object? durationSeconds = null,
    Object? steps = null,
    Object? polyline = freezed,
  }) {
    return _then(
      _value.copyWith(
            startLocation: null == startLocation
                ? _value.startLocation
                : startLocation // ignore: cast_nullable_to_non_nullable
                      as LocationPoint,
            endLocation: null == endLocation
                ? _value.endLocation
                : endLocation // ignore: cast_nullable_to_non_nullable
                      as LocationPoint,
            distanceMeters: null == distanceMeters
                ? _value.distanceMeters
                : distanceMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            durationSeconds: null == durationSeconds
                ? _value.durationSeconds
                : durationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            steps: null == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as List<DirectionStep>,
            polyline: freezed == polyline
                ? _value.polyline
                : polyline // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of RouteLeg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationPointCopyWith<$Res> get startLocation {
    return $LocationPointCopyWith<$Res>(_value.startLocation, (value) {
      return _then(_value.copyWith(startLocation: value) as $Val);
    });
  }

  /// Create a copy of RouteLeg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationPointCopyWith<$Res> get endLocation {
    return $LocationPointCopyWith<$Res>(_value.endLocation, (value) {
      return _then(_value.copyWith(endLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RouteLegImplCopyWith<$Res>
    implements $RouteLegCopyWith<$Res> {
  factory _$$RouteLegImplCopyWith(
    _$RouteLegImpl value,
    $Res Function(_$RouteLegImpl) then,
  ) = __$$RouteLegImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LocationPoint startLocation,
    LocationPoint endLocation,
    double distanceMeters,
    int durationSeconds,
    List<DirectionStep> steps,
    String? polyline,
  });

  @override
  $LocationPointCopyWith<$Res> get startLocation;
  @override
  $LocationPointCopyWith<$Res> get endLocation;
}

/// @nodoc
class __$$RouteLegImplCopyWithImpl<$Res>
    extends _$RouteLegCopyWithImpl<$Res, _$RouteLegImpl>
    implements _$$RouteLegImplCopyWith<$Res> {
  __$$RouteLegImplCopyWithImpl(
    _$RouteLegImpl _value,
    $Res Function(_$RouteLegImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteLeg
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startLocation = null,
    Object? endLocation = null,
    Object? distanceMeters = null,
    Object? durationSeconds = null,
    Object? steps = null,
    Object? polyline = freezed,
  }) {
    return _then(
      _$RouteLegImpl(
        startLocation: null == startLocation
            ? _value.startLocation
            : startLocation // ignore: cast_nullable_to_non_nullable
                  as LocationPoint,
        endLocation: null == endLocation
            ? _value.endLocation
            : endLocation // ignore: cast_nullable_to_non_nullable
                  as LocationPoint,
        distanceMeters: null == distanceMeters
            ? _value.distanceMeters
            : distanceMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        durationSeconds: null == durationSeconds
            ? _value.durationSeconds
            : durationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        steps: null == steps
            ? _value._steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as List<DirectionStep>,
        polyline: freezed == polyline
            ? _value.polyline
            : polyline // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteLegImpl implements _RouteLeg {
  const _$RouteLegImpl({
    required this.startLocation,
    required this.endLocation,
    required this.distanceMeters,
    required this.durationSeconds,
    required final List<DirectionStep> steps,
    this.polyline,
  }) : _steps = steps;

  factory _$RouteLegImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteLegImplFromJson(json);

  @override
  final LocationPoint startLocation;
  @override
  final LocationPoint endLocation;
  @override
  final double distanceMeters;
  @override
  final int durationSeconds;
  final List<DirectionStep> _steps;
  @override
  List<DirectionStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final String? polyline;

  @override
  String toString() {
    return 'RouteLeg(startLocation: $startLocation, endLocation: $endLocation, distanceMeters: $distanceMeters, durationSeconds: $durationSeconds, steps: $steps, polyline: $polyline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteLegImpl &&
            (identical(other.startLocation, startLocation) ||
                other.startLocation == startLocation) &&
            (identical(other.endLocation, endLocation) ||
                other.endLocation == endLocation) &&
            (identical(other.distanceMeters, distanceMeters) ||
                other.distanceMeters == distanceMeters) &&
            (identical(other.durationSeconds, durationSeconds) ||
                other.durationSeconds == durationSeconds) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.polyline, polyline) ||
                other.polyline == polyline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    startLocation,
    endLocation,
    distanceMeters,
    durationSeconds,
    const DeepCollectionEquality().hash(_steps),
    polyline,
  );

  /// Create a copy of RouteLeg
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteLegImplCopyWith<_$RouteLegImpl> get copyWith =>
      __$$RouteLegImplCopyWithImpl<_$RouteLegImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteLegImplToJson(this);
  }
}

abstract class _RouteLeg implements RouteLeg {
  const factory _RouteLeg({
    required final LocationPoint startLocation,
    required final LocationPoint endLocation,
    required final double distanceMeters,
    required final int durationSeconds,
    required final List<DirectionStep> steps,
    final String? polyline,
  }) = _$RouteLegImpl;

  factory _RouteLeg.fromJson(Map<String, dynamic> json) =
      _$RouteLegImpl.fromJson;

  @override
  LocationPoint get startLocation;
  @override
  LocationPoint get endLocation;
  @override
  double get distanceMeters;
  @override
  int get durationSeconds;
  @override
  List<DirectionStep> get steps;
  @override
  String? get polyline;

  /// Create a copy of RouteLeg
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteLegImplCopyWith<_$RouteLegImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteDirections _$RouteDirectionsFromJson(Map<String, dynamic> json) {
  return _RouteDirections.fromJson(json);
}

/// @nodoc
mixin _$RouteDirections {
  List<RouteLeg> get legs => throw _privateConstructorUsedError;
  String get overviewPolyline => throw _privateConstructorUsedError;
  double get totalDistanceMeters => throw _privateConstructorUsedError;
  int get totalDurationSeconds => throw _privateConstructorUsedError;
  Map<String, dynamic>? get bounds => throw _privateConstructorUsedError;
  List<String>? get warnings => throw _privateConstructorUsedError;

  /// Serializes this RouteDirections to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RouteDirections
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RouteDirectionsCopyWith<RouteDirections> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteDirectionsCopyWith<$Res> {
  factory $RouteDirectionsCopyWith(
    RouteDirections value,
    $Res Function(RouteDirections) then,
  ) = _$RouteDirectionsCopyWithImpl<$Res, RouteDirections>;
  @useResult
  $Res call({
    List<RouteLeg> legs,
    String overviewPolyline,
    double totalDistanceMeters,
    int totalDurationSeconds,
    Map<String, dynamic>? bounds,
    List<String>? warnings,
  });
}

/// @nodoc
class _$RouteDirectionsCopyWithImpl<$Res, $Val extends RouteDirections>
    implements $RouteDirectionsCopyWith<$Res> {
  _$RouteDirectionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RouteDirections
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? legs = null,
    Object? overviewPolyline = null,
    Object? totalDistanceMeters = null,
    Object? totalDurationSeconds = null,
    Object? bounds = freezed,
    Object? warnings = freezed,
  }) {
    return _then(
      _value.copyWith(
            legs: null == legs
                ? _value.legs
                : legs // ignore: cast_nullable_to_non_nullable
                      as List<RouteLeg>,
            overviewPolyline: null == overviewPolyline
                ? _value.overviewPolyline
                : overviewPolyline // ignore: cast_nullable_to_non_nullable
                      as String,
            totalDistanceMeters: null == totalDistanceMeters
                ? _value.totalDistanceMeters
                : totalDistanceMeters // ignore: cast_nullable_to_non_nullable
                      as double,
            totalDurationSeconds: null == totalDurationSeconds
                ? _value.totalDurationSeconds
                : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            bounds: freezed == bounds
                ? _value.bounds
                : bounds // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            warnings: freezed == warnings
                ? _value.warnings
                : warnings // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RouteDirectionsImplCopyWith<$Res>
    implements $RouteDirectionsCopyWith<$Res> {
  factory _$$RouteDirectionsImplCopyWith(
    _$RouteDirectionsImpl value,
    $Res Function(_$RouteDirectionsImpl) then,
  ) = __$$RouteDirectionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<RouteLeg> legs,
    String overviewPolyline,
    double totalDistanceMeters,
    int totalDurationSeconds,
    Map<String, dynamic>? bounds,
    List<String>? warnings,
  });
}

/// @nodoc
class __$$RouteDirectionsImplCopyWithImpl<$Res>
    extends _$RouteDirectionsCopyWithImpl<$Res, _$RouteDirectionsImpl>
    implements _$$RouteDirectionsImplCopyWith<$Res> {
  __$$RouteDirectionsImplCopyWithImpl(
    _$RouteDirectionsImpl _value,
    $Res Function(_$RouteDirectionsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RouteDirections
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? legs = null,
    Object? overviewPolyline = null,
    Object? totalDistanceMeters = null,
    Object? totalDurationSeconds = null,
    Object? bounds = freezed,
    Object? warnings = freezed,
  }) {
    return _then(
      _$RouteDirectionsImpl(
        legs: null == legs
            ? _value._legs
            : legs // ignore: cast_nullable_to_non_nullable
                  as List<RouteLeg>,
        overviewPolyline: null == overviewPolyline
            ? _value.overviewPolyline
            : overviewPolyline // ignore: cast_nullable_to_non_nullable
                  as String,
        totalDistanceMeters: null == totalDistanceMeters
            ? _value.totalDistanceMeters
            : totalDistanceMeters // ignore: cast_nullable_to_non_nullable
                  as double,
        totalDurationSeconds: null == totalDurationSeconds
            ? _value.totalDurationSeconds
            : totalDurationSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        bounds: freezed == bounds
            ? _value._bounds
            : bounds // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        warnings: freezed == warnings
            ? _value._warnings
            : warnings // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteDirectionsImpl implements _RouteDirections {
  const _$RouteDirectionsImpl({
    required final List<RouteLeg> legs,
    required this.overviewPolyline,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
    final Map<String, dynamic>? bounds,
    final List<String>? warnings,
  }) : _legs = legs,
       _bounds = bounds,
       _warnings = warnings;

  factory _$RouteDirectionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteDirectionsImplFromJson(json);

  final List<RouteLeg> _legs;
  @override
  List<RouteLeg> get legs {
    if (_legs is EqualUnmodifiableListView) return _legs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_legs);
  }

  @override
  final String overviewPolyline;
  @override
  final double totalDistanceMeters;
  @override
  final int totalDurationSeconds;
  final Map<String, dynamic>? _bounds;
  @override
  Map<String, dynamic>? get bounds {
    final value = _bounds;
    if (value == null) return null;
    if (_bounds is EqualUnmodifiableMapView) return _bounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _warnings;
  @override
  List<String>? get warnings {
    final value = _warnings;
    if (value == null) return null;
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RouteDirections(legs: $legs, overviewPolyline: $overviewPolyline, totalDistanceMeters: $totalDistanceMeters, totalDurationSeconds: $totalDurationSeconds, bounds: $bounds, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteDirectionsImpl &&
            const DeepCollectionEquality().equals(other._legs, _legs) &&
            (identical(other.overviewPolyline, overviewPolyline) ||
                other.overviewPolyline == overviewPolyline) &&
            (identical(other.totalDistanceMeters, totalDistanceMeters) ||
                other.totalDistanceMeters == totalDistanceMeters) &&
            (identical(other.totalDurationSeconds, totalDurationSeconds) ||
                other.totalDurationSeconds == totalDurationSeconds) &&
            const DeepCollectionEquality().equals(other._bounds, _bounds) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_legs),
    overviewPolyline,
    totalDistanceMeters,
    totalDurationSeconds,
    const DeepCollectionEquality().hash(_bounds),
    const DeepCollectionEquality().hash(_warnings),
  );

  /// Create a copy of RouteDirections
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteDirectionsImplCopyWith<_$RouteDirectionsImpl> get copyWith =>
      __$$RouteDirectionsImplCopyWithImpl<_$RouteDirectionsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteDirectionsImplToJson(this);
  }
}

abstract class _RouteDirections implements RouteDirections {
  const factory _RouteDirections({
    required final List<RouteLeg> legs,
    required final String overviewPolyline,
    required final double totalDistanceMeters,
    required final int totalDurationSeconds,
    final Map<String, dynamic>? bounds,
    final List<String>? warnings,
  }) = _$RouteDirectionsImpl;

  factory _RouteDirections.fromJson(Map<String, dynamic> json) =
      _$RouteDirectionsImpl.fromJson;

  @override
  List<RouteLeg> get legs;
  @override
  String get overviewPolyline;
  @override
  double get totalDistanceMeters;
  @override
  int get totalDurationSeconds;
  @override
  Map<String, dynamic>? get bounds;
  @override
  List<String>? get warnings;

  /// Create a copy of RouteDirections
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RouteDirectionsImplCopyWith<_$RouteDirectionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
