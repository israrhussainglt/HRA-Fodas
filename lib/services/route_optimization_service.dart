import 'dart:math';
import '../data/models/route_models.dart';
import 'location_service.dart';

/// Route optimization algorithms
enum OptimizationAlgorithm {
  nearestNeighbor,
  genetic,
  twoOpt,
}

class RouteOptimizationService {
  final LocationService _locationService;

  RouteOptimizationService(this._locationService);

  /// Optimize route using specified algorithm
  Future<RouteOptimizationResult> optimizeRoute({
    required LocationPoint startLocation,
    required List<RouteStop> stops,
    OptimizationAlgorithm algorithm = OptimizationAlgorithm.nearestNeighbor,
  }) async {
    final startTime = DateTime.now();

    // Calculate original route metrics
    final originalDistance = _calculateTotalDistance(startLocation, stops);
    final originalDuration = _estimateTotalDuration(originalDistance);

    // Optimize based on algorithm
    List<RouteStop> optimizedStops;
    switch (algorithm) {
      case OptimizationAlgorithm.nearestNeighbor:
        optimizedStops = await _nearestNeighborOptimization(startLocation, stops);
        break;
      case OptimizationAlgorithm.genetic:
        optimizedStops = await _geneticAlgorithmOptimization(startLocation, stops);
        break;
      case OptimizationAlgorithm.twoOpt:
        optimizedStops = await _twoOptOptimization(startLocation, stops);
        break;
    }

    // Calculate optimized route metrics
    final optimizedDistance = _calculateTotalDistance(startLocation, optimizedStops);
    final optimizedDuration = _estimateTotalDuration(optimizedDistance);

    final endTime = DateTime.now();
    final optimizationTime = endTime.difference(startTime).inMilliseconds;

    return RouteOptimizationResult(
      optimizedStops: optimizedStops,
      totalDistance: optimizedDistance,
      totalDuration: optimizedDuration,
      distanceSaved: originalDistance - optimizedDistance,
      timeSaved: originalDuration - optimizedDuration,
      algorithm: algorithm.name,
      optimizationTimeMs: optimizationTime,
    );
  }

  /// Nearest Neighbor Algorithm (Greedy approach)
  /// Time Complexity: O(n²)
  /// Good for: Quick optimization, small to medium routes
  Future<List<RouteStop>> _nearestNeighborOptimization(
    LocationPoint startLocation,
    List<RouteStop> stops,
  ) async {
    if (stops.isEmpty) return [];
    if (stops.length == 1) return stops;

    final optimized = <RouteStop>[];
    final remaining = List<RouteStop>.from(stops);
    var currentLocation = startLocation;

    while (remaining.isNotEmpty) {
      // Find nearest unvisited stop
      RouteStop? nearestStop;
      double minDistance = double.infinity;

      for (final stop in remaining) {
        final distance = _locationService.calculateDistanceKm(
          currentLocation.latitude,
          currentLocation.longitude,
          stop.locationLat,
          stop.locationLng,
        );

        if (distance < minDistance) {
          minDistance = distance;
          nearestStop = stop;
        }
      }

      if (nearestStop != null) {
        // Update stop with distance and duration from previous
        final updatedStop = nearestStop.copyWith(
          sequenceOrder: optimized.length + 1,
          distanceFromPrevious: minDistance,
          durationFromPrevious: _estimateDuration(minDistance),
        );

        optimized.add(updatedStop);
        remaining.remove(nearestStop);
        currentLocation = LocationPoint(
          latitude: nearestStop.locationLat,
          longitude: nearestStop.locationLng,
        );
      }
    }

    return optimized;
  }

  /// 2-Opt Algorithm (Local search optimization)
  /// Time Complexity: O(n²)
  /// Good for: Improving existing routes, medium routes
  Future<List<RouteStop>> _twoOptOptimization(
    LocationPoint startLocation,
    List<RouteStop> stops,
  ) async {
    if (stops.length < 4) {
      return _nearestNeighborOptimization(startLocation, stops);
    }

    // Start with nearest neighbor solution
    var currentRoute = await _nearestNeighborOptimization(startLocation, stops);
    var improved = true;

    while (improved) {
      improved = false;
      final currentDistance = _calculateTotalDistance(startLocation, currentRoute);

      // Try all possible 2-opt swaps
      for (var i = 1; i < currentRoute.length - 1; i++) {
        for (var j = i + 1; j < currentRoute.length; j++) {
          // Create new route by reversing segment between i and j
          final newRoute = _twoOptSwap(currentRoute, i, j);
          final newDistance = _calculateTotalDistance(startLocation, newRoute);

          if (newDistance < currentDistance) {
            currentRoute = newRoute;
            improved = true;
            break;
          }
        }
        if (improved) break;
      }
    }

    // Update sequence orders and distances
    return _updateStopMetrics(startLocation, currentRoute);
  }

  /// Genetic Algorithm (Evolutionary optimization)
  /// Time Complexity: O(generations * population * n²)
  /// Good for: Complex routes, finding near-optimal solutions
  Future<List<RouteStop>> _geneticAlgorithmOptimization(
    LocationPoint startLocation,
    List<RouteStop> stops,
  ) async {
    if (stops.length < 5) {
      return _nearestNeighborOptimization(startLocation, stops);
    }

    const populationSize = 50;
    const generations = 100;
    const mutationRate = 0.1;
    const eliteSize = 5;

    // Initialize population with random routes
    var population = _initializePopulation(stops, populationSize);

    for (var gen = 0; gen < generations; gen++) {
      // Evaluate fitness (shorter distance = better fitness)
      final fitness = population.map((route) {
        final distance = _calculateTotalDistance(startLocation, route);
        return 1.0 / (distance + 1); // Avoid division by zero
      }).toList();

      // Selection: Keep elite individuals
      final sortedIndices = List.generate(population.length, (i) => i)
        ..sort((a, b) => fitness[b].compareTo(fitness[a]));

      final newPopulation = <List<RouteStop>>[];

      // Elitism: Keep best solutions
      for (var i = 0; i < eliteSize; i++) {
        newPopulation.add(population[sortedIndices[i]]);
      }

      // Crossover and mutation
      while (newPopulation.length < populationSize) {
        // Tournament selection
        final parent1 = _tournamentSelection(population, fitness);
        final parent2 = _tournamentSelection(population, fitness);

        // Crossover
        var child = _orderCrossover(parent1, parent2);

        // Mutation
        if (Random().nextDouble() < mutationRate) {
          child = _mutate(child);
        }

        newPopulation.add(child);
      }

      population = newPopulation;
    }

    // Return best solution
    final bestRoute = population.reduce((a, b) {
      final distA = _calculateTotalDistance(startLocation, a);
      final distB = _calculateTotalDistance(startLocation, b);
      return distA < distB ? a : b;
    });

    return _updateStopMetrics(startLocation, bestRoute);
  }

  /// Initialize population for genetic algorithm
  List<List<RouteStop>> _initializePopulation(
    List<RouteStop> stops,
    int size,
  ) {
    final population = <List<RouteStop>>[];
    final random = Random();

    for (var i = 0; i < size; i++) {
      final route = List<RouteStop>.from(stops)..shuffle(random);
      population.add(route);
    }

    return population;
  }

  /// Tournament selection for genetic algorithm
  List<RouteStop> _tournamentSelection(
    List<List<RouteStop>> population,
    List<double> fitness,
  ) {
    const tournamentSize = 5;
    final random = Random();
    var bestIdx = random.nextInt(population.length);
    var bestFitness = fitness[bestIdx];

    for (var i = 1; i < tournamentSize; i++) {
      final idx = random.nextInt(population.length);
      if (fitness[idx] > bestFitness) {
        bestIdx = idx;
        bestFitness = fitness[idx];
      }
    }

    return population[bestIdx];
  }

  /// Order crossover (OX) for genetic algorithm
  List<RouteStop> _orderCrossover(
    List<RouteStop> parent1,
    List<RouteStop> parent2,
  ) {
    final random = Random();
    final size = parent1.length;
    final start = random.nextInt(size);
    final end = start + random.nextInt(size - start);

    final child = List<RouteStop?>.filled(size, null);

    // Copy segment from parent1
    for (var i = start; i <= end; i++) {
      child[i] = parent1[i];
    }

    // Fill remaining from parent2
    var childIdx = (end + 1) % size;
    var parent2Idx = (end + 1) % size;

    while (child.contains(null)) {
      final stop = parent2[parent2Idx];
      if (!child.contains(stop)) {
        child[childIdx] = stop;
        childIdx = (childIdx + 1) % size;
      }
      parent2Idx = (parent2Idx + 1) % size;
    }

    return child.cast<RouteStop>();
  }

  /// Mutation for genetic algorithm (swap two random stops)
  List<RouteStop> _mutate(List<RouteStop> route) {
    final random = Random();
    final mutated = List<RouteStop>.from(route);
    final i = random.nextInt(route.length);
    final j = random.nextInt(route.length);

    final temp = mutated[i];
    mutated[i] = mutated[j];
    mutated[j] = temp;

    return mutated;
  }

  /// 2-opt swap helper
  List<RouteStop> _twoOptSwap(List<RouteStop> route, int i, int j) {
    final newRoute = <RouteStop>[];

    // Add stops before i
    newRoute.addAll(route.sublist(0, i));

    // Add reversed segment between i and j
    newRoute.addAll(route.sublist(i, j + 1).reversed);

    // Add stops after j
    if (j + 1 < route.length) {
      newRoute.addAll(route.sublist(j + 1));
    }

    return newRoute;
  }

  /// Calculate total distance for a route
  double _calculateTotalDistance(
    LocationPoint startLocation,
    List<RouteStop> stops,
  ) {
    if (stops.isEmpty) return 0.0;

    var totalDistance = 0.0;
    var currentLocation = startLocation;

    for (final stop in stops) {
      totalDistance += _locationService.calculateDistanceKm(
        currentLocation.latitude,
        currentLocation.longitude,
        stop.locationLat,
        stop.locationLng,
      );

      currentLocation = LocationPoint(
        latitude: stop.locationLat,
        longitude: stop.locationLng,
      );
    }

    return totalDistance;
  }

  /// Estimate duration based on distance (assuming average speed)
  int _estimateDuration(double distanceKm) {
    const averageSpeedKmh = 40.0; // Average city driving speed
    const minutesPerHour = 60;
    return ((distanceKm / averageSpeedKmh) * minutesPerHour).round();
  }

  /// Estimate total duration for route
  int _estimateTotalDuration(double totalDistanceKm) {
    final drivingTime = _estimateDuration(totalDistanceKm);
    return drivingTime;
  }

  /// Update stop metrics (sequence, distance, duration)
  List<RouteStop> _updateStopMetrics(
    LocationPoint startLocation,
    List<RouteStop> stops,
  ) {
    final updated = <RouteStop>[];
    var currentLocation = startLocation;

    for (var i = 0; i < stops.length; i++) {
      final stop = stops[i];
      final distance = _locationService.calculateDistanceKm(
        currentLocation.latitude,
        currentLocation.longitude,
        stop.locationLat,
        stop.locationLng,
      );

      updated.add(stop.copyWith(
        sequenceOrder: i + 1,
        distanceFromPrevious: distance,
        durationFromPrevious: _estimateDuration(distance),
      ));

      currentLocation = LocationPoint(
        latitude: stop.locationLat,
        longitude: stop.locationLng,
      );
    }

    return updated;
  }

  /// Optimize route with time windows
  Future<RouteOptimizationResult> optimizeWithTimeWindows({
    required LocationPoint startLocation,
    required List<RouteStop> stops,
    required Map<String, TimeWindow> timeWindows,
  }) async {
    // Filter stops that can be visited within time windows
    final feasibleStops = stops.where((stop) {
      final window = timeWindows[stop.id];
      if (window == null) return true;

      final now = DateTime.now();
      return now.isBefore(window.end);
    }).toList();

    // Sort by time window urgency
    feasibleStops.sort((a, b) {
      final windowA = timeWindows[a.id];
      final windowB = timeWindows[b.id];

      if (windowA == null && windowB == null) return 0;
      if (windowA == null) return 1;
      if (windowB == null) return -1;

      return windowA.end.compareTo(windowB.end);
    });

    return optimizeRoute(
      startLocation: startLocation,
      stops: feasibleStops,
      algorithm: OptimizationAlgorithm.nearestNeighbor,
    );
  }

  /// Calculate route efficiency score (0-100)
  double calculateEfficiencyScore(
    double actualDistance,
    double optimalDistance,
  ) {
    if (optimalDistance == 0) return 100.0;
    final efficiency = (optimalDistance / actualDistance) * 100;
    return efficiency.clamp(0.0, 100.0);
  }
}

/// Time window for a stop
class TimeWindow {
  final DateTime start;
  final DateTime end;

  TimeWindow({required this.start, required this.end});
}
