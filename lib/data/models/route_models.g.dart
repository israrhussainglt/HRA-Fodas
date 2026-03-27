// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocationPointImpl _$$LocationPointImplFromJson(Map<String, dynamic> json) =>
    _$LocationPointImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$LocationPointImplToJson(_$LocationPointImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
      'altitude': instance.altitude,
      'speed': instance.speed,
      'heading': instance.heading,
    };

_$DeliveryRouteImpl _$$DeliveryRouteImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryRouteImpl(
      id: json['id'] as String,
      volunteerId: json['volunteerId'] as String,
      status: $enumDecode(_$RouteStatusEnumMap, json['status']),
      totalDistance: (json['totalDistance'] as num?)?.toDouble(),
      totalDuration: (json['totalDuration'] as num?)?.toInt(),
      optimized: json['optimized'] as bool? ?? false,
      optimizationAlgorithm: json['optimizationAlgorithm'] as String?,
      startLocationLat: (json['startLocationLat'] as num?)?.toDouble(),
      startLocationLng: (json['startLocationLng'] as num?)?.toDouble(),
      startAddress: json['startAddress'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      stops:
          (json['stops'] as List<dynamic>?)
              ?.map((e) => RouteStop.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DeliveryRouteImplToJson(_$DeliveryRouteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'volunteerId': instance.volunteerId,
      'status': _$RouteStatusEnumMap[instance.status]!,
      'totalDistance': instance.totalDistance,
      'totalDuration': instance.totalDuration,
      'optimized': instance.optimized,
      'optimizationAlgorithm': instance.optimizationAlgorithm,
      'startLocationLat': instance.startLocationLat,
      'startLocationLng': instance.startLocationLng,
      'startAddress': instance.startAddress,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'stops': instance.stops,
    };

const _$RouteStatusEnumMap = {
  RouteStatus.planned: 'planned',
  RouteStatus.active: 'active',
  RouteStatus.completed: 'completed',
  RouteStatus.cancelled: 'cancelled',
};

_$RouteStopImpl _$$RouteStopImplFromJson(Map<String, dynamic> json) =>
    _$RouteStopImpl(
      id: json['id'] as String,
      routeId: json['routeId'] as String,
      deliveryId: json['deliveryId'] as String?,
      stopType: $enumDecode(_$StopTypeEnumMap, json['stopType']),
      sequenceOrder: (json['sequenceOrder'] as num).toInt(),
      locationLat: (json['locationLat'] as num).toDouble(),
      locationLng: (json['locationLng'] as num).toDouble(),
      address: json['address'] as String,
      contactName: json['contactName'] as String?,
      contactPhone: json['contactPhone'] as String?,
      estimatedArrival: json['estimatedArrival'] == null
          ? null
          : DateTime.parse(json['estimatedArrival'] as String),
      actualArrival: json['actualArrival'] == null
          ? null
          : DateTime.parse(json['actualArrival'] as String),
      estimatedDuration: (json['estimatedDuration'] as num?)?.toInt(),
      distanceFromPrevious: (json['distanceFromPrevious'] as num?)?.toDouble(),
      durationFromPrevious: (json['durationFromPrevious'] as num?)?.toInt(),
      status:
          $enumDecodeNullable(_$StopStatusEnumMap, json['status']) ??
          StopStatus.pending,
      completionNotes: json['completionNotes'] as String?,
      completionPhotoUrl: json['completionPhotoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RouteStopImplToJson(_$RouteStopImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeId': instance.routeId,
      'deliveryId': instance.deliveryId,
      'stopType': _$StopTypeEnumMap[instance.stopType]!,
      'sequenceOrder': instance.sequenceOrder,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
      'address': instance.address,
      'contactName': instance.contactName,
      'contactPhone': instance.contactPhone,
      'estimatedArrival': instance.estimatedArrival?.toIso8601String(),
      'actualArrival': instance.actualArrival?.toIso8601String(),
      'estimatedDuration': instance.estimatedDuration,
      'distanceFromPrevious': instance.distanceFromPrevious,
      'durationFromPrevious': instance.durationFromPrevious,
      'status': _$StopStatusEnumMap[instance.status]!,
      'completionNotes': instance.completionNotes,
      'completionPhotoUrl': instance.completionPhotoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$StopTypeEnumMap = {
  StopType.pickup: 'pickup',
  StopType.dropoff: 'dropoff',
};

const _$StopStatusEnumMap = {
  StopStatus.pending: 'pending',
  StopStatus.enRoute: 'en_route',
  StopStatus.arrived: 'arrived',
  StopStatus.completed: 'completed',
  StopStatus.skipped: 'skipped',
};

_$RouteCacheImpl _$$RouteCacheImplFromJson(Map<String, dynamic> json) =>
    _$RouteCacheImpl(
      id: json['id'] as String,
      routeId: json['routeId'] as String,
      polyline: json['polyline'] as String,
      bounds: json['bounds'] as Map<String, dynamic>?,
      trafficData: json['trafficData'] as Map<String, dynamic>?,
      cachedAt: DateTime.parse(json['cachedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$RouteCacheImplToJson(_$RouteCacheImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'routeId': instance.routeId,
      'polyline': instance.polyline,
      'bounds': instance.bounds,
      'trafficData': instance.trafficData,
      'cachedAt': instance.cachedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_$VolunteerLocationImpl _$$VolunteerLocationImplFromJson(
  Map<String, dynamic> json,
) => _$VolunteerLocationImpl(
  id: json['id'] as String,
  volunteerId: json['volunteerId'] as String,
  routeId: json['routeId'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  accuracy: (json['accuracy'] as num?)?.toDouble(),
  altitude: (json['altitude'] as num?)?.toDouble(),
  speed: (json['speed'] as num?)?.toDouble(),
  heading: (json['heading'] as num?)?.toDouble(),
  timestamp: DateTime.parse(json['timestamp'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$VolunteerLocationImplToJson(
  _$VolunteerLocationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'volunteerId': instance.volunteerId,
  'routeId': instance.routeId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'accuracy': instance.accuracy,
  'altitude': instance.altitude,
  'speed': instance.speed,
  'heading': instance.heading,
  'timestamp': instance.timestamp.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};

_$RouteOptimizationResultImpl _$$RouteOptimizationResultImplFromJson(
  Map<String, dynamic> json,
) => _$RouteOptimizationResultImpl(
  optimizedStops: (json['optimizedStops'] as List<dynamic>)
      .map((e) => RouteStop.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalDistance: (json['totalDistance'] as num).toDouble(),
  totalDuration: (json['totalDuration'] as num).toInt(),
  distanceSaved: (json['distanceSaved'] as num).toDouble(),
  timeSaved: (json['timeSaved'] as num).toInt(),
  algorithm: json['algorithm'] as String,
  optimizationTimeMs: (json['optimizationTimeMs'] as num).toInt(),
);

Map<String, dynamic> _$$RouteOptimizationResultImplToJson(
  _$RouteOptimizationResultImpl instance,
) => <String, dynamic>{
  'optimizedStops': instance.optimizedStops,
  'totalDistance': instance.totalDistance,
  'totalDuration': instance.totalDuration,
  'distanceSaved': instance.distanceSaved,
  'timeSaved': instance.timeSaved,
  'algorithm': instance.algorithm,
  'optimizationTimeMs': instance.optimizationTimeMs,
};

_$RouteStatisticsImpl _$$RouteStatisticsImplFromJson(
  Map<String, dynamic> json,
) => _$RouteStatisticsImpl(
  totalStops: (json['totalStops'] as num).toInt(),
  completedStops: (json['completedStops'] as num).toInt(),
  pendingStops: (json['pendingStops'] as num).toInt(),
  totalDistance: (json['totalDistance'] as num).toDouble(),
  totalDuration: (json['totalDuration'] as num).toInt(),
);

Map<String, dynamic> _$$RouteStatisticsImplToJson(
  _$RouteStatisticsImpl instance,
) => <String, dynamic>{
  'totalStops': instance.totalStops,
  'completedStops': instance.completedStops,
  'pendingStops': instance.pendingStops,
  'totalDistance': instance.totalDistance,
  'totalDuration': instance.totalDuration,
};

_$DirectionStepImpl _$$DirectionStepImplFromJson(Map<String, dynamic> json) =>
    _$DirectionStepImpl(
      instructions: json['instructions'] as String,
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      startLocation: LocationPoint.fromJson(
        json['startLocation'] as Map<String, dynamic>,
      ),
      endLocation: LocationPoint.fromJson(
        json['endLocation'] as Map<String, dynamic>,
      ),
      polyline: json['polyline'] as String?,
      maneuver: json['maneuver'] as String?,
    );

Map<String, dynamic> _$$DirectionStepImplToJson(_$DirectionStepImpl instance) =>
    <String, dynamic>{
      'instructions': instance.instructions,
      'distanceMeters': instance.distanceMeters,
      'durationSeconds': instance.durationSeconds,
      'startLocation': instance.startLocation,
      'endLocation': instance.endLocation,
      'polyline': instance.polyline,
      'maneuver': instance.maneuver,
    };

_$RouteLegImpl _$$RouteLegImplFromJson(Map<String, dynamic> json) =>
    _$RouteLegImpl(
      startLocation: LocationPoint.fromJson(
        json['startLocation'] as Map<String, dynamic>,
      ),
      endLocation: LocationPoint.fromJson(
        json['endLocation'] as Map<String, dynamic>,
      ),
      distanceMeters: (json['distanceMeters'] as num).toDouble(),
      durationSeconds: (json['durationSeconds'] as num).toInt(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => DirectionStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      polyline: json['polyline'] as String?,
    );

Map<String, dynamic> _$$RouteLegImplToJson(_$RouteLegImpl instance) =>
    <String, dynamic>{
      'startLocation': instance.startLocation,
      'endLocation': instance.endLocation,
      'distanceMeters': instance.distanceMeters,
      'durationSeconds': instance.durationSeconds,
      'steps': instance.steps,
      'polyline': instance.polyline,
    };

_$RouteDirectionsImpl _$$RouteDirectionsImplFromJson(
  Map<String, dynamic> json,
) => _$RouteDirectionsImpl(
  legs: (json['legs'] as List<dynamic>)
      .map((e) => RouteLeg.fromJson(e as Map<String, dynamic>))
      .toList(),
  overviewPolyline: json['overviewPolyline'] as String,
  totalDistanceMeters: (json['totalDistanceMeters'] as num).toDouble(),
  totalDurationSeconds: (json['totalDurationSeconds'] as num).toInt(),
  bounds: json['bounds'] as Map<String, dynamic>?,
  warnings: (json['warnings'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$RouteDirectionsImplToJson(
  _$RouteDirectionsImpl instance,
) => <String, dynamic>{
  'legs': instance.legs,
  'overviewPolyline': instance.overviewPolyline,
  'totalDistanceMeters': instance.totalDistanceMeters,
  'totalDurationSeconds': instance.totalDurationSeconds,
  'bounds': instance.bounds,
  'warnings': instance.warnings,
};
