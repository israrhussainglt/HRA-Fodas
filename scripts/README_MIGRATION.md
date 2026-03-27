# Schema Migration Scripts

This directory contains scripts for migrating the Appwrite database schema to fix mismatches between Flutter models and the database.

## Overview

The migration addresses two main issues:

1. **NGO Requests Food Category**: Migrates the `food_category` enum from camelCase ('freshProduce') to snake_case ('fresh_produce') to match the donations table format.

2. **Deliveries Recipient ID**: Updates the `recipient_id` default value from empty string to null.

## Prerequisites

- Dart SDK installed
- Appwrite SDK dependencies (automatically handled by pubspec.yaml)
- Valid `.env` file with Appwrite credentials

## Usage

### Basic Usage

Run all migrations:
```bash
dart scripts/schema_migration.dart
```

### Dry Run (Recommended First)

Test the migration without making changes:
```bash
dart scripts/schema_migration.dart --dry-run --verbose
```

### Run Specific Migration

Migrate only NGO requests:
```bash
dart scripts/schema_migration.dart --operation ngo-requests
```

Migrate only deliveries:
```bash
dart scripts/schema_migration.dart --operation deliveries
```

Run validation only:
```bash
dart scripts/schema_migration.dart --operation validate
```

### Advanced Options

Custom backup path:
```bash
dart scripts/schema_migration.dart --backup-path ./my-backups
```

Skip backup creation (not recommended):
```bash
dart scripts/schema_migration.dart --no-backup
```

Adjust batch size for large datasets:
```bash
dart scripts/schema_migration.dart --batch-size 50
```

Enable verbose logging:
```bash
dart scripts/schema_migration.dart --verbose
```

## Command-Line Options

| Option | Short | Description | Default |
|--------|-------|-------------|---------|
| `--dry-run` | `-d` | Run without making changes | false |
| `--no-backup` | | Skip creating backups | false (backups enabled) |
| `--verbose` | `-v` | Enable detailed logging | false |
| `--backup-path` | | Custom backup directory | `backups/` |
| `--batch-size` | | Documents per batch | 100 |
| `--operation` | `-o` | Specific operation to run | `all` |
| `--help` | `-h` | Show help message | |

## Operations

- `all` - Run all migrations and validation (default)
- `ngo-requests` - Migrate NGO requests food category only
- `deliveries` - Migrate deliveries recipient_id only
- `validate` - Run validation checks only

## Migration Process

### 1. Pre-Migration

Before running the migration:

1. **Backup your data** - The script creates automatic backups, but consider manual backups too
2. **Test with dry-run** - Always run with `--dry-run` first to see what will change
3. **Review the output** - Check the dry-run results for any unexpected changes

### 2. Running Migration

Recommended steps:

```bash
# Step 1: Dry run with verbose output
dart scripts/schema_migration.dart --dry-run --verbose

# Step 2: Review the output and backups

# Step 3: Run the actual migration
dart scripts/schema_migration.dart --verbose

# Step 4: Validate the results
dart scripts/schema_migration.dart --operation validate
```

### 3. Post-Migration

After migration:

1. **Check validation results** - Ensure all checks pass
2. **Test the application** - Verify the Flutter app works correctly
3. **Keep backups** - Store backups in a safe location for rollback if needed

## Backup Files

Backups are created in JSON format with timestamps:

```
backups/
  ngo_requests_food_category_2024-01-15T10-30-00.json
  deliveries_recipient_id_2024-01-15T10-30-05.json
```

Each backup file contains:
- Collection ID
- Timestamp
- Document count
- All document data

## Validation

The validation checks:

1. **NGO Requests Food Category**
   - All records have valid snake_case food categories
   - Valid values: `fresh_produce`, `dairy`, `meat`, `bakery`, `canned`, `prepared`, `other`

2. **Deliveries Recipient ID**
   - No records have empty string recipient_id
   - All values are either null or non-empty strings

## Troubleshooting

### Missing Environment Variables

Error: `Missing required environment variables`

Solution: Ensure your `.env` file contains:
```
APPWRITE_ENDPOINT=https://your-endpoint/v1
APPWRITE_PROJECT_ID=your-project-id
APPWRITE_API_KEY=your-api-key
APPWRITE_DATABASE_ID=your-database-id
```

### Permission Errors

Error: `Permission denied` or `Unauthorized`

Solution: Ensure your API key has the following permissions:
- `databases.read`
- `databases.write`
- `collections.read`
- `collections.write`
- `documents.read`
- `documents.write`

### Network Errors

Error: `Connection timeout` or `Network error`

Solution:
- Check your internet connection
- Verify the Appwrite endpoint is accessible
- Try reducing batch size: `--batch-size 50`

### Validation Failures

If validation fails after migration:

1. Review the validation details in the output
2. Check the specific records mentioned in the error
3. Run the migration again if needed
4. Contact support if issues persist

## Rollback

If you need to rollback the migration:

1. Locate the backup file in the `backups/` directory
2. Use the Appwrite console or API to restore the data
3. Manually update records using the backup JSON data

## Support

For issues or questions:
- Review the design document: `.kiro/specs/schema-alignment-fix/design.md`
- Check the requirements: `.kiro/specs/schema-alignment-fix/requirements.md`
- Review the implementation tasks: `.kiro/specs/schema-alignment-fix/tasks.md`
