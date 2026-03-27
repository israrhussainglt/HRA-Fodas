import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_models.freezed.dart';
part 'route_models.g.dart';

/// Route status enum
enum RouteStatus {
  @JsonValue('planned')
  planned,
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

/// Stop type enum
enum StopType {
  @JsonValue('pickup')
  pickup,
  @JsonValue('dropoff')
  dropoff,
}

/// Stop status enum
enum StopStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('en_route')
  enRoute,
  @JsonValue('arrived')
  arrived,
  @JsonValue('completed')
  completed,
  @JsonValue('skipped')
  skipped,
}

/// Location point model
@freezed
class LocationPoint with _$LocationPoint {
  const factory LocationPoint({
    required double latitude,
    required double longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
  }) = _LocationPoint;

  factory LocationPoint.fromJson(Map<String, dynamic> json) =>
      _$LocationPointFromJson(json);
}

/// Route model
@freezed
class DeliveryRoute with _$DeliveryRoute {
  const factory DeliveryRoute({
    required String id,
    required String volunteerId,
    required RouteStatus status,
    double? totalDistance, // in kilometers
    int? totalDuration, // in minutes
    @Default(false) bool optimized,
    String? optimizationAlgorithm,
    double? startLocationLat,
    double? startLocationLng,
    String? startAddress,
    String? notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    @Default([]) List<RouteStop> stops,
  }) = _DeliveryRoute;

  factory DeliveryRoute.fromJson(Map<String, dynamic> json) =>
      _$DeliveryRouteFromJson(json);
}

/// Route stop model
@freezed
class RouteStop with _$RouteStop {
  const factory RouteStop({
    required String id,
    required String routeId,
    String? deliveryId,
    required StopType stopType,
    required int sequenceOrder,
    required double locationLat,
    required double locationLng,
    required String address,
    String? contactName,
    String? contactPhone,
    DateTime? estimatedArrival,
    DateTime? actualArrival,
    int? estimatedDuration, // minutes at this stop
    double? distanceFromPrevious, // km
    int? durationFromPrevious, // minutes
    @Default(StopStatus.pending) StopStatus status,
    String? completionNotes,
    String? completionPhotoUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RouteStop;

  factory RouteStop.fromJson(Map<String, dynamic> json) =>
      _$RouteStopFromJson(json);
}

/// Route cache model
@freezed
class RouteCache with _$RouteCache {
  const factory RouteCache({
    required String id,
    required String routeId,
    required String polyline,
    Map<String, dynamic>? bounds,
    Map<String, dynamic>? trafficData,
    required DateTime cachedAt,
    required DateTime expiresAt,
  }) = _RouteCache;

  factory RouteCache.fromJson(Map<String, dynamic> json) =>
      _$RouteCacheFromJson(json);
}

/// Volunteer location model
@freezed
class VolunteerLocation with _$VolunteerLocation {
  const factory VolunteerLocation({
    required String id,
    required String volunteerId,
    String? routeId,
    required double latitude,
    required double longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    double? heading,
    required DateTime timestamp,
    required DateTime createdAt,
  }) = _VolunteerLocation;

  factory VolunteerLocation.fromJson(Map<String, dynamic> json) =>
      _$VolunteerLocationFromJson(json);
}

/// Route optimization result
@freezed
class RouteOptimizationResult with _$RouteOptimizationResult {
  const factory RouteOptimizationResult({
    required List<RouteStop> optimizedStops,
    required double totalDistance,
    required int totalDuration,
    required double distanceSaved,
    required int timeSaved,
    required String algorithm,
    required int optimizationTimeMs,
  }) = _RouteOptimizationResult;

  factory RouteOptimizationResult.fromJson(Map<String, dynamic> json) =>
      _$RouteOptimizationResultFromJson(json);
}

/// Route statistics
@freezed
class RouteStatistics with _$RouteStatistics {
  const factory RouteStatistics({
    required int totalStops,
    required int completedStops,
    required int pendingStops,
    required double totalDistance,
    required int totalDuration,
  }) = _RouteStatistics;

  factory RouteStatistics.fromJson(Map<String, dynamic> json) =>
      _$RouteStatisticsFromJson(json);
}

/// Direction step (from Google Maps)
@freezed
class DirectionStep with _$DirectionStep {
  const factory DirectionStep({
    required String instructions,
    required double distanceMeters,
    required int durationSeconds,
    required LocationPoint startLocation,
    required LocationPoint endLocation,
    String? polyline,
    String? maneuver,
  }) = _DirectionStep;

  factory DirectionStep.fromJson(Map<String, dynamic> json) =>
      _$DirectionStepFromJson(json);
}

/// Route leg (segment between two stops)
@freezed
class RouteLeg with _$RouteLeg {
  const factory RouteLeg({
    required LocationPoint startLocation,
    required LocationPoint endLocation,
    required double distanceMeters,
    required int durationSeconds,
    required List<DirectionStep> steps,
    String? polyline,
  }) = _RouteLeg;

  factory RouteLeg.fromJson(Map<String, dynamic> json) =>
      _$RouteLegFromJson(json);
}

/// Complete route directions
@freezed
class RouteDirections with _$RouteDirections {
  const factory RouteDirections({
    required List<RouteLeg> legs,
    required String overviewPolyline,
    required double totalDistanceMeters,
    required int totalDurationSeconds,
    Map<String, dynamic>? bounds,
    List<String>? warnings,
  }) = _RouteDirections;

  factory RouteDirections.fromJson(Map<String, dynamic> json) =>
      _$RouteDirectionsFromJson(json);
}
