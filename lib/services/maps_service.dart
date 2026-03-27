import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Service for map-related operations using Flutter Map with TomTom tiles
class MapsService {
  /// Create a marker for a location
  Marker createMarker({
    required String id,
    required double latitude,
    required double longitude,
    required Widget child,
    double width = 40,
    double height = 40,
  }) {
    return Marker(
      point: LatLng(latitude, longitude),
      width: width,
      height: height,
      child: child,
    );
  }

  /// Create a numbered marker
  Marker createNumberedMarker({
    required String id,
    required double latitude,
    required double longitude,
    required int number,
    Color color = Colors.blue,
  }) {
    return Marker(
      point: LatLng(latitude, longitude),
      width: 40,
      height: 40,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            '$number',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  /// Create a polyline
  Polyline createPolyline({
    required String id,
    required List<LatLng> points,
    Color color = Colors.blue,
    double strokeWidth = 4.0,
  }) {
    return Polyline(
      points: points,
      color: color,
      strokeWidth: strokeWidth,
    );
  }

  /// Calculate bounds for a list of coordinates
  LatLngBounds calculateBounds(List<LatLng> points) {
    if (points.isEmpty) {
      return LatLngBounds(
        const LatLng(0, 0),
        const LatLng(0, 0),
      );
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
  }

  /// Get zoom level for distance
  double getZoomLevelForDistance(double distanceKm) {
    if (distanceKm < 1) return 15.0;
    if (distanceKm < 5) return 13.0;
    if (distanceKm < 10) return 12.0;
    if (distanceKm < 20) return 11.0;
    if (distanceKm < 50) return 10.0;
    return 9.0;
  }
}
