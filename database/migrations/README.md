# Database Migration: Fix Delivery Creation Issue

## Problem

Volunteers cannot accept donations because delivery records fail to be created. The "My Deliveries" tab shows "No active deliveries" even after accepting donations.

**Root Cause:** The `recipient_id` field in the deliveries collection is marked as required, but volunteers accept donations before recipients are assigned (recipient_id is null).

## Solution

Make `recipient_id` optional in the deliveries collection schema.

## Files Changed

1. **database/appwrite_schema.json** - Updated schema definition
   - Changed `recipient_id` from `"required": true` to `"required": false`

2. **database/migrations/fix_delivery_recipient_optional.dart** - Migration script
   - Updates the Appwrite database schema
   - Verifies existing records are preserved

## How to Apply the Migration

### Prerequisites

- Appwrite project credentials (Project ID and API Key)
- API key must have database write permissions
- Dart SDK installed

### Steps

1. **Set environment variables:**

   ```bash
   export APPWRITE_ENDPOINT="https://cloud.appwrite.io/v1"
   export APPWRITE_PROJECT_ID="your-project-id"
   export APPWRITE_API_KEY="your-api-key"
   ```

   Or create a `.env` file in the project root:

   ```
   APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
   APPWRITE_PROJECT_ID=your-project-id
   APPWRITE_API_KEY=your-api-key
   ```

2. **Run the migration script:**

   ```bash
   dart run database/migrations/fix_delivery_recipient_optional.dart
   ```

3. **Verify the migration:**

   The script will output:
   - ✅ Confirmation that recipient_id is now optional
   - 📊 Count of existing delivery records (should be preserved)
   - 🎯 Next steps for testing

### Alternative: Manual Update via Appwrite Console

If you prefer to update manually:

1. Go to Appwrite Console → Databases → hra_fodas_main → deliveries
2. Click on the `recipient_id` attribute
3. Uncheck "Required"
4. Save changes

## Testing

After applying the migration:

1. **Test volunteer acceptance:**
   - Log in as a volunteer
   - Accept a donation
   - Verify no errors occur

2. **Verify delivery appears:**
   - Go to "My Deliveries" tab
   - Confirm the accepted delivery is visible
   - Check that recipient shows as "Pending" or similar

3. **Test recipient assignment:**
   - Create an NGO request
   - Approve the request
   - Verify the delivery updates with recipient information

## Expected Behavior After Fix

- ✅ Volunteers can accept donations successfully
- ✅ Delivery records are created with null recipient_id
- ✅ Deliveries appear in volunteer's "My Deliveries" tab immediately
- ✅ Recipients can be assigned later when NGO requests are approved
- ✅ No breaking changes to existing delivery records

## Rollback

If you need to rollback (not recommended):

1. Change `"required": false` back to `"required": true` in `appwrite_schema.json`
2. Run a migration to update the schema
3. Note: This will prevent new deliveries without recipients from being created

## Related Files

- `lib/data/models/delivery.dart` - Dart model (already has nullable recipientId)
- `lib/ui/widgets/donation_card.dart` - Delivery creation logic (already correct)
- `lib/data/repositories/delivery_repository.dart` - Query logic (already correct)

## Notes

- The Dart model already has `recipientId` as nullable, so no code changes are needed
- The delivery creation logic already handles null recipient_id correctly
- This is purely a schema constraint fix
- All existing delivery records will be preserved
