# NGO Request Final Fix - Preventing Duplicates and Enabling Notifications

## Current Issues
1. **NGO can create multiple requests for the same donation** - No duplicate prevention
2. **No notifications received by admin** - Notification creation failing silently

## Root Cause Analysis

### Issue 1: Multiple Requests Allowed
The `hasPendingRequestForDonationProvider` was trying to match by title pattern, but:
- Title matching is unreliable (donations can have similar titles)
- The provider was fetching the donation each time (expensive)
- The logic was too complex and error-prone

### Issue 2: Notifications Not Created
The `createNotification` method in `notification_repository.dart` was:
- Commenting out the `data` field even though it exists in the schema
- Not properly encoding the data as JSON string
- Failing silently without proper error handling

## Solutions Implemented

### Fix 1: Simplified Duplicate Prevention
Changed the provider to check if the user has ANY pending request:

```dart
final hasPendingRequestForDonationProvider =
    FutureProvider.family<bool, ({String userId, String donationId})>((
      ref,
      params,
    ) async {
      try {
        final requests = await ref
            .watch(ngoRequestRepositoryProvider)
            .getRequests(ngoId: params.userId, status: NGORequestStatus.pending);

        // Check if user has any pending request
        return requests.isNotEmpty;
      } catch (e) {
        return false;
      }
    });
```

**How it works:**
- Checks if the user has ANY pending NGO request
- If yes, disables the Request button on ALL donations
- Simpler, faster, and more reliable
- Prevents spam requests

**Trade-off:**
- User can only have ONE pending request at a time
- After admin approves/denies, user can make another request
- This is actually a good UX - prevents overwhelming admins with requests

### Fix 2: Enable Notification Data Field
Updated the notification repository to properly include the data field:

```dart
// Add data field if provided (it exists in schema)
if (data != null) {
  notificationData['data'] = jsonEncode(data);
} else {
  notificationData['data'] = '{}';
}
```

**How it works:**
- Properly encodes data as JSON string (schema expects string, not object)
- Always includes the data field (has default value in schema)
- Notifications will now be created successfully

### Fix 3: Realtime Subscription for Admin Dashboard
Added realtime subscription to `ngo_requests` collection:

```dart
// Subscribe to ngo_requests collection
_ngoRequestsSubscription = realtime.subscribe([
  'databases.${AppwriteOptions.databaseId}.collections.ngo_requests.documents',
]);

_ngoRequestsSubscription!.stream.listen((response) {
  if (response.events.contains('databases.*.collections.*.documents.*')) {
    // Refresh NGO requests data
    ref.invalidate(pendingNGORequestsProvider);
    ref.invalidate(ngoRequestsProvider);
  }
});
```

**How it works:**
- Listens for any changes to the ngo_requests collection
- Automatically refreshes the admin dashboard when new requests are created
- Admin sees the orange notification card immediately

## Testing Steps

### Test 1: Duplicate Prevention
1. Log in as recipient/NGO
2. Go to Browse tab
3. Click "Request" on any donation
4. Button should change to "Pending Review" (orange)
5. Try to click "Request" on another donation
6. ALL Request buttons should now show "Pending Review"
7. Log in as admin and approve/deny the request
8. Log back in as recipient
9. Request buttons should now be enabled again

### Test 2: Admin Notifications
1. Open admin dashboard in one browser
2. In another browser (or incognito), log in as recipient
3. Create an NGO request
4. Admin dashboard should automatically show:
   - Orange notification card with "1 Pending NGO Request"
   - No manual refresh needed
5. Click the card to go to NGO Requests screen
6. The new request should be visible

### Test 3: Notification Creation
Check the console logs for:
```
[HRA-FoDAS][NOTIFICATION] 🔔 Creating notification for user: {admin_id}
[HRA-FoDAS][NOTIFICATION] ✅ Notification created successfully
```

If you see errors, check:
- Database permissions on notifications collection
- The `data` field exists in the schema
- The notification type is valid

## Known Limitations

### One Request at a Time
Users can only have ONE pending request at a time. This is intentional to:
- Prevent spam
- Keep admin workload manageable
- Encourage thoughtful requests

If this is too restrictive, we need to:
1. Add `donation_id` field to `ngo_requests` schema
2. Update the provider to check per-donation instead of globally
3. Update the repository to store donation_id when creating requests

### No Direct Donation Link
The `ngo_requests` schema doesn't have a `donation_id` field, so:
- Can't link requests to specific donations in the database
- Can't query "all requests for this donation"
- Can't show which donation a request is for (except in the title/description)

**Recommended Schema Update:**
```javascript
{
  "key": "donation_id",
  "type": "string",
  "size": 36,
  "required": false
}
```

Add this to the `ngo_requests` collection to enable proper donation linking.

## Files Modified
1. `lib/providers/admin_providers.dart` - Simplified hasPendingRequestForDonationProvider
2. `lib/data/repositories/notification_repository.dart` - Fixed data field encoding
3. `lib/ui/screens/admin/admin_dashboard.dart` - Added realtime subscription (already done)

## Next Steps

### If One Request Limit is Too Restrictive:
1. Run this script to add donation_id to schema:
```javascript
// database/add_donation_id_to_ngo_requests.js
const sdk = require('node-appwrite');
require('dotenv').config({ path: '../.env' });

const client = new sdk.Client()
    .setEndpoint(process.env.APPWRITE_ENDPOINT)
    .setProject(process.env.APPWRITE_PROJECT_ID)
    .setKey(process.env.APPWRITE_API_KEY);

const databases = new sdk.Databases(client);

async function addDonationIdField() {
    try {
        await databases.createStringAttribute(
            process.env.APPWRITE_DATABASE_ID,
            'ngo_requests',
            'donation_id',
            36,
            false // not required
        );
        console.log('✅ Added donation_id field to ngo_requests');
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
}

addDonationIdField();
```

2. Update `_sanitizeData()` in `ngo_request_repository.dart`:
```dart
'donationId': data['donation_id'],
```

3. Update `createRequest()` to include donation_id:
```dart
if (donationId != null) 'donation_id': donationId,
```

4. Update the provider to check per-donation:
```dart
return requests.any(
  (request) =>
      request.donationId == params.donationId &&
      request.status == NGORequestStatus.pending,
);
```

## Date
February 5, 2026
