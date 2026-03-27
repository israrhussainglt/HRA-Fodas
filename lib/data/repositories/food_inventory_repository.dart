import 'package:appwrite/appwrite.dart';
import '../models/meal_planner_models.dart';
import '../../appwrite_options.dart';

class FoodInventoryRepository {
  final TablesDB _databases; // Changed from Databases to TablesDB
  final Realtime _realtime;

  FoodInventoryRepository(this._databases, this._realtime);

  /// Get all food inventory for a user
  Stream<List<FoodInventoryItem>> getFoodInventory(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Get available inventory (items with quantity > 0)
  Stream<List<AvailableInventoryItem>> getAvailableInventory(String userId) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Get expiring inventory items
  Stream<List<ExpiringInventoryItem>> getExpiringInventory(
    String userId, {
    int daysThreshold = 7,
  }) {
    // TODO: Implement Appwrite Realtime subscriptions
    return Stream.value([]);
  }

  /// Get inventory item by ID
  Future<FoodInventoryItem?> getInventoryItemById(String itemId) async {
    try {
      final response = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'food_inventory',
        rowId: itemId,
      );

      return FoodInventoryItem.fromJson({...response.data, 'id': response.$id});
    } catch (e) {
      return null;
    }
  }

  /// Add food inventory item
  Future<FoodInventoryItem> addInventoryItem({
    required String recipientId,
    String? donationId,
    required String foodItem,
    required double quantity,
    required String unit,
    DateTime? expiryDate,
    String? category,
    Map<String, dynamic>? nutritionalInfo,
  }) async {
    final response = await _databases.createRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      rowId: ID.unique(),
      data: {
        'recipient_id': recipientId,
        'donation_id': donationId,
        'food_item': foodItem,
        'quantity': quantity,
        'unit': unit,
        'expiry_date': expiryDate?.toIso8601String(),
        'category': category,
        'nutritional_info': nutritionalInfo,
        'is_available': true,
        'used_quantity': 0.0,
      },
    );

    return FoodInventoryItem.fromJson({...response.data, 'id': response.$id});
  }

  /// Update inventory item
  Future<void> updateInventoryItem(
    String itemId,
    Map<String, dynamic> updates,
  ) async {
    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      rowId: itemId,
      data: updates,
    );
  }

  /// Update quantity
  Future<void> updateQuantity(String itemId, double newQuantity) async {
    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      rowId: itemId,
      data: {'quantity': newQuantity},
    );
  }

  /// Mark quantity as used
  Future<void> markAsUsed(String itemId, double usedQuantity) async {
    final item = await getInventoryItemById(itemId);
    if (item == null) return;

    final newUsedQuantity = item.usedQuantity + usedQuantity;
    final updates = <String, dynamic>{'used_quantity': newUsedQuantity};

    // If all quantity is used, mark as unavailable
    if (newUsedQuantity >= item.quantity) {
      updates['is_available'] = false;
    }

    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      rowId: itemId,
      data: updates,
    );
  }

  /// Mark item as unavailable
  Future<void> markAsUnavailable(String itemId) async {
    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      rowId: itemId,
      data: {'is_available': false},
    );
  }

  /// Mark item as available
  Future<void> markAsAvailable(String itemId) async {
    await _databases.updateRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      rowId: itemId,
      data: {'is_available': true},
    );
  }

  /// Delete inventory item
  Future<void> deleteInventoryItem(String itemId) async {
    await _databases.deleteRow(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      rowId: itemId,
    );
  }

  /// Add items from donation
  Future<List<FoodInventoryItem>> addItemsFromDonation({
    required String recipientId,
    required String donationId,
    required List<Map<String, dynamic>> items,
  }) async {
    final inventoryItems = <FoodInventoryItem>[];

    for (final item in items) {
      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'food_inventory',
        rowId: ID.unique(),
        data: {
          'recipient_id': recipientId,
          'donation_id': donationId,
          'food_item': item['food_item'],
          'quantity': item['quantity'],
          'unit': item['unit'],
          'expiry_date': item['expiry_date'],
          'category': item['category'],
          'nutritional_info': item['nutritional_info'],
          'is_available': true,
          'used_quantity': 0.0,
        },
      );

      inventoryItems.add(
        FoodInventoryItem.fromJson({...response.data, 'id': response.$id}),
      );
    }

    return inventoryItems;
  }

  /// Get inventory by category
  Future<List<FoodInventoryItem>> getInventoryByCategory(
    String userId,
    String category,
  ) async {
    final response = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      queries: [
        Query.equal('recipient_id', userId),
        Query.equal('category', category),
        Query.equal('is_available', true),
        Query.orderAsc('expiry_date'),
      ],
    );

    return response.rows
        .map((doc) => FoodInventoryItem.fromJson({...doc.data, 'id': doc.$id}))
        .toList();
  }

  /// Search inventory items
  Future<List<FoodInventoryItem>> searchInventory(
    String userId,
    String query,
  ) async {
    final response = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      queries: [
        Query.equal('recipient_id', userId),
        Query.search('food_item', query),
        Query.orderDesc('created_at'),
      ],
    );

    return response.rows
        .map((doc) => FoodInventoryItem.fromJson({...doc.data, 'id': doc.$id}))
        .toList();
  }

  /// Get total inventory count
  Future<int> getTotalInventoryCount(String userId) async {
    final response = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      queries: [
        Query.equal('recipient_id', userId),
        Query.equal('is_available', true),
      ],
    );

    return response.total;
  }

  /// Get inventory statistics
  Future<Map<String, dynamic>> getInventoryStats(String userId) async {
    final inventory = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      queries: [Query.equal('recipient_id', userId)],
    );

    final totalItems = inventory.total;
    int availableItems = 0;
    int expiringItems = 0;
    final categoryCounts = <String, int>{};

    for (final doc in inventory.rows) {
      if (doc.data['is_available'] == true) {
        availableItems++;
      }

      if (doc.data['expiry_date'] != null) {
        final expiryDate = DateTime.parse(doc.data['expiry_date']);
        final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
        if (daysUntilExpiry <= 7 && daysUntilExpiry >= 0) {
          expiringItems++;
        }
      }

      final category = doc.data['category'] ?? 'Other';
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }

    return {
      'total_items': totalItems,
      'available_items': availableItems,
      'expiring_items': expiringItems,
      'category_counts': categoryCounts,
    };
  }

  /// Clear all expired items
  Future<int> clearExpiredItems(String userId) async {
    final now = DateTime.now();
    final expiredItems = await _databases.listRows(
      databaseId: AppwriteOptions.databaseId,
      tableId: 'food_inventory',
      queries: [
        Query.equal('recipient_id', userId),
        Query.lessThan('expiry_date', now.toIso8601String()),
      ],
    );

    int deletedCount = 0;
    for (final doc in expiredItems.rows) {
      await _databases.deleteRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: 'food_inventory',
        rowId: doc.$id,
      );
      deletedCount++;
    }

    return deletedCount;
  }
}
