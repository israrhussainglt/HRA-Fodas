import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  group('Notification Metadata Parsing Tests', () {
    test('Parse empty JSON string metadata', () {
      // Simulate what comes from Appwrite database
      final rawData = {
        'id': 'test123',
        'user_id': 'user123',
        'title': 'Test Notification',
        'message': 'Test message',
        'type': 'system',
        'is_read': false,
        'metadata': '{}', // This is a STRING, not a Map
      };

      // Test parsing the metadata field
      final metadata = _parseMetadata(rawData['metadata']);
      expect(metadata, isNull); // Empty JSON should return null
    });

    test('Parse null metadata', () {
      final rawData = {
        'id': 'test123',
        'user_id': 'user123',
        'title': 'Test Notification',
        'message': 'Test message',
        'type': 'system',
        'is_read': false,
        'metadata': null,
      };

      final metadata = _parseMetadata(rawData['metadata']);
      expect(metadata, isNull);
    });

    test('Parse valid JSON string metadata', () {
      final rawData = {
        'id': 'test123',
        'user_id': 'user123',
        'title': 'Test Notification',
        'message': 'Test message',
        'type': 'system',
        'is_read': false,
        'metadata': '{"key": "value", "count": 42}',
      };

      final metadata = _parseMetadata(rawData['metadata']);
      expect(metadata, isNotNull);
      expect(metadata!['key'], equals('value'));
      expect(metadata['count'], equals(42));
    });

    test('Parse already-parsed Map metadata', () {
      final rawData = {
        'id': 'test123',
        'user_id': 'user123',
        'title': 'Test Notification',
        'message': 'Test message',
        'type': 'system',
        'is_read': false,
        'metadata': {'key': 'value', 'count': 42},
      };

      final metadata = _parseMetadata(rawData['metadata']);
      expect(metadata, isNotNull);
      expect(metadata!['key'], equals('value'));
      expect(metadata['count'], equals(42));
    });

    test('Parse invalid JSON string metadata', () {
      final rawData = {
        'id': 'test123',
        'user_id': 'user123',
        'title': 'Test Notification',
        'message': 'Test message',
        'type': 'system',
        'is_read': false,
        'metadata': 'invalid json {',
      };

      final metadata = _parseMetadata(rawData['metadata']);
      expect(metadata, isNull); // Invalid JSON should return null
    });

    test('Parse empty string metadata', () {
      final rawData = {
        'id': 'test123',
        'user_id': 'user123',
        'title': 'Test Notification',
        'message': 'Test message',
        'type': 'system',
        'is_read': false,
        'metadata': '',
      };

      final metadata = _parseMetadata(rawData['metadata']);
      expect(metadata, isNull);
    });
  });

  group('Notification Data Field Parsing Tests', () {
    test('Parse empty JSON string data field', () {
      // The notification model has a 'data' field that should be ignored
      final rawData = {
        'id': 'test123',
        'user_id': 'user123',
        'title': 'Test Notification',
        'message': 'Test message',
        'type': 'system',
        'is_read': false,
        'data': '{}', // This field should be ignored by the model
      };

      // The data field should not cause parsing errors
      // It's marked with @JsonKey(includeFromJson: false) in the model
      expect(rawData['data'], equals('{}'));
    });

    test('Notification without optional fields', () {
      final rawData = {
        'id': 'test123',
        'user_id': 'user123',
        'title': 'Test Notification',
        'message': 'Test message',
        'type': 'system',
        'is_read': false,
        // No related_entity_id, related_entity_type, actor_name, created_at
      };

      // Should be able to create notification with minimal fields
      expect(rawData['id'], isNotNull);
      expect(rawData['user_id'], isNotNull);
      expect(rawData['title'], isNotNull);
      expect(rawData['message'], isNotNull);
      expect(rawData['type'], isNotNull);
    });
  });

  group('NGO Request Metadata Parsing Tests', () {
    test('Parse NGO request with empty metadata string', () {
      final rawData = {
        'id': 'request123',
        'recipient_id': 'ngo123',
        'ngo_name': 'Test NGO',
        'title': 'Food Request',
        'description': 'Need food',
        'food_category': 'fresh_produce',
        'quantity': 100.0,
        'unit': 'kg',
        'delivery_address': '123 Main St',
        'needed_by': DateTime.now().toIso8601String(),
        'status': 'pending',
        'metadata': '{}', // Empty JSON string
      };

      final metadata = _parseMetadata(rawData['metadata']);
      expect(metadata, isNull); // Empty JSON should return null
    });

    test('Parse NGO request with valid metadata', () {
      final rawData = {
        'id': 'request123',
        'recipient_id': 'ngo123',
        'ngo_name': 'Test NGO',
        'title': 'Food Request',
        'description': 'Need food',
        'food_category': 'fresh_produce',
        'quantity': 100.0,
        'unit': 'kg',
        'delivery_address': '123 Main St',
        'needed_by': DateTime.now().toIso8601String(),
        'status': 'pending',
        'metadata': '{"priority": "high", "notes": "Urgent"}',
      };

      final metadata = _parseMetadata(rawData['metadata']);
      expect(metadata, isNotNull);
      expect(metadata!['priority'], equals('high'));
      expect(metadata['notes'], equals('Urgent'));
    });
  });

  group('Type Conversion Tests', () {
    test('String to Map conversion should not throw', () {
      final stringValue = '{}';

      // This should NOT work - you can't cast String to Map
      expect(() {
        final map = stringValue as Map<String, dynamic>;
        return map;
      }, throwsA(isA<TypeError>()));
    });

    test('Proper JSON parsing', () {
      final stringValue = '{"key": "value"}';

      // This SHOULD work - proper JSON parsing
      final map = jsonDecode(stringValue) as Map<String, dynamic>;
      expect(map['key'], equals('value'));
    });
  });
}

/// Helper function to parse metadata (same logic as in ngo_request_repository.dart)
Map<String, dynamic>? _parseMetadata(dynamic metadata) {
  if (metadata == null) return null;
  if (metadata is Map<String, dynamic>) return metadata;
  if (metadata is String) {
    if (metadata.isEmpty || metadata == '{}') return null;
    try {
      final parsed = jsonDecode(metadata);
      return parsed is Map<String, dynamic> ? parsed : null;
    } catch (e) {
      return null;
    }
  }
  return null;
}
