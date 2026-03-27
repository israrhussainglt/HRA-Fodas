import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import '../data/models/route_models.dart';

/// Geocoding service using OpenStreetMap Nominatim API (free, no API key required)
class GeocodingService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org';
  static const String _userAgent = 'HRA-FoDAS/1.0';

  /// Search for places by query
  Future<List<PlaceResult>> searchPlaces({
    required String query,
    LocationPoint? location,
    int limit = 10,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': limit.toString(),
          'addressdetails': '1',
          if (location != null) ...{
            'lat': location.latitude.toString(),
            'lon': location.longitude.toString(),
          },
        },
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => PlaceResult.fromNominatim(item)).toList();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }

  /// Reverse geocode (coordinates to address)
  Future<String> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/reverse').replace(
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
          'format': 'json',
          'addressdetails': '1',
        },
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? 'Unknown location';
      } else {
        throw Exception('Reverse geocode failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Reverse geocode error: $e');
    }
  }

  /// Geocode address to coordinates
  Future<LocationPoint?> geocodeAddress(String address) async {
    try {
      final results = await searchPlaces(query: address, limit: 1);
      if (results.isNotEmpty) {
        return LocationPoint(
          latitude: results.first.latitude,
          longitude: results.first.longitude,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Geocode error: $e');
    }
  }

  /// Search nearby places by category
  Future<List<PlaceResult>> searchNearby({
    required LocationPoint location,
    String? category,
    double radiusKm = 5.0,
    int limit = 20,
  }) async {
    try {
      // Nominatim doesn't have a direct "nearby" endpoint, so we search with location bias
      final query = category ?? 'amenity';
      
      final uri = Uri.parse('$_baseUrl/search').replace(
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': limit.toString(),
          'addressdetails': '1',
          'lat': location.latitude.toString(),
          'lon': location.longitude.toString(),
          'bounded': '1',
          'viewbox': _calculateViewbox(location, radiusKm),
        },
      );

      final response = await http.get(
        uri,
        headers: {'User-Agent': _userAgent},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => PlaceResult.fromNominatim(item)).toList();
      } else {
        throw Exception('Nearby search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Nearby search error: $e');
    }
  }

  /// Calculate viewbox for bounded search
  String _calculateViewbox(LocationPoint center, double radiusKm) {
    // Approximate: 1 degree latitude ≈ 111 km
    final latDelta = radiusKm / 111.0;
    final lonDelta = radiusKm / (111.0 * math.cos(center.latitude * math.pi / 180));

    final left = center.longitude - lonDelta;
    final top = center.latitude + latDelta;
    final right = center.longitude + lonDelta;
    final bottom = center.latitude - latDelta;

    return '$left,$top,$right,$bottom';
  }
}

/// Place result model
class PlaceResult {
  final String name;
  final String shortAddress;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final String? category;
  final double? distance;

  PlaceResult({
    required this.name,
    required this.shortAddress,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.category,
    this.distance,
  });

  factory PlaceResult.fromNominatim(Map<String, dynamic> json) {
    final displayName = json['display_name'] ?? '';
    final nameParts = displayName.split(',');
    
    return PlaceResult(
      name: json['name'] ?? nameParts.first.trim(),
      shortAddress: nameParts.length > 1 
          ? nameParts.sublist(1, nameParts.length > 3 ? 3 : nameParts.length).join(',').trim() 
          : displayName,
      fullAddress: displayName,
      latitude: double.parse(json['lat'].toString()),
      longitude: double.parse(json['lon'].toString()),
      category: json['type'],
      distance: null,
    );
  }
}
