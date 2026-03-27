import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import '../data/models/route_models.dart';

/// Directions service using OSRM (Open Source Routing Machine) - free, no API key
class DirectionsService {
  static const String _baseUrl = 'https://router.project-osrm.org';

  /// Calculate route between multiple points
  Future<RouteResult> calculateRoute({
    required List<LocationPoint> waypoints,
    bool avoidTolls = false,
    bool avoidHighways = false,
  }) async {
    if (waypoints.length < 2) {
      throw Exception('At least 2 waypoints required');
    }

    try {
      // Build coordinates string: lon,lat;lon,lat;...
      final coordinates = waypoints
          .map((p) => '${p.longitude},${p.latitude}')
          .join(';');

      final uri = Uri.parse('$_baseUrl/route/v1/driving/$coordinates').replace(
        queryParameters: {
          'overview': 'full',
          'geometries': 'geojson',
          'steps': 'true',
          'annotations': 'true',
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['code'] == 'Ok' && data['routes'] != null && data['routes'].isNotEmpty) {
          return RouteResult.fromOSRM(data['routes'][0]);
        } else {
          throw Exception('No route found');
        }
      } else {
        throw Exception('Route calculation failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Route calculation error: $e');
    }
  }

  /// Calculate distance matrix between multiple points
  Future<DistanceMatrix> calculateDistanceMatrix({
    required List<LocationPoint> origins,
    required List<LocationPoint> destinations,
  }) async {
    try {
      // For simplicity, calculate routes between all origin-destination pairs
      final distances = <List<double>>[];
      final durations = <List<double>>[];

      for (final origin in origins) {
        final rowDistances = <double>[];
        final rowDurations = <double>[];

        for (final destination in destinations) {
          try {
            final route = await calculateRoute(
              waypoints: [origin, destination],
            );
            rowDistances.add(route.distanceMeters / 1000); // Convert to km
            rowDurations.add(route.durationSeconds / 60); // Convert to minutes
          } catch (e) {
            rowDistances.add(double.infinity);
            rowDurations.add(double.infinity);
          }
        }

        distances.add(rowDistances);
        durations.add(rowDurations);
      }

      return DistanceMatrix(
        distances: distances,
        durations: durations,
      );
    } catch (e) {
      throw Exception('Distance matrix error: $e');
    }
  }

  /// Get turn-by-turn directions
  Future<List<RouteStep>> getDirections({
    required LocationPoint start,
    required LocationPoint end,
  }) async {
    try {
      final route = await calculateRoute(waypoints: [start, end]);
      return route.steps;
    } catch (e) {
      throw Exception('Directions error: $e');
    }
  }
}

/// Route result model
class RouteResult {
  final double distanceMeters;
  final double durationSeconds;
  final List<LatLng> polyline;
  final List<RouteStep> steps;

  RouteResult({
    required this.distanceMeters,
    required this.durationSeconds,
    required this.polyline,
    required this.steps,
  });

  factory RouteResult.fromOSRM(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final coordinates = geometry['coordinates'] as List<dynamic>;
    
    // OSRM returns [lon, lat] format
    final polyline = coordinates
        .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
        .toList();

    final legs = json['legs'] as List<dynamic>;
    final steps = <RouteStep>[];
    
    for (final leg in legs) {
      final legSteps = leg['steps'] as List<dynamic>;
      for (final step in legSteps) {
        steps.add(RouteStep.fromOSRM(step));
      }
    }

    return RouteResult(
      distanceMeters: json['distance'].toDouble(),
      durationSeconds: json['duration'].toDouble(),
      polyline: polyline,
      steps: steps,
    );
  }
}

/// Route step (turn-by-turn instruction)
class RouteStep {
  final String instruction;
  final double distanceMeters;
  final double durationSeconds;
  final LatLng location;
  final String? maneuver;

  RouteStep({
    required this.instruction,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.location,
    this.maneuver,
  });

  factory RouteStep.fromOSRM(Map<String, dynamic> json) {
    final maneuver = json['maneuver'];
    final location = maneuver['location'];
    
    return RouteStep(
      instruction: maneuver['instruction'] ?? json['name'] ?? 'Continue',
      distanceMeters: json['distance'].toDouble(),
      durationSeconds: json['duration'].toDouble(),
      location: LatLng(location[1].toDouble(), location[0].toDouble()),
      maneuver: maneuver['type'],
    );
  }
}

/// Distance matrix result
class DistanceMatrix {
  final List<List<double>> distances; // in km
  final List<List<double>> durations; // in minutes

  DistanceMatrix({
    required this.distances,
    required this.durations,
  });
}
