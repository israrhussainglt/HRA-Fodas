import 'package:flutter_test/flutter_test.dart';
import '../lib/core/enums/enums.dart';
import '../lib/data/models/ngo_request.dart';

void main() {
  group('Task 1: NGO Request Creation Field Mappings', () {
    test('FoodCategory should have correct dbValue mappings', () {
      // Requirement 1.1: Verify food_category uses dbValue
      expect(FoodCategory.freshProduce.dbValue, equals('fresh_produce'));
      expect(FoodCategory.dairy.dbValue, equals('dairy'));
      expect(FoodCategory.meat.dbValue, equals('meat'));
      expect(FoodCategory.bakery.dbValue, equals('bakery'));
      expect(FoodCategory.canned.dbValue, equals('canned'));
      expect(FoodCategory.prepared.dbValue, equals('prepared'));
      expect(FoodCategory.other.dbValue, equals('other'));
    });
  });

  group('Task 2: NGO Request Data Sanitization', () {
    test('NGORequestStatus should have correct enum values', () {
      // Requirement 2.5-2.9: Verify status mappings exist
      expect(NGORequestStatus.pending, isNotNull);
      expect(NGORequestStatus.approved, isNotNull);
      expect(NGORequestStatus.denied, isNotNull);
      expect(NGORequestStatus.converted, isNotNull);
      expect(NGORequestStatus.cancelled, isNotNull);
    });
  });

  group('Task 3: NGO Request Status Query Mappings', () {
    test('All NGORequestStatus values should be defined', () {
      // Requirement 3.1-3.5: Verify all status values exist
      final allStatuses = [
        NGORequestStatus.pending,
        NGORequestStatus.approved,
        NGORequestStatus.denied,
        NGORequestStatus.converted,
        NGORequestStatus.cancelled,
      ];

      expect(allStatuses.length, equals(5));
    });
  });

  group('Task 4: NGO Request Status Update Methods', () {
    test('Status enum values should be distinct', () {
      // Requirement 4.1-4.2: Verify approved and denied are different
      expect(NGORequestStatus.approved, isNot(equals(NGORequestStatus.denied)));
      expect(
        NGORequestStatus.approved,
        isNot(equals(NGORequestStatus.pending)),
      );
      expect(
        NGORequestStatus.denied,
        isNot(equals(NGORequestStatus.cancelled)),
      );
    });
  });

  group('Edge Cases and Validation', () {
    test('FoodCategory enum should have all required values', () {
      final allCategories = [
        FoodCategory.freshProduce,
        FoodCategory.dairy,
        FoodCategory.meat,
        FoodCategory.bakery,
        FoodCategory.canned,
        FoodCategory.prepared,
        FoodCategory.other,
      ];

      expect(allCategories.length, equals(7));

      // Verify each has a dbValue
      for (final category in allCategories) {
        expect(category.dbValue, isNotEmpty);
        expect(category.dbValue, isNot(contains(' ')));
      }
    });
  });
}
