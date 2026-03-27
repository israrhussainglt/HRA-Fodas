# NGO Requests Schema Fix

## Issue
The NGO request creation was failing with error:
```
Failed to create request: Invalid document structure: Missing required attribute "food_categories"
```

## Root Cause
There was a mismatch between the code and the Appwrite schema for the `ngo_requests` collection:

### Code Expected vs Schema Had:
| Code Field | Schema Field | Notes |
|------------|--------------|-------|
| `food_category` | `food_categories` | Singular vs plural |
| `quantity` | `quantity_needed` | Different field name |
| `delivery_address` | ❌ Not in schema | Missing field |
| `status: pending` | `status: open` | Different enum value |
| `reviewed_by` | ❌ Not in schema | Missing field |
| `reviewed_at` | ❌ Not in schema | Missing field |
| `denial_reason` | ❌ Not in schema | Missing field |
| `donation_id` | ❌ Not in schema | Missing field |
| `metadata` | ❌ Not in schema | Missing field |

### Schema Has (but code didn't use):
- `urgency` (required): enum ["low", "medium", "high", "critical"]
- `fulfilled_quantity` (required): double with default 0
- `status` enum: ["open", "partially_fulfilled", "fulfilled", "cancelled", "expired"]

## Solution

### 1. Updated `createRequest()` method
Changed field names to match schema:
```dart
data: {
  'recipient_id': ngoId,
  'title': title,
  'description': description,
  'food_categories': foodCategory.name,  // Changed from food_category
  'quantity_needed': quantity,            // Changed from quantity
  'unit': unit,
  'urgency': 'medium',                    // Added required field
  'needed_by': neededBy.toIso8601String(),
  'status': 'open',                       // Changed from 'pending'
  'fulfilled_quantity': 0,                // Added required field
}
```

### 2. Updated Status Mapping
Mapped app statuses to schema statuses:
- `pending` → `open`
- `approved` → `fulfilled`
- `denied` → `cancelled`
- `converted` → `fulfilled`
- `cancelled` → `cancelled`

### 3. Updated `_sanitizeData()` method
Added proper mapping from schema fields back to app model:
```dart
'foodCategory': data['food_categories'] ?? 'other',
'quantity': data['quantity_needed'] ?? 0,
'status': appStatus,  // Mapped from schema status
```

### 4. Fixed Query Methods
Updated status queries to use schema enum values instead of app enum values.

## Fields Not in Schema
The following fields from the model are not in the schema and return empty/null values:
- `ngoName` - Returns empty string (should be fetched from user_profiles)
- `deliveryAddress` - Returns empty string
- `donationId` - Returns null
- `denialReason` - Returns null
- `reviewedBy` - Returns null
- `reviewedAt` - Returns null
- `convertedDonationId` - Returns null
- `metadata` - Returns null

## Recommendations

### Option 1: Expand Schema (Recommended)
Add missing fields to the schema to support full functionality:
```javascript
{
  "key": "reviewed_by",
  "type": "string",
  "size": 36,
  "required": false
},
{
  "key": "reviewed_at",
  "type": "datetime",
  "required": false
},
{
  "key": "denial_reason",
  "type": "string",
  "size": 1000,
  "required": false
},
{
  "key": "donation_id",
  "type": "string",
  "size": 36,
  "required": false
},
{
  "key": "delivery_address",
  "type": "string",
  "size": 500,
  "required": false
}
```

### Option 2: Simplify Model
Update the `NGORequest` model to only include fields that exist in the schema.

### Option 3: Keep Current Workaround
Continue using empty/null values for missing fields. This works but limits functionality.

## Testing
After this fix, NGO requests can be created successfully. Test:
1. Create a new NGO request from recipient dashboard
2. Verify it appears in admin dashboard
3. Test approve/deny functionality
4. Check that status updates correctly

## Related Files
- `lib/data/repositories/ngo_request_repository.dart` - Fixed
- `lib/data/models/ngo_request.dart` - Model definition
- `database/appwrite_schema.json` - Schema definition
- `lib/ui/screens/admin/reports_screen.dart` - Fixed deprecated withOpacity

## Date
February 5, 2026
