# Database Schema Migration Guide

## Overview

This guide explains how to migrate your Appwrite database schema to align with the Flutter application codebase.

## Prerequisites

1. Node.js installed (v14 or higher)
2. Appwrite account with API access
3. Environment variables configured in `.env` file

## Environment Setup

Create a `.env` file in the `database/` directory with the following variables:

```env
APPWRITE_ENDPOINT=https://cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your_project_id
APPWRITE_API_KEY=your_api_key
APPWRITE_DATABASE_ID=your_database_id
```

## Migration Steps

### Step 1: Install Dependencies

```bash
cd database
npm install
```

### Step 2: Review Current Schema

Review the current schema in your Appwrite console and compare it with `appwrite_schema.json`.

### Step 3: Backup Your Data

**IMPORTANT**: Always backup your data before running migrations!

```bash
# Use Appwrite console to export your data
# Or use the Appwrite CLI:
appwrite databases export --database-id your_database_id
```

### Step 4: Run NGO Requests Migration (if needed)

If you have existing NGO requests data, run the migration script:

```bash
node migrate_ngo_requests_schema.js
```

This script will:
- Create new attributes (`food_category`, `quantity`, etc.)
- Migrate existing data from old fields to new fields
- Provide instructions for manual cleanup

**Review the output carefully** and verify the migration was successful.

### Step 5: Upload Complete Schema

Upload the complete schema to Appwrite:

```bash
node upload_schema_to_appwrite.js
```

This script will:
- Create the database if it doesn't exist
- Create all collections defined in `appwrite_schema.json`
- Create all attributes for each collection
- Create all indexes

**Note**: This script will NOT delete existing data or attributes. It only creates missing ones.

### Step 6: Verify Schema

After running the scripts, verify in the Appwrite console that:

1. All collections exist
2. All attributes are created with correct types
3. All indexes are created
4. Existing data is intact

### Step 7: Clean Up Old Attributes (Optional)

After verifying the migration, you can clean up old attributes:

1. Edit `migrate_ngo_requests_schema.js`
2. Uncomment the cleanup section at the bottom
3. Run the script again:

```bash
node migrate_ngo_requests_schema.js
```

This will delete the old attributes:
- `food_categories` → replaced by `food_category`
- `quantity_needed` → replaced by `quantity`
- `urgency` → removed (not used in app)
- `fulfilled_quantity` → removed (not used in app)

## Schema Changes Summary

### NGO Requests Table

**Old Schema**:
```json
{
  "food_categories": "string",
  "quantity_needed": "double",
  "urgency": "enum",
  "status": ["open", "partially_fulfilled", "fulfilled", "cancelled", "expired"]
}
```

**New Schema**:
```json
{
  "food_category": "enum: ['fresh_produce', 'dairy', 'meat', 'bakery', 'canned', 'prepared', 'other']",
  "quantity": "double",
  "status": ["pending", "approved", "denied", "converted", "cancelled"],
  "ngo_name": "string",
  "delivery_address": "string",
  "denial_reason": "string",
  "reviewed_by": "string",
  "reviewed_at": "datetime",
  "converted_donation_id": "string",
  "metadata": "string"
}
```

### Donations Table

**Status**: ✅ Already aligned

The donations table already uses the correct schema with:
- `food_category` enum with snake_case values
- All required fields present

### Deliveries Table

**Status**: ✅ Already aligned

The deliveries table already uses the correct schema with:
- `recipient_id` as optional string
- All required fields present

## Troubleshooting

### Error: "Attribute already exists"

This is normal if you're running the script multiple times. The script will skip existing attributes.

### Error: "Collection not found"

Make sure your database ID is correct in the `.env` file.

### Error: "Invalid API key"

Check that your API key has the correct permissions:
- `databases.read`
- `databases.write`
- `collections.read`
- `collections.write`
- `attributes.read`
- `attributes.write`
- `indexes.read`
- `indexes.write`

### Data Migration Issues

If data migration fails for some documents:
1. Check the error messages in the console output
2. Manually fix the problematic documents in Appwrite console
3. Run the migration script again

## Rollback Procedure

If something goes wrong:

1. **Restore from backup**:
   ```bash
   # Use Appwrite console to import your backup
   # Or use the Appwrite CLI:
   appwrite databases import --database-id your_database_id --file backup.json
   ```

2. **Revert code changes**:
   ```bash
   git checkout HEAD -- lib/data/models/ngo_request.dart
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Update repository to use old field names**:
   - Edit `lib/data/repositories/ngo_request_repository.dart`
   - Revert to using `food_categories` and `quantity_needed`

## Testing After Migration

1. **Test NGO Request Creation**:
   - Create a new NGO request from the recipient dashboard
   - Verify it appears in the admin dashboard
   - Check all fields are saved correctly

2. **Test NGO Request Approval**:
   - Approve an NGO request as admin
   - Verify status updates correctly
   - Check notifications are sent

3. **Test NGO Request Denial**:
   - Deny an NGO request as admin
   - Verify denial reason is saved
   - Check notifications are sent

4. **Test Existing Data**:
   - View existing NGO requests
   - Verify all data displays correctly
   - Check food categories show proper values

## Support

If you encounter issues:

1. Check the console output for detailed error messages
2. Review the Appwrite console for schema state
3. Check the application logs for serialization errors
4. Refer to `SCHEMA_FIX_SUMMARY.md` for detailed analysis

## Related Files

- `appwrite_schema.json` - Complete database schema definition
- `migrate_ngo_requests_schema.js` - NGO requests migration script
- `upload_schema_to_appwrite.js` - Schema upload script
- `SCHEMA_FIX_SUMMARY.md` - Detailed analysis of schema issues
- `SCHEMA_MAPPING.md` - SQL to Appwrite mapping guide
- `../lib/data/models/ngo_request.dart` - NGO request model
- `../lib/data/repositories/ngo_request_repository.dart` - NGO request repository

## Version History

- **v1.0** (Feb 6, 2026): Initial migration guide
  - NGO requests schema alignment
  - Food category enum fix
  - Status enum alignment
