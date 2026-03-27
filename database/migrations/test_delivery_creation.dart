import 'package:appwrite/appwrite.dart';
import 'dart:io';

/// Test script to verify delivery creation works with null recipient_id
///
/// Run this after applying the migration to confirm the fix works.
///
/// Usage: dart run database/migrations/test_delivery_creation.dart
void main() async {
  // Load environment variables
  final endpoint =
      Platform.environment['APPWRITE_ENDPOINT'] ??
      'https://cloud.appwrite.io/v1';
  final projectId = Platform.environment['APPWRITE_PROJECT_ID'];
  final apiKey = Platform.environment['APPWRITE_API_KEY'];

  if (projectId == null || apiKey == null) {
    print('❌ Error: APPWRITE_PROJECT_ID and APPWRITE_API_KEY must be set');
    exit(1);
  }

  print('🧪 Testing delivery creation with null recipient_id');
  print('   Endpoint: $endpoint');
  print('   Project: $projectId');
  print('');

  // Initialize Appwrite client
  final client = Client()
      .setEndpoint(endpoint)
      .setProject(projectId)
      .setKey(apiKey);

  final databases = Databases(client);
  const databaseId = 'hra_fodas_main';
  const collectionId = 'deliveries';

  try {
    print('📝 Test 1: Creating delivery without recipient_id...');

    final testDelivery = await databases.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: ID.unique(),
      data: {
        'donation_id': 'test_donation_${DateTime.now().millisecondsSinceEpoch}',
        'volunteer_id':
            'test_volunteer_${DateTime.now().millisecondsSinceEpoch}',
        // recipient_id is intentionally omitted (null)
        'status': 'assigned',
        'estimated_arrival': DateTime.now()
            .add(Duration(hours: 1))
            .toIso8601String(),
      },
    );

    print('✅ Test 1 PASSED: Delivery created successfully');
    print('   Delivery ID: ${testDelivery.$id}');
    print(
      '   Recipient ID: ${testDelivery.data['recipient_id'] ?? 'null (as expected)'}',
    );
    print('');

    print('📝 Test 2: Updating delivery with recipient_id...');

    final updatedDelivery = await databases.updateDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: testDelivery.$id,
      data: {
        'recipient_id':
            'test_recipient_${DateTime.now().millisecondsSinceEpoch}',
      },
    );

    print('✅ Test 2 PASSED: Delivery updated with recipient');
    print('   Recipient ID: ${updatedDelivery.data['recipient_id']}');
    print('');

    print('🧹 Cleaning up test data...');

    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: testDelivery.$id,
    );

    print('✅ Cleanup complete');
    print('');

    print('✨ All tests passed!');
    print('');
    print('📊 Summary:');
    print('   ✅ Deliveries can be created without recipient_id');
    print('   ✅ Recipients can be assigned to existing deliveries');
    print('   ✅ The fix is working correctly');
    print('');
    print('🎯 Next: Test in the app by having a volunteer accept a donation');
  } catch (e) {
    print('❌ Test failed: $e');
    print('');
    print('🔍 This likely means the migration has not been applied yet.');
    print(
      '   Run: dart run database/migrations/fix_delivery_recipient_optional.dart',
    );
    exit(1);
  }
}
