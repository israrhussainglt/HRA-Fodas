# NGO Request Complete Fix

## Date: February 5, 2026

## Problem Summary
The NGO request feature had two critical issues:
1. **Button State Issue**: The "Request" button wasn't changing to "Pending Review" after submitting a request
2. **Notification Issue**: Admin dashboard wasn't receiving notifications when NGOs submitted requests

## Root Causes

### 1. Button State Issue
The `hasPendingRequestForDonationProvider` was checking if the user had ANY pending request, not if they had a pending request for the SPECIFIC donation. This was because:
- The `donation_id` field was missing from the `ngo_requests` schema
- The provider was using a global check instead of a donation-specific check

### 2. Notification Issue
Notifications weren't being created properly because:
- The `data` field in notifications needed to be JSON-encoded
- The admin dashboard needed realtime subscription to the `ngo_requests` collection

## Solutions Implemented

### Phase 1: Add donation_id to Schema (COMPLETED)
**File**: `database/add_donation_id_to_ngo_requests.js`
- Created script to add `donation_id` attribute to `ngo_requests` collection
- Made it optional (not required) to support existing requests
- Successfully ran: `node database/add_donation_id_to_ngo_requests.js`

### Phase 2: Update Repository to Store donation_id (COMPLETED)
**File**: `lib/data/repositories/ngo_request_repository.dart`

**In createRequest():**
```dart
if (donationId != null) 'donation_id': donationId, // Now in schema!
```

**In _sanitizeData():**
```dart
'donationId': data['donation_id'], // Now in schema!
```

### Phase 3: Fix Notification Creation (COMPLETED)
**File**: `lib/data/repositories/notification_repository.dart`

**Fixed data field encoding:**
```dart
// Add data field if provided (it exists in schema)
if (data != null) {
  notificationData['data'] = jsonEncode(data);
} else {
  notificationData['data'] = '{}';
}
```

### Phase 4: Add Realtime Subscription (COMPLETED)
**File**: `lib/ui/screens/admin/admin_dashboard.dart`

**Added subscription in _setupRealtimeSubscriptions():**
```dart
// Subscribe to ngo_requests collection
_ngoRequestsSubscription = realtime.subscribe([
  'databases.${AppwriteOptions.databaseId}.collectio