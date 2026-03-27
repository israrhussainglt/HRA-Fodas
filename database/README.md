# Database Scripts

This directory contains scripts for managing the Appwrite database schema and data migrations.

## Quick Start

1. **Install dependencies:**
```bash
npm install
```

2. **Configure environment:**
Create a `.env` file in this directory:
```env
APPWRITE_ENDPOINT=https://nyc.cloud.appwrite.io/v1
APPWRITE_PROJECT_ID=your_project_id
APPWRITE_DATABASE_ID=hra_fodas_main
APPWRITE_API_KEY=your_api_key
```

3. **Upload schema:**
```bash
node upload_schema_to_appwrite.js
```

## Files

### Core Files
- `appwrite_schema.json` - Complete database schema definition (source of truth)
- `upload_schema_to_appwrite.js` - Uploads schema to Appwrite (idempotent, safe to run multiple times)
- `MIGRATION_GUIDE.md` - Detailed migration instructions and troubleshooting

### Migration Scripts
- `migrate_ngo_requests_schema.js` - Migrates NGO requests data to new schema
- `add_donation_id_to_ngo_requests.js` - Adds donation_id field to NGO requests

### Utility Scripts
- `verify_appwrite_schema.js` - Verifies schema matches Appwrite
- `create_appwrite_schema.js` - Creates schema from scratch
- `check_permissions.js` - Checks collection permissions
- `check_notifications.js` - Checks notification records

### Reference Files
- `database.sql` - SQL schema (for reference only)
- `SCHEMA_MAPPING.md` - SQL to Appwrite mapping guide

## Schema Upload Process

The `upload_schema_to_appwrite.js` script:
1. ✅ Creates database if it doesn't exist
2. ✅ Creates all collections
3. ✅ Creates all attributes (with proper handling of defaults)
4. ✅ Creates all indexes
5. ✅ Skips existing items (idempotent)
6. ✅ Never deletes data

**Important:** Fields with default values are automatically set as optional (required: false) in the schema file because Appwrite doesn't allow defaults on required fields.

## Schema Structure

### Collections

- **user_profiles** - User account information and roles
- **donations** - Food donation listings with pickup details
- **volunteer_profiles** - Volunteer information and availability
- **recipient_organizations** - NGO/recipient organization details
- **deliveries** - Delivery tracking and status
- **delivery_logs** - Delivery status history
- **notifications** - User notifications
- **conversations** - Chat conversations between users
- **chat_messages** - Individual chat messages
- **chat_logs** - Chat session logs
- **feedback_ratings** - User feedback and ratings
- **ratings** - Delivery ratings
- **inventory** - Recipient inventory management (legacy)
- **inventory_v2** - Updated inventory system
- **fcm_tokens** - Firebase Cloud Messaging tokens
- **notification_preferences** - User notification settings
- **scheduled_notifications** - Scheduled notification queue
- **pending_push_notifications** - Pending push notifications
- **messages** - Direct messages between users
- **feedback** - User feedback submissions
- **analytics_events** - Analytics event tracking
- **daily_statistics** - Daily aggregated statistics
- **ngo_requests** - NGO food requests (with snake_case food_category enum)

### Key Schema Features

- **Food Category Enum:** Uses snake_case values (`fresh_produce`, `dairy`, `meat`, `bakery`, `canned`, `prepared`, `other`)
- **Status Fields:** All status enums have default values and are optional
- **Timestamps:** Automatic `$createdAt` and `$updatedAt` fields on all collections
- **Indexes:** Optimized indexes for common queries (user lookups, status filtering, etc.)

## Common Tasks

### Update Schema

1. Edit `appwrite_schema.json`
2. Run: `node upload_schema_to_appwrite.js`
3. The script will create any missing attributes/indexes

### Migrate Data

1. Create a migration script (see `migrate_ngo_requests_schema.js` as example)
2. Test on a backup database first
3. Run migration: `node your_migration_script.js`

### Verify Schema

```bash
node verify_appwrite_schema.js
```

### Check Permissions

```bash
node check_permissions.js
```

## Important Notes

⚠️ **Before Running Migrations:**
- Always backup your data first
- Test migrations on a copy of your database
- Review the migration script output carefully

✅ **Safe Operations:**
- Running `upload_schema_to_appwrite.js` multiple times is safe
- The script never deletes existing data or attributes
- Existing attributes are skipped automatically

❌ **Unsafe Operations:**
- Deleting collections or attributes (do manually in Appwrite console)
- Modifying existing attribute types (requires manual migration)

## Troubleshooting

### Error: "Project with the requested ID could not be found"
- Check your `APPWRITE_PROJECT_ID` in `.env`
- Verify you're using the correct Appwrite endpoint

### Error: "Cannot set default value for required attribute"
- This should not happen with the updated schema
- All fields with defaults are now optional (required: false)

### Error: "Attribute already exists"
- This is normal when running the upload script multiple times
- The script will skip existing attributes

### Missing Indexes
- Indexes can only be created after attributes are available
- Wait a few seconds and run the script again if indexes fail

## Related Documentation

- `MIGRATION_GUIDE.md` - Comprehensive migration guide
- `SCHEMA_MAPPING.md` - SQL to Appwrite field mapping
- `../docs/PROJECT_STRUCTURE.md` - Overall project structure

## Support

For issues or questions:
1. Check the console output for detailed error messages
2. Review the Appwrite console for current schema state
3. Refer to `MIGRATION_GUIDE.md` for troubleshooting steps
