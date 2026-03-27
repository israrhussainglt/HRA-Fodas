import 'dart:io';
import 'dart:math' show pi, log, tan, cos;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../core/utils/logger.dart';

/// Tile caching service for offline map support
class TileCacheService {
  static const String _cacheDir = 'map_tiles';
  static const int _maxCacheSize = 100 * 1024 * 1024; // 100 MB
  static const Duration _cacheExpiry = Duration(days: 30);

  /// Get cache directory
  Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${appDir.path}/$_cacheDir');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  /// Generate cache key for tile
  String _generateCacheKey(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Get cached tile
  Future<Uint8List?> getCachedTile(String url) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final cacheKey = _generateCacheKey(url);
      final file = File('${cacheDir.path}/$cacheKey');

      if (await file.exists()) {
        final stat = await file.stat();
        final age = DateTime.now().difference(stat.modified);

        // Check if cache is expired
        if (age > _cacheExpiry) {
          await file.delete();
          return null;
        }

        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      AppLogger.error('Error reading cached tile: $e', tag: 'TILE_CACHE');
      return null;
    }
  }

  /// Cache tile
  Future<void> cacheTile(String url, Uint8List data) async {
    try {
      final cacheDir = await _getCacheDirectory();
      final cacheKey = _generateCacheKey(url);
      final file = File('${cacheDir.path}/$cacheKey');

      await file.writeAsBytes(data);

      // Check cache size and clean if needed
      await _cleanCacheIfNeeded();
    } catch (e) {
      AppLogger.error('Error caching tile: $e', tag: 'TILE_CACHE');
    }
  }

  /// Download and cache tile
  Future<Uint8List?> downloadAndCacheTile(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = response.bodyBytes;
        await cacheTile(url, data);
        return data;
      }
      return null;
    } catch (e) {
      AppLogger.error('Error downloading tile: $e', tag: 'TILE_CACHE');
      return null;
    }
  }

  /// Get tile (from cache or download)
  Future<Uint8List?> getTile(String url) async {
    // Try cache first
    final cached = await getCachedTile(url);
    if (cached != null) {
      return cached;
    }

    // Download if not cached
    return await downloadAndCacheTile(url);
  }

  /// Pre-cache tiles for a region
  Future<void> precacheTilesForRegion({
    required double minLat,
    required double maxLat,
    required double minLng,
    required double maxLng,
    required int minZoom,
    required int maxZoom,
    required String urlTemplate,
    Function(int current, int total)? onProgress,
  }) async {
    int totalTiles = 0;
    int cachedTiles = 0;

    // Calculate total tiles
    for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
      final tiles = _getTilesForRegion(minLat, maxLat, minLng, maxLng, zoom);
      totalTiles += tiles.length;
    }

    // Download tiles
    for (int zoom = minZoom; zoom <= maxZoom; zoom++) {
      final tiles = _getTilesForRegion(minLat, maxLat, minLng, maxLng, zoom);

      for (final tile in tiles) {
        final url = urlTemplate
            .replaceAll('{z}', zoom.toString())
            .replaceAll('{x}', tile['x'].toString())
            .replaceAll('{y}', tile['y'].toString());

        await downloadAndCacheTile(url);
        cachedTiles++;
        onProgress?.call(cachedTiles, totalTiles);
      }
    }
  }

  /// Get tiles for region
  List<Map<String, int>> _getTilesForRegion(
    double minLat,
    double maxLat,
    double minLng,
    double maxLng,
    int zoom,
  ) {
    final tiles = <Map<String, int>>[];

    final minTileX = _lngToTileX(minLng, zoom);
    final maxTileX = _lngToTileX(maxLng, zoom);
    final minTileY = _latToTileY(maxLat, zoom);
    final maxTileY = _latToTileY(minLat, zoom);

    for (int x = minTileX; x <= maxTileX; x++) {
      for (int y = minTileY; y <= maxTileY; y++) {
        tiles.add({'x': x, 'y': y});
      }
    }

    return tiles;
  }

  /// Convert longitude to tile X
  int _lngToTileX(double lng, int zoom) {
    return ((lng + 180) / 360 * (1 << zoom)).floor();
  }

  /// Convert latitude to tile Y
  int _latToTileY(double lat, int zoom) {
    final latRad = lat * pi / 180;
    return ((1 - log(tan(latRad) + 1 / cos(latRad)) / pi) / 2 * (1 << zoom))
        .floor();
  }

  /// Clean cache if size exceeds limit
  Future<void> _cleanCacheIfNeeded() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final files = await cacheDir.list().toList();

      // Calculate total size
      int totalSize = 0;
      final fileStats = <File, FileStat>{};

      for (final entity in files) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
          fileStats[entity] = stat;
        }
      }

      // Clean if exceeds limit
      if (totalSize > _maxCacheSize) {
        // Sort by last modified (oldest first)
        final sortedFiles = fileStats.entries.toList()
          ..sort((a, b) => a.value.modified.compareTo(b.value.modified));

        // Delete oldest files until under limit
        for (final entry in sortedFiles) {
          if (totalSize <= _maxCacheSize * 0.8) break;

          await entry.key.delete();
          totalSize -= entry.value.size;
        }
      }
    } catch (e) {
      AppLogger.error('Error cleaning cache: $e', tag: 'TILE_CACHE');
    }
  }

  /// Get cache size
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final files = await cacheDir.list().toList();

      int totalSize = 0;
      for (final entity in files) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Clear all cache
  Future<void> clearCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create();
      }
    } catch (e) {
      AppLogger.error('Error clearing cache: $e', tag: 'TILE_CACHE');
    }
  }

  /// Get cache statistics
  Future<CacheStatistics> getCacheStatistics() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final files = await cacheDir.list().toList();

      int totalSize = 0;
      int fileCount = 0;
      DateTime? oldestFile;
      DateTime? newestFile;

      for (final entity in files) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
          fileCount++;

          if (oldestFile == null || stat.modified.isBefore(oldestFile)) {
            oldestFile = stat.modified;
          }
          if (newestFile == null || stat.modified.isAfter(newestFile)) {
            newestFile = stat.modified;
          }
        }
      }

      return CacheStatistics(
        totalSize: totalSize,
        fileCount: fileCount,
        oldestFile: oldestFile,
        newestFile: newestFile,
      );
    } catch (e) {
      return CacheStatistics(
        totalSize: 0,
        fileCount: 0,
        oldestFile: null,
        newestFile: null,
      );
    }
  }
}

/// Cache statistics
class CacheStatistics {
  final int totalSize;
  final int fileCount;
  final DateTime? oldestFile;
  final DateTime? newestFile;

  CacheStatistics({
    required this.totalSize,
    required this.fileCount,
    this.oldestFile,
    this.newestFile,
  });

  String get formattedSize {
    if (totalSize < 1024) return '$totalSize B';
    if (totalSize < 1024 * 1024) {
      return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
