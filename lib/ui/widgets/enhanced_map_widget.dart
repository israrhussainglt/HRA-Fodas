import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enhanced map widget with OpenStreetMap
/// Includes multiple tile layers, overlays, and controls
/// Follows flutter_map best practices from https://docs.fleaflet.dev
class EnhancedMapWidget extends StatefulWidget {
  final MapController mapController;
  final LatLng center;
  final double zoom;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final List<Polygon> polygons;
  final bool showTraffic;
  final bool showPlaceLabels;
  final bool showRoadNames;
  final bool showBuildings;
  final MapStyle mapStyle;

  const EnhancedMapWidget({
    super.key,
    required this.mapController,
    required this.center,
    this.zoom = 13.0,
    this.markers = const [],
    this.polylines = const [],
    this.polygons = const [],
    this.showTraffic = false,
    this.showPlaceLabels = true,
    this.showRoadNames = true,
    this.showBuildings = true,
    this.mapStyle = MapStyle.standard,
  });

  @override
  State<EnhancedMapWidget> createState() => _EnhancedMapWidgetState();
}

class _EnhancedMapWidgetState extends State<EnhancedMapWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
              if (mounted) {
                setState(() => _isLoading = false);
              }
            },
          ),
          children: [
            // Base tile layer (mobile layer)
            _buildTileLayer(),

            // Polygons (areas) - mobile layer
            if (widget.polygons.isNotEmpty)
              PolygonLayer(polygons: widget.polygons),

            // Polylines (routes) - mobile layer
            if (widget.polylines.isNotEmpty)
              PolylineLayer(polylines: widget.polylines),

            // Markers - mobile layer
            if (widget.markers.isNotEmpty) MarkerLayer(markers: widget.markers),

            // Attribution widget - static layer (required)
            RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              attributions: _getAttributions(),
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
                  Text('Loading map...'),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTileLayer() {
    String urlTemplate;
    double maxZoom = 19.0;

    switch (widget.mapStyle) {
      case MapStyle.satellite:
        // Use Esri World Imagery (free)
        urlTemplate =
            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';
        maxZoom = 18.0;
      case MapStyle.terrain:
        // Use OpenTopoMap (free)
        urlTemplate = 'https://tile.opentopomap.org/{z}/{x}/{y}.png';
        maxZoom = 17.0;
      case MapStyle.dark:
        // Use CartoDB Dark Matter (free)
        urlTemplate =
            'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png';
      case MapStyle.standard:
        // Use OpenStreetMap (free)
        urlTemplate = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    }

    return TileLayer(
      urlTemplate: urlTemplate,
      userAgentPackageName: 'com.hrafodas.food_donation_app',
      maxZoom: maxZoom,
      subdomains: widget.mapStyle == MapStyle.dark
          ? const ['a', 'b', 'c', 'd']
          : const [],
      panBuffer: 2, // Preload surrounding tiles
      tileDisplay: const TileDisplay.fadeIn(
        duration: Duration(milliseconds: 200),
      ),
    );
  }

  List<SourceAttribution> _getAttributions() {
    switch (widget.mapStyle) {
      case MapStyle.satellite:
        return [
          TextSourceAttribution(
            'Esri',
            onTap: () => launchUrl(Uri.parse('https://www.esri.com')),
          ),
        ];
      case MapStyle.terrain:
        return [
          TextSourceAttribution(
            'OpenTopoMap',
            onTap: () => launchUrl(Uri.parse('https://opentopomap.org')),
          ),
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () =>
                launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ];
      case MapStyle.dark:
        return [
          TextSourceAttribution(
            'CartoDB',
            onTap: () => launchUrl(Uri.parse('https://carto.com/attributions')),
          ),
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () =>
                launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ];
      case MapStyle.standard:
        return [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () =>
                launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ];
    }
  }
}

/// Map style options
enum MapStyle {
  standard, // OpenStreetMap
  satellite, // Esri World Imagery
  terrain, // OpenTopoMap
  dark, // CartoDB Dark Matter
}
