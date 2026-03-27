# Schema Alignment Fix Summary

## Date: February 6, 2026

## Issues Found

### 1. NGO Request Model - Food Category Serialization ✅ FIXED

**Problem**: The `NGORequest` model was using auto-generated `freezed` JSON serialization which used camelCase (`'freshProduce'`) instead of snake_case (`'fresh_produce'`) for the food category enum.

**Impact**: This would cause serialization errors when reading/writing to the database.

**Solution**: Added a custom `FoodCategoryConverter` class to the NGO request model that uses the `FoodCategoryExtension.dbValue` and `FoodCategoryExtension.fromString` methods to properly convert between Dart enums and database values.

**Files Modified**:
- `lib/data/models/ngo_request.dart` - Added `FoodCategoryConverter` and `@JsonKey` annotations

**Code Changes**:
```dart
/// Custom JSON converter for FoodCategory enum to use snake_case in database
class FoodCategoryConverter implements JsonConverter<FoodCategory, String> {
  const FoodCategoryConverter();

  @override
  FoodCategory fromJson(String json) => FoodCategoryExtension.fromString(json);

  @override
  String toJson(FoodCategory object) => object.dbValue;
}

@freezed
class NGORequest with _$NGORequest {
  const factory NGORequest({
    @FoodCategoryConverter() @JsonKey(name: 'food_category') required FoodCategory foodCategory,
    // ... other fields with proper @JsonKey annotations
  }) = _NGORequest;
}
```

### 2. Database Schema - NGO Requests Table Mismatch ⚠️ NEEDS ATTENTION

**Problem**: The database schema in `database/appwrite_schema.json` has significant mismatches with the application code:

| Database Schema | Application Model | Status |
|----------------|-------------------|---------|
| `food_categories` (string) | `food_category` (enum) | ❌ Mismatch |
| `quantity_needed` (double) | `quantity` (double) | ❌ Mismatch |
| Missing fields | `delivery_address`, `ngo_name`, `reviewed_by`, `reviewed_at`, `denial_reason`, `converted_donation_id`, `metadata` | ❌ Missing |
| `status` enum: `['open', 'partially_fulfilled', 'fulfilled', 'cancelled', 'expired']` | `status` enum: `['pending', 'approved', 'denied', 'converted', 'cancelled']` | ❌ Mismatch |

**Current Workaround**: The `NGORequestRepository` handles these mismatches by:
1. Mapping field names during create/update operations
2. Using `_sanitizeData()` method to map schema fields back to model fields
3. Mapping status values between schema and application enums

**Recommended Solution**: Update the database schema to match the application model:

```json
{
  "name": "ngo_requests",
  "id": "ngo_requests",
  "permissions": ["read(\"any\")"],
  "attributes": [
    { "key": "recipient_id", "type": "string", "size": 36, "required": true },
    { "key": "ngo_name", "type": "string", "size": 255, "required": false },
    { "key": "title", "type": "string", "size": 255, "required": true },
    { "key": "description", "type": "string", "size": 2000, "required": true },
    { "key": "food_category", "type": "enum", "elements": ["fresh_produce", "dairy", "meat", "bakery", "canned", "prepared", "other"], "required": true },
    { "key": "quantity", "type": "double", "required": true },
    { "key": "unit", "type": "string", "size": 50, "required": true },
    { "key": "delivery_address", "type": "string", "size": 500, "required": false },
    { "key": "needed_by", "type": "datetime", "required": true },
    { "key": "status", "type": "enum", "elements": ["pending", "approved", "denied", "converted", "cancelled"], "required": true, "default": "pending" },
    { "key": "donation_id", "type": "string", "size": 36, "required": false },
    { "key": "denial_reason", "type": "string", "size": 1000, "required": false },
    { "key": "reviewed_by", "type": "string", "size": 36, "required": false },
    { "key": "reviewed_at", "type": "datetime", "required": false },
    { "key": "converted_donation_id", "type": "string", "size": 36, "required": false },
    { "key": "metadata", "type": "string", "size": 5000, "required": false, "default": "{}" }
  ],
  "indexes": [
    { "key": "recipient_idx", "type": "key", "attributes": ["recipient_id"] },
    { "key": "status_idx", "type": "key", "attributes": ["status"] },
    { "key": "donation_idx", "type": "key", "attributes": ["donation_id"] }
  ]
}
```

### 3. Delivery Model - Recipient ID Default ✅ ALIGNED

**Status**: The delivery model already treats `recipientId` as nullable (`String?`), which matches the database schema expectation.

**Database Schema**: `recipient_id` is optional (not required)
**Flutter Model**: `final String? recipientId;`

No changes needed.

## Summary of Changes Made

1. ✅ Fixed NGO request model food category serialization
2. ✅ Added proper `@JsonKey` annotations for all fields in NGO request model
3. ✅ Regenerated freezed code with `dart run build_runner build --delete-conflicting-outputs`

## Next Steps

### Option 1: Update Database Schema (Recommended)

Update the Appwrite database schema to match the application model. This will:
- Eliminate the need for field name mapping in the repository
- Provide proper enum validation at the database level
- Support all application features (approval workflow, denial reasons, etc.)

**Steps**:
1. Review the recommended schema above
2. Create a migration script to:
   - Rename `food_categories` → `food_category`
   - Rename `quantity_needed` → `quantity`
   - Add missing fields
   - Update status enum values
   - Migrate existing data
3. Update `database/appwrite_schema.json`
4. Run the migration script
5. Simplify `NGORequestRepository._sanitizeData()` method

### Option 2: Keep Current Workaround

Continue using the current field mapping approach in the repository. This works but:
- Requires maintaining mapping logic in the repository
- Limits functionality (missing fields return null/empty values)
- Makes the code harder to understand and maintain

## Files to Review

- `database/appwrite_schema.json` - Database schema definition
- `lib/data/repositories/ngo_request_repository.dart` - Field mapping logic
- `lib/data/models/ngo_request.dart` - Model definition (now fixed)
- `docs/NGO_REQUESTS_SCHEMA_FIX.md` - Previous schema fix documentation

## Testing Recommendations

After applying fixes:
1. Test NGO request creation with all food categories
2. Test NGO request approval/denial workflow
3. Test NGO request to donation conversion
4. Verify all fields serialize/deserialize correctly
5. Test with existing data in the database

## Related Documentation

- `SCHEMA_MISMATCH_ANALYSIS.md` - Original analysis document
- `.kiro/specs/schema-alignment-fix/` - Spec files for this fix
- `docs/NGO_REQUESTS_SCHEMA_FIX.md` - Previous schema fix documentation
