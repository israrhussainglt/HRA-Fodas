import 'dart:async';
import '../data/models/route_models.dart';
import 'location_service.dart';

/// Geofencing service for arrival detection and notifications
class GeofencingService {
  final LocationService _locationService;
  final Map<String, GeofenceMonitor> _activeMonitors = {};

  GeofencingService(this._locationService);

  /// Start monitoring a geofence
  GeofenceMonitor startMonitoring({
    required String id,
    required double latitude,
    required double longitude,
    double radiusMeters = 100.0,
    required Function(GeofenceEvent) onEnter,
    Function(GeofenceEvent)? onExit,
    Function(GeofenceEvent)? onDwell,
    Duration? dwellTime,
  }) {
    // Cancel existing monitor if any
    stopMonitoring(id);

    final monitor = GeofenceMonitor(
      id: id,
      centerLat: latitude,
      centerLng: longitude,
      radiusMeters: radiusMeters,
      onEnter: onEnter,
      onExit: onExit,
      onDwell: onDwell,
      dwellTime: dwellTime ?? const Duration(seconds: 30),
    );

    _activeMonitors[id] = monitor;

    // Start listening to location updates
    monitor._subscription = _locationService
        .getLocationStream(distanceFilter: 5)
        .listen((location) => _checkGeofence(monitor, location));

    return monitor;
  }

  /// Stop monitoring a geofence
  void stopMonitoring(String id) {
    final monitor = _activeMonitors.remove(id);
    monitor?._subscription?.cancel();
  }

  /// Stop all monitors
  void stopAll() {
    for (final monitor in _activeMonitors.values) {
      monitor._subscription?.cancel();
    }
    _activeMonitors.clear();
  }

  /// Check if location is within geofence
  void _checkGeofence(GeofenceMonitor monitor, LocationPoint location) {
    final distance = _locationService.calculateDistance(
      monitor.centerLat,
      monitor.centerLng,
      location.latitude,
      location.longitude,
    );

    final isInside = distance <= monitor.radiusMeters;
    final wasInside = monitor._isInside;

    if (isInside && !wasInside) {
      // Entered geofence
      monitor._isInside = true;
      monitor._enteredAt = DateTime.now();
      monitor.onEnter(
        GeofenceEvent(
          geofenceId: monitor.id,
          location: location,
          distance: distance,
          timestamp: DateTime.now(),
          type: GeofenceEventType.enter,
        ),
      );
    } else if (!isInside && wasInside) {
      // Exited geofence
      monitor._isInside = false;
      monitor._enteredAt = null;
      monitor.onExit?.call(
        GeofenceEvent(
          geofenceId: monitor.id,
          location: location,
          distance: distance,
          timestamp: DateTime.now(),
          type: GeofenceEventType.exit,
        ),
      );
    } else if (isInside && wasInside && monitor.onDwell != null) {
      // Check dwell time
      final enteredAt = monitor._enteredAt;
      if (enteredAt != null) {
        final dwellDuration = DateTime.now().difference(enteredAt);
        if (dwellDuration >= monitor.dwellTime && !monitor._dwellTriggered) {
          monitor._dwellTriggered = true;
          monitor.onDwell?.call(
            GeofenceEvent(
              geofenceId: monitor.id,
              location: location,
              distance: distance,
              timestamp: DateTime.now(),
              type: GeofenceEventType.dwell,
              dwellDuration: dwellDuration,
            ),
          );
        }
      }
    }
  }

  /// Get all active monitors
  List<GeofenceMonitor> getActiveMonitors() {
    return _activeMonitors.values.toList();
  }

  /// Check if a geofence is being monitored
  bool isMonitoring(String id) {
    return _activeMonitors.containsKey(id);
  }

  /// Monitor multiple stops
  void monitorRouteStops({
    required List<RouteStop> stops,
    required Function(String stopId, GeofenceEvent event) onStopEvent,
    double radiusMeters = 100.0,
  }) {
    for (final stop in stops) {
      if (stop.status == StopStatus.pending ||
          stop.status == StopStatus.enRoute) {
        startMonitoring(
          id: stop.id,
          latitude: stop.locationLat,
          longitude: stop.locationLng,
          radiusMeters: radiusMeters,
          onEnter: (event) => onStopEvent(stop.id, event),
          onExit: (event) => onStopEvent(stop.id, event),
          onDwell: (event) => onStopEvent(stop.id, event),
        );
      }
    }
  }

  /// Stop monitoring route stops
  void stopMonitoringRoute(List<RouteStop> stops) {
    for (final stop in stops) {
      stopMonitoring(stop.id);
    }
  }
}

/// Geofence monitor
class GeofenceMonitor {
  final String id;
  final double centerLat;
  final double centerLng;
  final double radiusMeters;
  final Function(GeofenceEvent) onEnter;
  final Function(GeofenceEvent)? onExit;
  final Function(GeofenceEvent)? onDwell;
  final Duration dwellTime;

  StreamSubscription<LocationPoint>? _subscription;
  bool _isInside = false;
  DateTime? _enteredAt;
  bool _dwellTriggered = false;

  GeofenceMonitor({
    required this.id,
    required this.centerLat,
    required this.centerLng,
    required this.radiusMeters,
    required this.onEnter,
    this.onExit,
    this.onDwell,
    required this.dwellTime,
  });

  bool get isInside => _isInside;
  DateTime? get enteredAt => _enteredAt;

  void dispose() {
    _subscription?.cancel();
  }
}

/// Geofence event
class GeofenceEvent {
  final String geofenceId;
  final LocationPoint location;
  final double distance;
  final DateTime timestamp;
  final GeofenceEventType type;
  final Duration? dwellDuration;

  GeofenceEvent({
    required this.geofenceId,
    required this.location,
    required this.distance,
    required this.timestamp,
    required this.type,
    this.dwellDuration,
  });
}

/// Geofence event type
enum GeofenceEventType { enter, exit, dwell }
