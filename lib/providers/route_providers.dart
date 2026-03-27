import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/route_models.dart';
import '../data/repositories/route_repository.dart';
import '../services/location_service.dart';
import '../services/directions_service.dart';
import '../services/route_optimization_service.dart';
import '../services/maps_service.dart';
import 'providers.dart';

// Service Providers
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final directionsServiceProvider = Provider<DirectionsService>((ref) {
  // DirectionsService now uses free OSRM API (no API key needed)
  return DirectionsService();
});

final routeOptimizationServiceProvider = Provider<RouteOptimizationService>((
  ref,
) {
  final locationService = ref.watch(locationServiceProvider);
  return RouteOptimizationService(locationService);
});

final mapsServiceProvider = Provider<MapsService>((ref) {
  return MapsService();
});

// Repository Provider
final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  return RouteRepository(
    ref.watch(appwriteDatabasesProvider),
    ref.watch(appwriteRealtimeProvider),
  );
});

// Current Location Provider
final currentLocationProvider = FutureProvider<LocationPoint>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  return await locationService.getCurrentLocation();
});

// Location Stream Provider
final locationStreamProvider = StreamProvider<LocationPoint>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  return locationService.getLocationStream();
});

// Volunteer Routes Provider
final volunteerRoutesProvider = StreamProvider<List<DeliveryRoute>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return Stream.value([]);
      final routeRepo = ref.watch(routeRepositoryProvider);
      return routeRepo.getVolunteerRoutes(user.$id);
    },
    loading: () => Stream.value([]),
    error: (_, _) => Stream.value([]),
  );
});

// Active Route Provider
final activeRouteProvider = FutureProvider<DeliveryRoute?>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  if (user == null) return null;

  final routeRepo = ref.watch(routeRepositoryProvider);
  return await routeRepo.getActiveRoute(user.$id);
});

// Route Details Provider
final routeDetailsProvider = FutureProvider.family<DeliveryRoute?, String>((
  ref,
  routeId,
) async {
  final routeRepo = ref.watch(routeRepositoryProvider);
  return await routeRepo.getRoute(routeId);
});

// Route Stops Provider
final routeStopsProvider = FutureProvider.family<List<RouteStop>, String>((
  ref,
  routeId,
) async {
  final routeRepo = ref.watch(routeRepositoryProvider);
  return await routeRepo.getRouteStops(routeId);
});

// Next Stop Provider
final nextStopProvider = FutureProvider.family<RouteStop?, String>((
  ref,
  routeId,
) async {
  final routeRepo = ref.watch(routeRepositoryProvider);
  return await routeRepo.getNextStop(routeId);
});

// Route Statistics Provider
final routeStatisticsProvider = FutureProvider.family<RouteStatistics, String>((
  ref,
  routeId,
) async {
  final routeRepo = ref.watch(routeRepositoryProvider);
  return await routeRepo.getRouteStatistics(routeId);
});

// Route Optimization Provider
final routeOptimizationProvider =
    FutureProvider.family<RouteOptimizationResult, RouteOptimizationParams>((
      ref,
      params,
    ) async {
      final optimizationService = ref.watch(routeOptimizationServiceProvider);
      return await optimizationService.optimizeRoute(
        startLocation: params.startLocation,
        stops: params.stops,
        algorithm: params.algorithm,
      );
    });

// Route Directions Provider
final routeDirectionsProvider =
    FutureProvider.family<RouteDirections, RouteDirectionsParams>((
      ref,
      params,
    ) async {
      final directionsService = ref.watch(directionsServiceProvider);

      // Build waypoints list: origin + waypoints + destination
      final allWaypoints = [
        params.origin,
        if (params.waypoints != null) ...params.waypoints!,
        params.destination,
      ];

      // Calculate route using OSRM
      final route = await directionsService.calculateRoute(
        waypoints: allWaypoints,
      );

      // Convert RouteResult to RouteDirections
      // Create legs from consecutive waypoints
      final legs = <RouteLeg>[];
      for (int i = 0; i < allWaypoints.length - 1; i++) {
        final startLoc = allWaypoints[i];
        final endLoc = allWaypoints[i + 1];

        legs.add(
          RouteLeg(
            startLocation: startLoc,
            endLocation: endLoc,
            distanceMeters:
                route.distanceMeters / allWaypoints.length, // Approximate
            durationSeconds: (route.durationSeconds / allWaypoints.length)
                .round(),
            steps: route.steps
                .map(
                  (s) => DirectionStep(
                    instructions: s.instruction,
                    distanceMeters: s.distanceMeters,
                    durationSeconds: s.durationSeconds.round(),
                    startLocation: LocationPoint(
                      latitude: s.location.latitude,
                      longitude: s.location.longitude,
                    ),
                    endLocation: LocationPoint(
                      latitude: s.location.latitude,
                      longitude: s.location.longitude,
                    ),
                    maneuver: s.maneuver,
                  ),
                )
                .toList(),
          ),
        );
      }

      return RouteDirections(
        legs: legs,
        overviewPolyline: '', // OSRM doesn't provide encoded polyline
        totalDistanceMeters: route.distanceMeters,
        totalDurationSeconds: route.durationSeconds.round(),
      );
    });

// Volunteer Latest Location Provider
final volunteerLatestLocationProvider =
    FutureProvider.family<VolunteerLocation?, String>((ref, volunteerId) async {
      final routeRepo = ref.watch(routeRepositoryProvider);
      return await routeRepo.getLatestLocation(volunteerId);
    });

// Route Cache Provider
final routeCacheProvider = FutureProvider.family<RouteCache?, String>((
  ref,
  routeId,
) async {
  final routeRepo = ref.watch(routeRepositoryProvider);
  return await routeRepo.getRouteCache(routeId);
});

// State Providers for UI
final selectedRouteIdProvider = StateProvider<String?>((ref) => null);
final selectedStopIdProvider = StateProvider<String?>((ref) => null);
final isOptimizingRouteProvider = StateProvider<bool>((ref) => false);
final isNavigatingProvider = StateProvider<bool>((ref) => false);

// Map Controller State
final mapControllerProvider = StateProvider<dynamic>((ref) => null);

// Selected Optimization Algorithm
final selectedOptimizationAlgorithmProvider =
    StateProvider<OptimizationAlgorithm>(
      (ref) => OptimizationAlgorithm.nearestNeighbor,
    );

/// Parameters for route optimization
class RouteOptimizationParams {
  final LocationPoint startLocation;
  final List<RouteStop> stops;
  final OptimizationAlgorithm algorithm;

  RouteOptimizationParams({
    required this.startLocation,
    required this.stops,
    this.algorithm = OptimizationAlgorithm.nearestNeighbor,
  });
}

/// Parameters for route directions
class RouteDirectionsParams {
  final LocationPoint origin;
  final LocationPoint destination;
  final List<LocationPoint>? waypoints;
  final bool optimizeWaypoints;

  RouteDirectionsParams({
    required this.origin,
    required this.destination,
    this.waypoints,
    this.optimizeWaypoints = false,
  });
}

// Helper methods for route operations
extension RouteOperations on WidgetRef {
  /// Create a new route
  Future<DeliveryRoute> createRoute({
    required String volunteerId,
    required List<RouteStop> stops,
    LocationPoint? startLocation,
  }) async {
    final routeRepo = read(routeRepositoryProvider);
    final LocationPoint location;

    if (startLocation != null) {
      location = startLocation;
    } else {
      final locationResult = await read(currentLocationProvider.future);
      location = locationResult;
    }

    final route = DeliveryRoute(
      id: '',
      volunteerId: volunteerId,
      status: RouteStatus.planned,
      startLocationLat: location.latitude,
      startLocationLng: location.longitude,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      stops: stops,
    );

    return await routeRepo.createRoute(route);
  }

  /// Start a route
  Future<void> startRoute(String routeId) async {
    final routeRepo = read(routeRepositoryProvider);
    await routeRepo.updateRouteStatus(routeId, RouteStatus.active);
  }

  /// Complete a route
  Future<void> completeRoute(String routeId) async {
    final routeRepo = read(routeRepositoryProvider);
    await routeRepo.updateRouteStatus(routeId, RouteStatus.completed);
  }

  /// Complete a stop
  Future<void> completeStop(
    String stopId, {
    String? notes,
    String? photoUrl,
  }) async {
    final routeRepo = read(routeRepositoryProvider);
    await routeRepo.completeStop(stopId, notes: notes, photoUrl: photoUrl);
  }

  /// Track current location
  Future<void> trackLocation(String volunteerId, String? routeId) async {
    final routeRepo = read(routeRepositoryProvider);
    final location = await read(currentLocationProvider.future);

    final volunteerLocation = VolunteerLocation(
      id: '',
      volunteerId: volunteerId,
      routeId: routeId,
      latitude: location.latitude,
      longitude: location.longitude,
      accuracy: location.accuracy,
      altitude: location.altitude,
      speed: location.speed,
      heading: location.heading,
      timestamp: DateTime.now(),
      createdAt: DateTime.now(),
    );

    await routeRepo.trackLocation(volunteerLocation);
  }

  /// Optimize route
  Future<RouteOptimizationResult> optimizeRoute({
    required LocationPoint startLocation,
    required List<RouteStop> stops,
    OptimizationAlgorithm? algorithm,
  }) async {
    final optimizationService = read(routeOptimizationServiceProvider);
    return await optimizationService.optimizeRoute(
      startLocation: startLocation,
      stops: stops,
      algorithm: algorithm ?? OptimizationAlgorithm.nearestNeighbor,
    );
  }
}
