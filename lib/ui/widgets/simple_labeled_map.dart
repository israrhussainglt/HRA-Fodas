import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/logger.dart';

/// OpenStreetMap-based map widget with all labels built-in
/// Includes place names, road names, and building outlines
/// Follows flutter_map best practices from https://docs.fleaflet.dev
class SimpleLabeledMap extends StatefulWidget {
  final MapController mapController;
  final LatLng center;
  final double zoom;
  final List<Marker> markers;
  final List<Polyline> polylines;

  const SimpleLabeledMap({
    super.key,
    required this.mapController,
    required this.center,
    this.zoom = 13.0,
    this.markers = const [],
    this.polylines = const [],
  });

  @override
  State<SimpleLabeledMap> createState() => _SimpleLabeledMapState();
}

class _SimpleLabeledMapState extends State<SimpleLabeledMap> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Hide loading after tiles start loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: widget.zoom,
            minZoom: 3.0,
            maxZoom: 19.0,
            onMapReady: () {
              AppLogger.info('Map is ready', tag: 'MAP');
              if (mounted) {
                setState(() => _isLoading = false);
              }
            },
          ),
          children: [
            // OpenStreetMap tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.hrafodas.food_donation_app',
              maxZoom: 19,
              tileSize: 256,
              // Preload surrounding tiles for smoother experience
              panBuffer: 2,
              // Fade in animation for tiles
              tileDisplay: const TileDisplay.fadeIn(
                duration: Duration(milliseconds: 200),
              ),
              errorTileCallback: (tile, error, stackTrace) {
                AppLogger.error(
                  'Tile error at ${tile.coordinates}: $error',
                  tag: 'MAP',
                );
              },
            ),

            // Polylines (routes) - mobile layer
            if (widget.polylines.isNotEmpty)
              PolylineLayer(polylines: widget.polylines),

            // User markers - mobile layer
            if (widget.markers.isNotEmpty) MarkerLayer(markers: widget.markers),

            // Attribution widget - static layer (required by OSM)
            RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                    Uri.parse('https://openstreetmap.org/copyright'),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Loading indicator
        if (_isLoading)
          Container(
            color: Colors.white.withValues(alpha: 0.9),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading OpenStreetMap...',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Includes roads, places & buildings',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
