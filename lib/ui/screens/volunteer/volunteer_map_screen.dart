import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/route_models.dart';
import '../../../providers/route_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../route/route_preview_screen.dart';
import '../route/active_route_screen.dart';
import '../../widgets/simple_labeled_map.dart';
import '../../widgets/place_search_widget.dart';

class VolunteerMapScreen extends ConsumerStatefulWidget {
  const VolunteerMapScreen({super.key});

  @override
  ConsumerState<VolunteerMapScreen> createState() => _VolunteerMapScreenState();
}

class _VolunteerMapScreenState extends ConsumerState<VolunteerMapScreen> {
  final MapController _mapController = MapController();
  bool _showAvailableDonations = true;
  bool _showMyRoutes = true;
  bool _showPlaceLabels = true;
  bool _showRoadNames = true;
  bool _showBuildings = true;
  bool _showSearchBar = false;

  @override
  Widget build(BuildContext context) {
    final currentLocationAsync = ref.watch(currentLocationProvider);
    final activeRouteAsync = ref.watch(activeRouteProvider);
    final volunteerRoutesAsync = ref.watch(volunteerRoutesProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Map with OpenStreetMap (includes all labels)
          currentLocationAsync.when(
            data: (location) => SimpleLabeledMap(
              mapController: _mapController,
              center: LatLng(location.latitude, location.longitude),
              zoom: 13.0,
              markers: _buildMarkers(location, activeRouteAsync, volunteerRoutesAsync),
              polylines: _buildPolylines(activeRouteAsync),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Location Error: $e'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(currentLocationProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          if (_showSearchBar)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: currentLocationAsync.maybeWhen(
                data: (location) => PlaceSearchWidget(
                  currentLocation: location,
                  onPlaceSelected: (place) {
                    _mapController.move(
                      LatLng(place.latitude, place.longitude),
                      16.0,
                    );
                    setState(() => _showSearchBar = false);
                  },
                ),
                orElse: () => const SizedBox.shrink(),
              ),
            ),

          // Top Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.map, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Route Map',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(_showSearchBar ? Icons.close : Icons.search),
                          onPressed: () {
                            setState(() => _showSearchBar = !_showSearchBar);
                          },
                          tooltip: 'Search Places',
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: _showFilterDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    activeRouteAsync.when(
                      data: (activeRoute) {
                        if (activeRoute != null) {
                          return _buildActiveRouteCard(activeRoute);
                        }
                        return volunteerRoutesAsync.when(
                          data: (routes) {
                            if (routes.isEmpty) {
                              return const Text(
                                'No active routes. Accept a delivery to start!',
                                style: TextStyle(fontSize: 12),
                              );
                            }
                            return Text(
                              '${routes.length} planned route(s)',
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (e, s) => const SizedBox.shrink(),
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (e, s) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Zoom Controls
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom + 1,
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  onPressed: () {
                    _mapController.move(
                      _mapController.camera.center,
                      _mapController.camera.zoom - 1,
                    );
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'my_location',
                  onPressed: () {
                    final location = ref.read(currentLocationProvider);
                    location.whenData((loc) {
                      _mapController.move(
                        LatLng(loc.latitude, loc.longitude),
                        15.0,
                      );
                    });
                  },
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),

          // Bottom Action Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 80,
            child: activeRouteAsync.when(
              data: (activeRoute) {
                if (activeRoute != null) {
                  return ElevatedButton.icon(
                    onPressed: () => _navigateToActiveRoute(activeRoute.id),
                    icon: const Icon(Icons.navigation),
                    label: const Text('View Active Route'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  );
                }
                return volunteerRoutesAsync.when(
                  data: (routes) {
                    if (routes.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ElevatedButton.icon(
                      onPressed: () => _showRoutesDialog(routes),
                      icon: const Icon(Icons.route),
                      label: Text('View ${routes.length} Route(s)'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (e, s) => const SizedBox.shrink(),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers(
    LocationPoint currentLocation,
    AsyncValue<DeliveryRoute?> activeRouteAsync,
    AsyncValue<List<DeliveryRoute>> volunteerRoutesAsync,
  ) {
    final markers = <Marker>[];

    // Add current location marker
    markers.add(
      Marker(
        point: LatLng(currentLocation.latitude, currentLocation.longitude),
        width: 40,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blue, width: 3),
          ),
          child: const Icon(Icons.person, color: Colors.blue, size: 20),
        ),
      ),
    );

    // Add active route markers
    activeRouteAsync.whenData((activeRoute) {
      if (activeRoute != null && activeRoute.stops.isNotEmpty) {
        for (var i = 0; i < activeRoute.stops.length; i++) {
          final stop = activeRoute.stops[i];
          markers.add(
            Marker(
              point: LatLng(stop.locationLat, stop.locationLng),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showStopDetails(stop, i + 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: stop.stopType == StopType.pickup
                        ? Colors.green
                        : Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }
    });

    // Add planned route markers
    if (_showMyRoutes) {
      volunteerRoutesAsync.whenData((routes) {
        for (final route in routes) {
          if (route.status == RouteStatus.planned && route.stops.isNotEmpty) {
            for (final stop in route.stops) {
              markers.add(
                Marker(
                  point: LatLng(stop.locationLat, stop.locationLng),
                  width: 30,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              );
            }
          }
        }
      });
    }

    return markers;
  }

  List<Polyline> _buildPolylines(AsyncValue<DeliveryRoute?> activeRouteAsync) {
    final polylines = <Polyline>[];

    activeRouteAsync.whenData((activeRoute) {
      if (activeRoute != null && activeRoute.stops.length > 1) {
        final points = activeRoute.stops
            .map((stop) => LatLng(stop.locationLat, stop.locationLng))
            .toList();

        polylines.add(
          Polyline(
            points: points,
            color: AppTheme.primaryColor,
            strokeWidth: 4.0,
          ),
        );
      }
    });

    return polylines;
  }

  Widget _buildActiveRouteCard(DeliveryRoute route) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.navigation, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Active Route',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${route.stops.length} stops',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          if (route.totalDistance != null)
            Text(
              '${route.totalDistance!.toStringAsFixed(1)} km',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  void _showStopDetails(RouteStop stop, int number) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: stop.stopType == StopType.pickup
                        ? Colors.green
                        : Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.stopType == StopType.pickup ? 'Pickup' : 'Drop-off',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        stop.address,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (stop.contactName != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 8),
                  Text(stop.contactName!),
                ],
              ),
            ],
            if (stop.contactPhone != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.phone, size: 20),
                  const SizedBox(width: 8),
                  Text(stop.contactPhone!),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map Display Options'),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Route Filters',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                title: const Text('Show Available Donations'),
                value: _showAvailableDonations,
                onChanged: (value) {
                  setState(() => _showAvailableDonations = value ?? true);
                  this.setState(() {});
                },
              ),
              CheckboxListTile(
                title: const Text('Show My Routes'),
                value: _showMyRoutes,
                onChanged: (value) {
                  setState(() => _showMyRoutes = value ?? true);
                  this.setState(() {});
                },
              ),
              const Divider(),
              const Text(
                'Map Display',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CheckboxListTile(
                title: const Text('Show Place Labels'),
                subtitle: const Text('Display nearby places and POIs'),
                value: _showPlaceLabels,
                onChanged: (value) {
                  setState(() => _showPlaceLabels = value ?? true);
                  this.setState(() {});
                },
              ),
              CheckboxListTile(
                title: const Text('Show Road Names'),
                subtitle: const Text('Display street and road labels'),
                value: _showRoadNames,
                onChanged: (value) {
                  setState(() => _showRoadNames = value ?? true);
                  this.setState(() {});
                },
              ),
              CheckboxListTile(
                title: const Text('Show Buildings'),
                subtitle: const Text('Display building outlines'),
                value: _showBuildings,
                onChanged: (value) {
                  setState(() => _showBuildings = value ?? true);
                  this.setState(() {});
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRoutesDialog(List<DeliveryRoute> routes) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Routes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...routes.map((route) => Card(
                  child: ListTile(
                    leading: Icon(
                      route.status == RouteStatus.active
                          ? Icons.navigation
                          : Icons.route,
                      color: route.status == RouteStatus.active
                          ? AppTheme.primaryColor
                          : Colors.grey,
                    ),
                    title: Text('${route.stops.length} stops'),
                    subtitle: Text(
                      route.status == RouteStatus.active
                          ? 'Active'
                          : 'Planned',
                    ),
                    trailing: route.totalDistance != null
                        ? Text('${route.totalDistance!.toStringAsFixed(1)} km')
                        : null,
                    onTap: () {
                      Navigator.pop(context);
                      if (route.status == RouteStatus.active) {
                        _navigateToActiveRoute(route.id);
                      } else {
                        _navigateToRoutePreview(route.id);
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _navigateToActiveRoute(String routeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveRouteScreen(routeId: routeId),
      ),
    );
  }

  void _navigateToRoutePreview(String routeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoutePreviewScreen(routeId: routeId),
      ),
    );
  }
}
