import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/models/route_models.dart';
import '../../../providers/route_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/route_optimization_service.dart';

class RoutePreviewScreen extends ConsumerStatefulWidget {
  final String routeId;

  const RoutePreviewScreen({
    super.key,
    required this.routeId,
  });

  @override
  ConsumerState<RoutePreviewScreen> createState() => _RoutePreviewScreenState();
}

class _RoutePreviewScreenState extends ConsumerState<RoutePreviewScreen> {
  final MapController _mapController = MapController();
  bool _isOptimizing = false;

  @override
  Widget build(BuildContext context) {
    final routeAsync = ref.watch(routeDetailsProvider(widget.routeId));
    final stopsAsync = ref.watch(routeStopsProvider(widget.routeId));
    final tomtomApiKey = dotenv.env['TOMTOM_API_KEY'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(routeDetailsProvider(widget.routeId));
              ref.invalidate(routeStopsProvider(widget.routeId));
            },
          ),
        ],
      ),
      body: routeAsync.when(
        data: (route) {
          if (route == null) {
            return const Center(child: Text('Route not found'));
          }

          return stopsAsync.when(
            data: (stops) {
              if (stops.isEmpty) {
                return const Center(child: Text('No stops in this route'));
              }

              return Column(
                children: [
                  // Map
                  Expanded(
                    flex: 2,
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: LatLng(
                          stops.first.locationLat,
                          stops.first.locationLng,
                        ),
                        initialZoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$tomtomApiKey',
                          userAgentPackageName: 'com.hrafodas.food_donation_app',
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: stops
                                  .map((s) => LatLng(s.locationLat, s.locationLng))
                                  .toList(),
                              color: AppTheme.primaryColor,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: _buildMarkers(stops),
                        ),
                      ],
                    ),
                  ),

                  // Route Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(
                              icon: Icons.location_on,
                              label: 'Stops',
                              value: '${stops.length}',
                            ),
                            if (route.totalDistance != null)
                              _buildStatItem(
                                icon: Icons.straighten,
                                label: 'Distance',
                                value: '${route.totalDistance!.toStringAsFixed(1)} km',
                              ),
                            if (route.totalDuration != null)
                              _buildStatItem(
                                icon: Icons.access_time,
                                label: 'Duration',
                                value: '${route.totalDuration} min',
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _isOptimizing ? null : () => _optimizeRoute(stops),
                                icon: _isOptimizing
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Icon(Icons.route),
                                label: Text(_isOptimizing ? 'Optimizing...' : 'Optimize Route'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _startNavigation(route),
                                icon: const Icon(Icons.navigation),
                                label: const Text('Start Navigation'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Stops List
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: stops.length,
                      itemBuilder: (context, index) {
                        final stop = stops[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: stop.stopType == StopType.pickup
                                  ? Colors.green
                                  : Colors.blue,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(stop.address),
                            subtitle: Text(
                              stop.stopType == StopType.pickup ? 'Pickup' : 'Drop-off',
                            ),
                            trailing: stop.distanceFromPrevious != null
                                ? Text('${stop.distanceFromPrevious!.toStringAsFixed(1)} km')
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  List<Marker> _buildMarkers(List<RouteStop> stops) {
    return stops.asMap().entries.map((entry) {
      final index = entry.key;
      final stop = entry.value;

      return Marker(
        point: LatLng(stop.locationLat, stop.locationLng),
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: stop.stopType == StopType.pickup ? Colors.green : Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Future<void> _optimizeRoute(List<RouteStop> stops) async {
    setState(() => _isOptimizing = true);

    try {
      // Get current location
      final currentLocation = await ref.read(currentLocationProvider.future);

      // Optimize
      final result = await ref.read(routeOptimizationProvider(
        RouteOptimizationParams(
          startLocation: currentLocation,
          stops: stops,
          algorithm: OptimizationAlgorithm.nearestNeighbor,
        ),
      ).future);

      // Update stops order
      final routeRepo = ref.read(routeRepositoryProvider);
      final stopIds = result.optimizedStops.map((s) => s.id).toList();
      await routeRepo.reorderStops(widget.routeId, stopIds);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Route optimized! Saved ${result.distanceSaved.toStringAsFixed(1)} km',
            ),
          ),
        );
        ref.invalidate(routeStopsProvider(widget.routeId));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error optimizing route: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isOptimizing = false);
      }
    }
  }

  void _startNavigation(DeliveryRoute route) {
    // Update route status to active
    ref.read(routeRepositoryProvider).updateRouteStatus(
          widget.routeId,
          RouteStatus.active,
        );

    // Navigate to active route screen
    Navigator.pushReplacementNamed(
      context,
      '/route/active',
      arguments: widget.routeId,
    );
  }
}
