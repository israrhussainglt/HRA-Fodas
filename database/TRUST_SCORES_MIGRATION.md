# Trust Scores Table Migration Guide

## Overview
This guide explains how to create the `trust_scores` table in your Appwrite database to enable trust score functionality in the User Management screen.

## Prerequisites
- Node.js installed
- Appwrite project configured
- `.env` file in the `database` folder with correct credentials

## Migration Steps

### 1. Verify Environment Configuration
Make sure your `database/.env` file contains:
```env
APPWRITE_ENDPOINT=your_appwrite_endpoint
APPWRITE_PROJECT_ID=your_project_id
APPWRITE_API_KEY=your_api_key
```

### 2. Install Dependencies (if not already installed)
```bash
cd database
npm install
```

### 3. Run the Migration Script
```bash
node create_trust_scores_table.js
```

### 4. Verify Table Creation
You should see output like:
```
Creating trust_scores table...
✓ Collection created
Creating attribute: user_id
Creating attribute: trust_score
Creating attribute: reliability_score
...
✓ All attributes created
Creating index on user_id...
✓ Index created

✅ Trust scores table created successfully!
```

### 5. Verify in Appwrite Console
1. Open your Appwrite Console
2. Navigate to Databases → hra_fodas_main
3. You should see a new table called `trust_scores`
4. Check that it has all the required attributes:
   - user_id (string, 36 chars)
   - trust_score (integer, default: 50)
   - reliability_score (integer, default: 50)
   - total_interactions (integer, default: 0)
   - positive_feedback_count (integer, default: 0)
   - negative_feedback_count (integer, default: 0)
   - completed_donations (integer, default: 0)
   - completed_deliveries (integer, default: 0)
   - cancelled_count (integer, default: 0)
   - last_calculated (datetime)

## Troubleshooting

### Error: "Collection already exists"
If you see this error, the table already exists. You can either:
- Delete the existing table from Appwrite Console and run the script again
- Skip this migration

### Error: "Invalid API key"
- Verify your API key in the `.env` file
- Make sure the API key has the necessary permissions (Database write access)

### Error: "Attribute creation failed"
- Wait a few seconds and try again (Appwrite may be processing previous requests)
- Check Appwrite Console to see which attributes were created
- You may need to manually create the missing attributes

## What This Enables

After running this migration, the following features will work in the User Management screen:

1. **Calculate Trust Score**: Calculates and stores trust scores for users based on their activity
2. **View Trust Score**: Displays trust and reliability scores with visual indicators
3. **Trust Score History**: Tracks when trust scores were last calculated

## Schema Details

### Table: trust_scores
- **Collection ID**: trust_scores
- **Permissions**: read(any)
- **Indexes**: 
  - user_idx (unique) on user_id field

### Attributes
| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| user_id | string(36) | Yes | - | User's unique ID |
| trust_score | integer | No | 50 | Trust score (0-100) |
| reliability_score | integer | No | 50 | Reliability score (0-100) |
| total_interactions | integer | No | 0 | Total number of interactions |
| positive_feedback_count | integer | No | 0 | Count of positive feedback |
| negative_feedback_count | integer | No | 0 | Count of negative feedback |
| completed_donations | integer | No | 0 | Number of completed donations |
| completed_deliveries | integer | No | 0 | Number of completed deliveries |
| cancelled_count | integer | No | 0 | Number of cancelled actions |
| last_calculated | datetime | No | - | When score was last calculated |

## Next Steps

After the migration is complete:
1. Restart your Flutter app
2. Navigate to Admin Dashboard → User Management
3. Click "Calculate Trust Score" on any user
4. Verify that the trust score displays correctly

## Rollback

If you need to remove the trust_scores table:
1. Open Appwrite Console
2. Navigate to Databases → hra_fodas_main → trust_scores
3. Click the delete button
4. Confirm deletion

Note: This will delete all trust score data. Make sure to back up any important data before deleting.
