# Notification Metadata Fix

## Problem
The notification bell icon was throwing a `TypeError: "{}": type 'String' is not a subtype of type 'Map<String, dynamic>'` error when fetching notifications from the Appwrite database.

## Root Cause
The issue had two parts:

1. **Database Schema Mismatch**: The `notifications` collection in Appwrite has a `data` field that is a STRING type with default value `"{}"`. However, the `NotificationModel` in Dart has this field marked with `@JsonKey(includeFromJson: false)`, meaning it should be excluded from JSON parsing. When Appwrite returns the data, it includes this field as a string `"{}"`, which causes a type error when the JSON parser tries to handle it.

2. **Missing Optional Fields**: The database schema is missing these optional fields that the model expects:
   - `related_entity_id`
   - `related_entity_type`
   - `actor_name`

## Database Schema (Actual)
```json
{
  "name": "notifications",
  "attributes": [
    {"key": "user_id", "type": "string", "required": true},
    {"key": "title", "type": "string", "required": true},
    {"key": "message", "type": "string", "required": true},
    {"key": "type", "type": "string", "required": true},
    {"key": "data", "type": "string", "default": "{}", "required": false},
    {"key": "is_read", "type": "boolean", "default": false, "required": false}
  ]
}
```

## NotificationModel (Expected)
```dart
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String message,
    required NotificationType type,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'related_entity_id') String? relatedEntityId,
    @JsonKey(name: 'related_entity_type') String? relatedEntityType,
    @JsonKey(name: 'actor_name') String? actorName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(includeFromJson: false, includeToJson: false) @Default(null) String? data,
  }) = _NotificationModel;
}
```

## Solution
Updated `notification_repository.dart` to:

1. **Remove the `data` field** before parsing:
   ```dart
   data.remove('data');
   ```

2. **Add missing optional fields** with null values:
   ```dart
   if (!data.containsKey('related_entity_id')) {
     data['related_entity_id'] = null;
   }
   if (!data.containsKey('related_entity_type')) {
     data['related_entity_type'] = null;
   }
   if (!data.containsKey('actor_name')) {
     data['actor_name'] = null;
   }
   ```

3. **Updated `createNotification`** to only include fields that exist in the database schema.

## Files Modified
- `lib/data/repositories/notification_repository.dart` - Added defensive parsing for missing fields
- `test/notification_test.dart` - Comprehensive tests for metadata parsing (already existed)
- `docs/NOTIFICATION_METADATA_FIX.md` - This documentation

## Testing
Run the notification tests:
```bash
flutter test test/notification_test.dart
```

All 12 tests should pass.

## Future Improvements
If you need the missing fields (`related_entity_id`, `related_entity_type`, `actor_name`), you should:

1. Update the Appwrite database schema to add these fields
2. Run a migration script to add the fields to the `notifications` collection
3. Update the `createNotification` method to include these fields when creating notifications

## Related Issues
- Similar issue was fixed in `ngo_request_repository.dart` and `chat_repository.dart` where `metadata` fields were stored as JSON strings
- The pattern is: Appwrite stores JSON data as STRING fields, so we need to parse them before using them in Dart models
