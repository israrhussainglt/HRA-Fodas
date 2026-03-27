# NGO Request Button and Notification Fix

## Issues
1. **Button doesn't change from "Request" to "Requested"** after creating an NGO request
2. **No notification appears in admin dashboard** when a new NGO request is created

## Root Causes

### Issue 1: Button State Not Updating
The `hasPendingRequestForDonationProvider` was checking for `request.donationId == params.donationId`, but:
- The `ngo_requests` schema doesn't have a `donation_id` field
- The `_sanitizeData()` method was setting `donationId` to `null` for all requests
- Therefore, the provider could never find a matching request

### Issue 2: No Notification in Admin Dashboard
The admin dashboard had no realtime subscription for the `ngo_requests` collection, so:
- When a new NGO request was created, the dashboard didn't refresh
- The pending requests count didn't update
- Admins had to manually refresh the page to see new requests

## Solutions

### Fix 1: Update hasPendingRequestForDonationProvider
Changed the provider to match requests by title pattern instead of donation_id:

```dart
final hasPendingRequestForDonationProvider =
    FutureProvider.family<bool, ({String userId, String donationId})>((
      ref,
      params,
    ) async {
      try {
        // Get the donation to match by title
        final donation = await ref
            .watch(donationRepositoryProvider)
            .getDonationById(params.donationId);

        // Get all requests for this user
        final requests = await ref
            .watch(ngoRequestRepositoryProvider)
            .getRequests(ngoId: params.userId);

        // Check if any request matches this donation by title pattern
        return requests.any(
          (request) =>
              request.title == 'Request for: ${donation.title}' &&
              request.status == NGORequestStatus.pending,
        );
      } catch (e) {
        return false;
      }
    });
```

**How it works:**
1. Fetches the donation by ID to get its title
2. Gets all NGO requests for the current user
3. Checks if any request has the title pattern "Request for: {donation.title}"
4. Returns true if a matching pending request is found

**Note:** This relies on the title pattern created in `_requestDonation()`:
```dart
title: 'Request for: ${widget.donation.title}'
```

### Fix 2: Add Realtime Subscription for NGO Requests
Added realtime subscription to the admin dashboard:

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
1. Subscribes to all document events in the `ngo_requests` collection
2. When a new request is created, updated, or deleted, the subscription fires
3. Invalidates the providers to force a refetch
4. The admin dashboard automatically updates with the new data

## Testing

### Test Button State Change:
1. Log in as a recipient/NGO
2. Go to Browse tab
3. Click "Request" on a donation
4. Button should change to "Pending Review" (orange color)
5. Refresh the page - button should still show "Pending Review"

### Test Admin Notification:
1. Keep admin dashboard open
2. In another browser/incognito window, log in as recipient
3. Create an NGO request
4. Admin dashboard should automatically show the pending request card
5. The orange notification card should appear without manual refresh

## Limitations

### No Direct Donation Link
Since the schema doesn't have a `donation_id` field, we can't:
- Directly link an NGO request to a specific donation in the database
- Query requests by donation ID efficiently
- Show which donation a request is for (except through the title)

### Workaround Used
We match requests by title pattern, which works but has limitations:
- If two donations have the same title, the matching might be ambiguous
- The title pattern must remain consistent ("Request for: {title}")
- Changing the title pattern in the future would break existing logic

### Recommended Schema Update
Add a `donation_id` field to the `ngo_requests` collection:
```javascript
{
  "key": "donation_id",
  "type": "string",
  "size": 36,
  "required": false
}
```

This would allow:
- Direct linking between requests and donations
- More efficient queries
- Better data integrity
- Simpler provider logic

## Related Files
- `lib/providers/admin_providers.dart` - Updated hasPendingRequestForDonationProvider
- `lib/ui/screens/admin/admin_dashboard.dart` - Added realtime subscription
- `lib/ui/widgets/donation_card.dart` - Uses the provider to show button state
- `lib/data/repositories/ngo_request_repository.dart` - Creates requests with title pattern

## Date
February 5, 2026
