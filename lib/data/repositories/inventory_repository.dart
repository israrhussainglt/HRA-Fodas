import 'package:appwrite/appwrite.dart';
import '../models/inventory_item.dart';
import '../../core/enums/enums.dart';
import '../../appwrite_options.dart';

class InventoryRepository {
  final TablesDB _databases; // Changed from _databases to _databases
  final Realtime _realtime;

  InventoryRepository(this._databases, this._realtime);

  Future<List<InventoryItem>> getInventory(String recipientId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        queries: [
          Query.equal('organization_id', recipientId),
          Query.orderAsc('expiration_date'),
        ],
      );

      return response.rows
          .map((doc) => InventoryItem.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      // Table or column doesn't exist yet
      return [];
    }
  }

  Future<List<InventoryItem>> getInventoryByCategory(
    String recipientId,
    FoodCategory category,
  ) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        queries: [
          Query.equal('organization_id', recipientId),
          Query.equal('food_category', category.dbValue),
          Query.orderAsc('expiration_date'),
        ],
      );

      return response.rows
          .map((doc) => InventoryItem.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<InventoryItem>> getExpiringItems(
    String recipientId, {
    int daysThreshold = 3,
  }) async {
    try {
      final thresholdDate = DateTime.now().add(Duration(days: daysThreshold));
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        queries: [
          Query.equal('organization_id', recipientId),
          Query.lessThanEqual(
            'expiration_date',
            thresholdDate.toIso8601String(),
          ),
          Query.greaterThanEqual(
            'expiration_date',
            DateTime.now().toIso8601String(),
          ),
          Query.orderAsc('expiration_date'),
        ],
      );

      return response.rows
          .map((doc) => InventoryItem.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<InventoryItem>> getLowStockItems(
    String recipientId, {
    double threshold = 10,
  }) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        queries: [
          Query.equal('organization_id', recipientId),
          Query.lessThanEqual('quantity', threshold),
          Query.orderAsc('quantity'),
        ],
      );

      return response.rows
          .map((doc) => InventoryItem.fromJson({...doc.data, 'id': doc.$id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<InventoryItem?> addInventoryItem(InventoryItem item) async {
    try {
      print('[INVENTORY] Adding item: ${item.name}, category: ${item.category.dbValue}, qty: ${item.quantity}');
      print('[INVENTORY] Data to send: ${item.toJson()}');
      
      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        rowId: ID.unique(),
        data: item.toJson(),
      );

      print('[INVENTORY] Item created successfully: ${response.$id}');
      return InventoryItem.fromJson({...response.data, 'id': response.$id});
    } on AppwriteException catch (e) {
      print('[INVENTORY] Appwrite error: ${e.message} (code: ${e.code})');
      print('[INVENTORY] Error type: ${e.type}');
      print('[INVENTORY] Error response: ${e.response}');
      rethrow;
    } catch (e, stackTrace) {
      print('[INVENTORY] Unexpected error: $e');
      print('[INVENTORY] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<InventoryItem?> updateInventoryItem(InventoryItem item) async {
    try {
      final response = await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        rowId: item.id,
        data: item.toJson(),
      );

      return InventoryItem.fromJson({...response.data, 'id': response.$id});
    } catch (e) {
      return null;
    }
  }

  Future<void> updateQuantity(String itemId, double newQuantity) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        rowId: itemId,
        data: {
          'quantity': newQuantity,
          'updated_at': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Ignore errors
    }
  }

  Future<void> deleteInventoryItem(String itemId) async {
    try {
      await _databases.deleteRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        rowId: itemId,
      );
    } catch (e) {
      // Ignore errors
    }
  }

  Future<Map<FoodCategory, double>> getInventorySummary(
    String recipientId,
  ) async {
    try {
      final items = await getInventory(recipientId);
      final summary = <FoodCategory, double>{};

      for (final item in items) {
        summary[item.category] = (summary[item.category] ?? 0) + item.quantity;
      }

      return summary;
    } catch (e) {
      return {};
    }
  }

  Future<void> addFromDonation({
    required String recipientId,
    required String donationId,
    required String name,
    required FoodCategory category,
    required double quantity,
    required String unit,
    required DateTime expirationDate,
  }) async {
    try {
      await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.inventoryCollection,
        rowId: ID.unique(),
        data: {
          'organization_id': recipientId,
          'donation_id': donationId,
          'item_name': name,
          'food_category': category.dbValue,
          'quantity': quantity,
          'unit': unit,
          'expiration_date': expirationDate.toIso8601String(),
          'received_date': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      // Ignore errors
    }
  }

  Stream<List<InventoryItem>> watchInventory(String recipientId) {
    // TODO: Implement Appwrite Realtime subscriptions
    // For now, return a stream that fetches data once
    return Stream.fromFuture(getInventory(recipientId));
  }
}
