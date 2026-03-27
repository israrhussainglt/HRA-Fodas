# SQL to Appwrite Schema Mapping

This document explains how the PostgreSQL/Supabase schema (`database.sql`) maps to the Appwrite schema (`appwrite_schema.json`).

## Key Differences

| PostgreSQL/Supabase | Appwrite | Notes |
|---------------------|----------|-------|
| `uuid` with `uuid_generate_v4()` | Auto-generated `$id` | Appwrite generates unique IDs automatically |
| `timestamp with time zone` | `datetime` attribute | Stored in ISO 8601 format |
| `jsonb` | `string` attribute | JSON stored as string, parsed in app |
| `ARRAY` | `string` attribute | Arrays stored as JSON strings |
| Foreign key constraints | String references | No enforced relationships |
| `created_at` / `updated_at` | `$createdAt` / `$updatedAt` | Auto-managed by Appwrite |
| Custom enums | `enum` attribute | Defined inline in schema |
| `numeric` / `decimal` | `double` attribute | Floating point numbers |
| `text` (unlimited) | `string` with size | Must specify max size |

## Collection Mappings

### user_profiles
```sql
-- SQL
id uuid REFERENCES auth.users(id)
preferences jsonb DEFAULT '{}'::jsonb

-- Appwrite
id: auto-generated $id (string)
preferences: string (size: 10000, default: "{}")
```

### donations
```sql
-- SQL
food_category USER-DEFINED (enum)
images jsonb DEFAULT '[]'::jsonb
status USER-DEFINED DEFAULT 'pending'::donation_status

-- Appwrite
food_category: enum ["fruits", "vegetables", "grains", ...]
images: string (size: 5000, default: "[]")
status: enum ["pending", "assigned", "picked_up", ...]
```

### deliveries
```sql
-- SQL
status USER-DEFINED DEFAULT 'assigned'::delivery_status
route_data jsonb

-- Appwrite
status: enum ["assigned", "accepted", "picked_up", ...]
route_data: string (size: 10000)
```

### conversations
```sql
-- SQL
participant_ids ARRAY

-- Appwrite
participant_ids: string (size: 500)
-- Stored as JSON array string: '["user1", "user2"]'
```

### fcm_tokens
```sql
-- SQL
device_type text CHECK (device_type = ANY (ARRAY['android', 'ios', 'web']))
device_info jsonb

-- Appwrite
device_type: enum ["android", "ios", "web"]
device_info: string (size: 2000)
```

### notification_preferences
```sql
-- SQL
user_id uuid NOT NULL UNIQUE

-- Appwrite
user_id: string (size: 36, required: true)
-- Index with unique: true
```

### scheduled_notifications
```sql
-- SQL
status text DEFAULT 'pending' CHECK (status = ANY (ARRAY['pending', 'sent', 'failed', 'cancelled']))
data jsonb

-- Appwrite
status: enum ["pending", "sent", "failed", "cancelled"]
data: string (size: 5000)
```

### inventory
```sql
-- SQL
food_category USER-DEFINED NOT NULL
quantity numeric NOT NULL

-- Appwrite
food_category: string (size: 100, required: true)
quantity: double (required: true)
```

### daily_statistics
```sql
-- SQL
date date NOT NULL UNIQUE
total_weight_kg numeric DEFAULT 0

-- Appwrite
date: datetime (required: true)
-- Index with unique: true
total_weight_kg: double (default: 0)
```

## Handling Relationships

### SQL Foreign Keys
```sql
-- SQL
donor_id uuid NOT NULL,
CONSTRAINT donations_donor_id_fkey 
  FOREIGN KEY (donor_id) 
  REFERENCES public.user_profiles(id)
```

### Appwrite References
```javascript
// Appwrite - No constraints, handled in application code
{
  key: "donor_id",
  type: "string",
  size: 36,
  required: true
}

// In your Dart code:
final donor = await databases.getRow(
  databaseId: databaseId,
  tableId: 'user_profiles',
  rowId: donation.donor_id
);
```

## Handling JSON Fields

### SQL JSONB
```sql
-- SQL
preferences jsonb DEFAULT '{}'::jsonb
images jsonb DEFAULT '[]'::jsonb
```

### Appwrite String + JSON Parsing
```javascript
// Appwrite Schema
{
  key: "preferences",
  type: "string",
  size: 10000,
  default: "{}"
}

// In Dart code:
// Writing
final prefsJson = jsonEncode(preferences);
await databases.createRow(..., data: {'preferences': prefsJson});

// Reading
final row = await databases.getRow(...);
final prefs = jsonDecode(row.data['preferences']);
```

## Handling Arrays

### SQL Arrays
```sql
-- SQL
participant_ids ARRAY NOT NULL
```

### Appwrite String Arrays
```javascript
// Appwrite Schema
{
  key: "participant_ids",
  type: "string",
  size: 500,
  required: true
}

// In Dart code:
// Writing
final idsJson = jsonEncode(['user1', 'user2', 'user3']);
await databases.createRow(..., data: {'participant_ids': idsJson});

// Reading
final row = await databases.getRow(...);
final ids = List<String>.from(jsonDecode(row.data['participant_ids']));
```

## Handling Enums

### SQL Custom Enums
```sql
-- SQL
CREATE TYPE user_role AS ENUM ('donor', 'volunteer', 'recipient', 'admin');
role user_role NOT NULL DEFAULT 'donor'::user_role
```

### Appwrite Enum Attributes
```javascript
// Appwrite Schema
{
  key: "role",
  type: "enum",
  elements: ["donor", "volunteer", "recipient", "admin"],
  required: true,
  default: "donor"
}
```

## Indexes

### SQL Indexes
```sql
-- SQL
CREATE INDEX idx_donations_donor ON donations(donor_id);
CREATE INDEX idx_donations_status ON donations(status);
```

### Appwrite Indexes
```javascript
// Appwrite Schema
{
  indexes: [
    {
      key: "donor_idx",
      type: "key",
      attributes: ["donor_id"]
    },
    {
      key: "status_idx",
      type: "key",
      attributes: ["status"]
    }
  ]
}
```

## Permissions

### SQL Row Level Security (RLS)
```sql
-- SQL
ALTER TABLE donations ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view their own donations"
  ON donations FOR SELECT
  USING (auth.uid() = donor_id);
```

### Appwrite Permissions
```javascript
// Appwrite - Set on collection or document level
{
  permissions: [
    Permission.read(Role.any()),
    Permission.create(Role.users()),
    Permission.update(Role.users()),
    Permission.delete(Role.users())
  ]
}

// Or per-document in Dart:
await databases.createRow(
  ...,
  permissions: [
    Permission.read(Role.user(userId)),
    Permission.update(Role.user(userId)),
    Permission.delete(Role.user(userId))
  ]
);
```

## Queries

### SQL Queries
```sql
-- SQL
SELECT * FROM donations 
WHERE status = 'pending' 
  AND donor_id = $1 
ORDER BY created_at DESC 
LIMIT 10;
```

### Appwrite Queries
```dart
// Dart with Appwrite
final response = await databases.listRows(
  databaseId: databaseId,
  tableId: 'donations',
  queries: [
    Query.equal('status', 'pending'),
    Query.equal('donor_id', userId),
    Query.orderDesc('\$createdAt'),
    Query.limit(10)
  ]
);
```

## Migration Considerations

1. **Data Loss Risk**: Appwrite doesn't support schema migrations with data preservation. Plan carefully.

2. **No Transactions**: Appwrite doesn't support multi-document transactions. Handle in application logic.

3. **No Joins**: Must fetch related data separately and join in application code.

4. **Size Limits**: String attributes have size limits. Plan for maximum expected data size.

5. **No Computed Fields**: Calculate derived values in application code or use Cloud Functions.

6. **Realtime**: Appwrite has built-in realtime subscriptions - easier than Supabase in some ways!

## Best Practices

1. **JSON Fields**: Keep JSON strings under 10KB for performance
2. **Indexes**: Index all foreign key fields and frequently queried fields
3. **Enums**: Use enums instead of strings for fixed value sets
4. **Validation**: Validate data in application code since Appwrite has limited constraints
5. **Relationships**: Document relationships in code comments since they're not enforced
6. **Permissions**: Set appropriate permissions at collection and document level
7. **Backups**: Regular backups are critical since schema changes can cause data loss
