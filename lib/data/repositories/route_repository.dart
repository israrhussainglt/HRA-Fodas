import 'package:appwrite/appwrite.dart';
import '../models/route_models.dart';
import '../../appwrite_options.dart';

class RouteRepository {
  final TablesDB _databases; // Changed from Databases to TablesDB
  final Realtime _realtime;

  RouteRepository(this._databases, this._realtime);

  Future<DeliveryRoute> createRoute(DeliveryRoute route) async {
    try {
      final data = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'routes', // Note: Add this to AppwriteOptions if needed
        rowId: ID.unique(),
        data: {
          'volunteer_id': route.volunteerId,
          'status': route.status.name,
          'total_distance': route.totalDistance,
          'total_duration': route.totalDuration,
          'optimized': route.optimized,
          'optimization_algorithm': route.optimizationAlgorithm,
          'start_location_lat': route.startLocationLat,
          'start_location_lng': route.startLocationLng,
          'start_address': route.startAddress,
          'notes': route.notes,
        },
      );
      return DeliveryRoute.fromJson({...data.data, 'id': data.$id});
    } catch (e) {
      throw Exception('Failed to create route: $e');
    }
  }

  Future<DeliveryRoute?> getRoute(String routeId) async {
    try {
      final data = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'routes',
        rowId: routeId,
      );

      // Get route stops separately
      final stops = await getRouteStops(routeId);

      return DeliveryRoute.fromJson({
        ...data.data,
        'id': data.$id,
        'route_stops': stops.map((s) => s.toJson()).toList(),
      });
    } catch (e) {
      return null;
    }
  }

  Stream<List<DeliveryRoute>> getVolunteerRoutes(String volunteerId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  Future<DeliveryRoute?> getActiveRoute(String volunteerId) async {
    try {
      final data = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'routes',
        queries: [
          Query.equal('volunteer_id', volunteerId),
          Query.equal('status', 'active'),
        ],
      );

      if (data.rows.isEmpty) return null;

      final routeId = data.rows.first.$id;
      return getRoute(routeId);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateRoute(String routeId, Map<String, dynamic> updates) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'routes',
        rowId: routeId,
        data: updates,
      );
    } catch (e) {
      throw Exception('Failed to update route: $e');
    }
  }

  Future<void> updateRouteStatus(String routeId, RouteStatus status) async {
    final updates = <String, dynamic>{'status': status.name};
    if (status == RouteStatus.active) {
      updates['started_at'] = DateTime.now().toIso8601String();
    } else if (status == RouteStatus.completed) {
      updates['completed_at'] = DateTime.now().toIso8601String();
    }
    await updateRoute(routeId, updates);
  }

  Future<RouteStop> addStop(RouteStop stop) async {
    try {
      final data = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'route_stops',
        rowId: ID.unique(),
        data: {
          'route_id': stop.routeId,
          'delivery_id': stop.deliveryId,
          'stop_type': stop.stopType.name,
          'sequence_order': stop.sequenceOrder,
          'location_lat': stop.locationLat,
          'location_lng': stop.locationLng,
          'address': stop.address,
          'contact_name': stop.contactName,
          'contact_phone': stop.contactPhone,
          'estimated_arrival': stop.estimatedArrival?.toIso8601String(),
          'estimated_duration': stop.estimatedDuration,
          'distance_from_previous': stop.distanceFromPrevious,
          'duration_from_previous': stop.durationFromPrevious,
        },
      );
      return RouteStop.fromJson({...data.data, 'id': data.$id});
    } catch (e) {
      throw Exception('Failed to add stop: $e');
    }
  }

  Future<List<RouteStop>> getRouteStops(String routeId) async {
    try {
      final data = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'route_stops',
        queries: [
          Query.equal('route_id', routeId),
          Query.orderAsc('sequence_order'),
        ],
      );
      return data.rows
          .map((doc) => RouteStop.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to get route stops: $e');
    }
  }

  Future<void> updateStop(String stopId, Map<String, dynamic> updates) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'route_stops',
        rowId: stopId,
        data: updates,
      );
    } catch (e) {
      throw Exception('Failed to update stop: $e');
    }
  }

  Future<void> updateStopStatus(String stopId, StopStatus status) async {
    final updates = <String, dynamic>{'status': status.name};
    if (status == StopStatus.arrived) {
      updates['actual_arrival'] = DateTime.now().toIso8601String();
    }
    await updateStop(stopId, updates);
  }

  Future<void> completeStop(
    String stopId, {
    String? notes,
    String? photoUrl,
  }) async {
    await updateStop(stopId, {
      'status': StopStatus.completed.name,
      'actual_arrival': DateTime.now().toIso8601String(),
      'completion_notes': notes,
      'completion_photo_url': photoUrl,
    });
  }

  Future<void> reorderStops(String routeId, List<String> stopIds) async {
    try {
      for (var i = 0; i < stopIds.length; i++) {
        await updateStop(stopIds[i], {'sequence_order': i + 1});
      }
    } catch (e) {
      throw Exception('Failed to reorder stops: $e');
    }
  }

  Future<void> deleteStop(String stopId) async {
    try {
      await _databases.deleteRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'route_stops',
        rowId: stopId,
      );
    } catch (e) {
      throw Exception('Failed to delete stop: $e');
    }
  }

  Future<void> saveRouteCache(RouteCache cache) async {
    try {
      // Check if cache exists
      final existing = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'route_cache',
        queries: [Query.equal('route_id', cache.routeId)],
      );

      if (existing.rows.isNotEmpty) {
        await _databases.updateRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'route_cache',
          rowId: existing.rows.first.$id,
          data: {
            'polyline': cache.polyline,
            'bounds': cache.bounds,
            'traffic_data': cache.trafficData,
          },
        );
      } else {
        await _databases.createRow(
          databaseId: AppwriteOptions.databaseId,
          tableId: 'route_cache',
          rowId: ID.unique(),
          data: {
            'route_id': cache.routeId,
            'polyline': cache.polyline,
            'bounds': cache.bounds,
            'traffic_data': cache.trafficData,
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to save route cache: $e');
    }
  }

  Future<RouteCache?> getRouteCache(String routeId) async {
    try {
      final data = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'route_cache',
        queries: [
          Query.equal('route_id', routeId),
          Query.greaterThan('expires_at', DateTime.now().toIso8601String()),
        ],
      );

      if (data.rows.isEmpty) return null;
      return RouteCache.fromJson({
        ...data.rows.first.data,
        'id': data.rows.first.$id,
      });
    } catch (e) {
      return null;
    }
  }

  Future<void> trackLocation(VolunteerLocation location) async {
    try {
      await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'volunteer_locations',
        rowId: ID.unique(),
        data: {
          'volunteer_id': location.volunteerId,
          'route_id': location.routeId,
          'latitude': location.latitude,
          'longitude': location.longitude,
          'accuracy': location.accuracy,
          'altitude': location.altitude,
          'speed': location.speed,
          'heading': location.heading,
          'timestamp': location.timestamp.toIso8601String(),
        },
      );
    } catch (e) {
      // Silently fail for location tracking
    }
  }

  Future<VolunteerLocation?> getLatestLocation(String volunteerId) async {
    try {
      final data = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'volunteer_locations',
        queries: [
          Query.equal('volunteer_id', volunteerId),
          Query.orderDesc('timestamp'),
          Query.limit(1),
        ],
      );

      if (data.rows.isEmpty) return null;
      return VolunteerLocation.fromJson({
        ...data.rows.first.data,
        'id': data.rows.first.$id,
      });
    } catch (e) {
      return null;
    }
  }

  Future<RouteStatistics> getRouteStatistics(String routeId) async {
    try {
      // Note: Appwrite doesn't have RPC functions like Supabase
      // You'll need to implement this logic in Dart or create an Appwrite Function
      throw UnimplementedError(
        'Route statistics calculation needs to be implemented',
      );
    } catch (e) {
      throw Exception('Failed to get route statistics: $e');
    }
  }

  Future<RouteStop?> getNextStop(String routeId) async {
    try {
      final stops = await getRouteStops(routeId);
      // Find first stop that's not completed
      for (final stop in stops) {
        if (stop.status != StopStatus.completed) {
          return stop;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveOptimizationHistory({
    required String routeId,
    required double originalDistance,
    required double optimizedDistance,
    required int originalDuration,
    required int optimizedDuration,
    required String algorithm,
    required int optimizationTimeMs,
  }) async {
    try {
      await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'route_optimization_history',
        rowId: ID.unique(),
        data: {
          'route_id': routeId,
          'original_distance': originalDistance,
          'optimized_distance': optimizedDistance,
          'distance_saved': originalDistance - optimizedDistance,
          'original_duration': originalDuration,
          'optimized_duration': optimizedDuration,
          'time_saved': originalDuration - optimizedDuration,
          'algorithm_used': algorithm,
          'optimization_time_ms': optimizationTimeMs,
        },
      );
    } catch (e) {
      // Silently fail for history
    }
  }

  Future<void> deleteRoute(String routeId) async {
    try {
      await _databases.deleteRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'routes',
        rowId: routeId,
      );
    } catch (e) {
      throw Exception('Failed to delete route: $e');
    }
  }
}
