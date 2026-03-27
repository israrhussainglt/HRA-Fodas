import 'package:appwrite/appwrite.dart';
import '../models/delivery.dart';
import '../../core/enums/enums.dart';
import '../../appwrite_options.dart';

class DeliveryRepository {
  final TablesDB _databases; // Changed from _databases to _databases

  DeliveryRepository(this._databases);

  Future<List<Delivery>> getDeliveriesForVolunteer(String volunteerId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        queries: [
          Query.equal('volunteer_id', volunteerId),
          Query.orderDesc('\$createdAt'),
        ],
      );

      final deliveries = <Delivery>[];
      for (final doc in response.rows) {
        try {
          final delivery = Delivery.fromJson(doc.data);
          deliveries.add(delivery);
        } catch (e) {
          // Skip invalid delivery documents and continue
          continue;
        }
      }

      return deliveries;
    } on AppwriteException catch (e) {
      throw Exception('Failed to get deliveries: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get deliveries: $e');
    }
  }

  Future<List<Delivery>> getDeliveriesForRecipient(String recipientId) async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        queries: [
          Query.equal('recipient_id', recipientId),
          Query.orderDesc('\$createdAt'),
        ],
      );

      final deliveries = <Delivery>[];
      for (final doc in response.rows) {
        try {
          final delivery = Delivery.fromJson(doc.data);
          deliveries.add(delivery);
        } catch (e) {
          // Skip invalid delivery documents and continue
          continue;
        }
      }

      return deliveries;
    } on AppwriteException catch (e) {
      throw Exception('Failed to get deliveries: ${e.message}');
    }
  }

  Future<Delivery> getDeliveryById(String id) async {
    try {
      final response = await _databases.getRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        rowId: id,
      );

      return Delivery.fromJson(response.data);
    } on AppwriteException catch (e) {
      throw Exception('Failed to get delivery: ${e.message}');
    } catch (e) {
      throw Exception('Failed to parse delivery data: $e');
    }
  }

  Future<Delivery> createDelivery(Delivery delivery) async {
    try {
      final deliveryData = delivery.toJson();
      // Remove null values and ensure proper data types
      deliveryData.removeWhere((key, value) => value == null);

      final response = await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        rowId: ID.unique(),
        data: deliveryData,
      );

      final createdDelivery = Delivery.fromJson(response.data);
      return createdDelivery;
    } on AppwriteException catch (e) {
      throw Exception('Failed to create delivery: ${e.message}');
    } catch (e) {
      throw Exception('Failed to parse created delivery data: $e');
    }
  }

  Future<void> updateDeliveryStatus(
    String id,
    DeliveryStatus status, {
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{'status': status.dbValue};

      if (status == DeliveryStatus.pickedUp) {
        updates['pickup_time'] = DateTime.now().toIso8601String();
      } else if (status == DeliveryStatus.delivered) {
        updates['delivery_time'] = DateTime.now().toIso8601String();
      }

      if (notes != null) {
        updates['notes'] = notes;
      }

      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        rowId: id,
        data: updates,
      );

      // Log the status change
      await _databases.createRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveryLogsCollection,
        rowId: ID.unique(),
        data: {'delivery_id': id, 'status': status.dbValue, 'notes': notes},
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to update delivery status: ${e.message}');
    }
  }

  Future<void> updateDeliveryRecipient(String id, String recipientId) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        rowId: id,
        data: {'recipient_id': recipientId},
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to update delivery recipient: ${e.message}');
    }
  }

  Future<void> updateDeliveryLocation(
    String id,
    double latitude,
    double longitude,
  ) async {
    try {
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        rowId: id,
        data: {'current_latitude': latitude, 'current_longitude': longitude},
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to update delivery location: ${e.message}');
    }
  }

  Future<void> uploadDeliveryPhoto(
    String id,
    String photoUrl,
    bool isPickup,
  ) async {
    try {
      final field = isPickup ? 'pickup_photo_url' : 'delivery_photo_url';
      await _databases.updateRow(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        rowId: id,
        data: {field: photoUrl},
      );
    } on AppwriteException catch (e) {
      throw Exception('Failed to upload delivery photo: ${e.message}');
    }
  }

  // Note: For real-time updates, implement Realtime subscription in UI layer
  Stream<Delivery> watchDelivery(String id) async* {
    yield await getDeliveryById(id);
  }

  // Debug method to help identify problematic deliveries
  Future<void> debugDeliveries() async {
    try {
      final response = await _databases.listRows(
        databaseId: AppwriteOptions.databaseId,
        tableId: AppwriteOptions.deliveriesCollection,
        queries: [Query.limit(10)],
      );

      for (final doc in response.rows) {
        try {
          Delivery.fromJson(doc.data);
        } catch (e) {
          // Log parsing errors silently
        }
      }
    } catch (e) {
      // Log debug errors silently
    }
  }
}
