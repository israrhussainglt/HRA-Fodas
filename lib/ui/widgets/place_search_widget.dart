import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../data/models/route_models.dart';
import '../../core/utils/logger.dart';

/// Widget for searching places using OpenStreetMap Nominatim (free, no API key)
class PlaceSearchWidget extends StatefulWidget {
  final LocationPoint? currentLocation;
  final Function(PlaceResult) onPlaceSelected;
  final String? hintText;

  const PlaceSearchWidget({
    super.key,
    this.currentLocation,
    required this.onPlaceSelected,
    this.hintText,
  });

  @override
  State<PlaceSearchWidget> createState() => _PlaceSearchWidgetState();
}

class _PlaceSearchWidgetState extends State<PlaceSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<PlaceResult> _searchResults = [];
  bool _isSearching = false;
  bool _showResults = false;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _searchPlaces(String query) async {
    if (query.length < 3) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      // Use Nominatim API (OpenStreetMap's free geocoding service)
      final uri = Uri.parse('https://nominatim.openstreetmap.org/search')
          .replace(
            queryParameters: {
              'q': query,
              'format': 'json',
              'limit': '10',
              'addressdetails': '1',
              if (widget.currentLocation != null) ...{
                'lat': widget.currentLocation!.latitude.toString(),
                'lon': widget.currentLocation!.longitude.toString(),
              },
            },
          );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'HRA-FoDAS/1.0', // Required by Nominatim
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (mounted) {
          setState(() {
            _searchResults = data
                .map((item) => PlaceResult.fromNominatim(item))
                .toList();
            _showResults = true;
            _isSearching = false;
          });
        }
      } else {
        AppLogger.error(
          'Search error: ${response.statusCode}',
          tag: 'PLACE_SEARCH',
        );
        if (mounted) {
          setState(() {
            _isSearching = false;
            _showResults = false;
          });
        }
      }
    } catch (e) {
      AppLogger.error('Search exception: $e', tag: 'PLACE_SEARCH');
      if (mounted) {
        setState(() {
          _isSearching = false;
          _showResults = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.hintText ?? 'Search for places...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults = [];
                          _showResults = false;
                        });
                      },
                    )
                  : _isSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),

        // Search results
        if (_showResults && _searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _searchResults.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final place = _searchResults[index];
                return ListTile(
                  leading: Icon(
                    _getCategoryIcon(place.category),
                    color: Colors.blue.shade700,
                  ),
                  title: Text(
                    place.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    place.shortAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: place.distance != null
                      ? Text(
                          '${(place.distance! / 1000).toStringAsFixed(1)} km',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        )
                      : null,
                  onTap: () {
                    widget.onPlaceSelected(place);
                    _searchController.text = place.name;
                    setState(() => _showResults = false);
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  IconData _getCategoryIcon(String? category) {
    if (category == null) return Icons.place;

    final cat = category.toLowerCase();
    if (cat.contains('restaurant') ||
        cat.contains('food') ||
        cat.contains('cafe'))
      return Icons.restaurant;
    if (cat.contains('hospital') ||
        cat.contains('medical') ||
        cat.contains('clinic'))
      return Icons.local_hospital;
    if (cat.contains('school') ||
        cat.contains('education') ||
        cat.contains('university'))
      return Icons.school;
    if (cat.contains('bank') || cat.contains('atm'))
      return Icons.account_balance;
    if (cat.contains('gas') || cat.contains('fuel'))
      return Icons.local_gas_station;
    if (cat.contains('parking')) return Icons.local_parking;
    if (cat.contains('hotel') || cat.contains('motel')) return Icons.hotel;
    if (cat.contains('shop') ||
        cat.contains('store') ||
        cat.contains('supermarket'))
      return Icons.shopping_cart;
    if (cat.contains('park') || cat.contains('garden')) return Icons.park;

    return Icons.place;
  }
}

/// Place result model for OpenStreetMap Nominatim
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
          ? nameParts
                .sublist(1, nameParts.length > 3 ? 3 : nameParts.length)
                .join(',')
                .trim()
          : displayName,
      fullAddress: displayName,
      latitude: double.parse(json['lat'].toString()),
      longitude: double.parse(json['lon'].toString()),
      category: json['type'],
      distance: null,
    );
  }
}

/// Standalone place search dialog
class PlaceSearchDialog extends StatelessWidget {
  final LocationPoint? currentLocation;

  const PlaceSearchDialog({super.key, this.currentLocation});

  static Future<PlaceResult?> show(
    BuildContext context, {
    LocationPoint? currentLocation,
  }) async {
    return showDialog<PlaceResult>(
      context: context,
      builder: (context) => PlaceSearchDialog(currentLocation: currentLocation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'Search Places',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PlaceSearchWidget(
              currentLocation: currentLocation,
              onPlaceSelected: (place) {
                Navigator.pop(context, place);
              },
            ),
          ],
        ),
      ),
    );
  }
}
