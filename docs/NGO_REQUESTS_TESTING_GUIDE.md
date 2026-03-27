# NGO Requests Feature - Testing Guide

## Overview
The NGO Requests feature is now fully implemented and ready for testing. This feature allows NGOs to submit food requests, and admins can approve or deny them from the admin dashboard.

## What Was Implemented

### 1. Database Table
- **Table Name**: `ngo_requests`
- **Database ID**: `hra_fodas_main`
- **Status**: ✅ Created and configured

#### Columns:
- `ngo_id` (string, required) - ID of the NGO making the request
- `ngo_name` (string, required) - Name of the NGO
- `title` (string, required) - Request title
- `description` (string, required) - Detailed description
- `food_category` (string, required) - Category of food requested
- `quantity` (integer, required) - Amount requested
- `unit` (string, required) - Unit of measurement (kg, liters, etc.)
- `delivery_address` (string, required) - Delivery location
- `needed_by` (datetime, required) - Deadline for the request
- `status` (string, required) - Current status (pending, approved, denied, converted, cancelled)
- `reviewed_by` (string, optional) - Admin ID who reviewed
- `reviewed_at` (datetime, optional) - When it was reviewed
- `denial_reason` (string, optional) - Reason if denied
- `converted_donation_id` (string, optional) - Donation ID if converted
- `created_at` (datetime, optional) - Creation timestamp
- `updated_at` (datetime, optional) - Last update timestamp

#### Indexes:
- `ngo_id_idx` - For filtering by NGO
- `status_idx` - For filtering by status
- `created_at_idx` - For sorting by creation date (DESC)

### 2. Admin Dashboard Integration
- **Location**: Admin Dashboard → Overview Tab
- **Features**:
  - Alert card showing pending NGO requests count
  - Quick action chip to navigate to NGO requests screen
  - Real-time updates when new requests arrive

### 3. NGO Requests Screen
- **Route**: `/admin/ngo-requests`
- **Location**: `lib/ui/screens/admin/ngo_requests_screen.dart`
- **Features**:
  - View all NGO requests
  - Filter by status (All, Pending, Approved, Denied, Converted)
  - Real-time updates via Appwrite Realtime
  - Approve requests with one click
  - Deny requests with reason input
  - View request details (food category, quantity, delivery address, deadline)
  - View review history for processed requests

### 4. Notification System
- **Implemented in**: `lib/data/repositories/ngo_request_repository.dart`
- **Notifications sent**:
  - When NGO submits a request → All admins notified
  - When admin approves a request → NGO notified + Other admins notified
  - When admin denies a request → NGO notified + Other admins notified

### 5. Providers
- **Location**: `lib/providers/admin_providers.dart`
- **Providers**:
  - `ngoRequestRepositoryProvider` - Repository with notification support
  - `ngoRequestsProvider` - Get all requests
  - `pendingNGORequestsProvider` - Get pending requests only
  - `ngoRequestProvider(id)` - Get single request by ID

## Test Data Created

Two test NGO requests have been created for testing:

### Request 1: Test NGO Foundation
- **Title**: Urgent Food Request for Community Center
- **Description**: Food supplies for 50 families
- **Category**: Vegetables
- **Quantity**: 100 kg
- **Delivery**: 123 Community Center St, Test City
- **Needed By**: Feb 15, 2026
- **Status**: Pending

### Request 2: Hope Shelter Organization
- **Title**: Protein Food Request for Shelter
- **Description**: Protein-rich food for 30 residents
- **Category**: Dairy
- **Quantity**: 50 kg
- **Delivery**: 456 Shelter Road, Hope District
- **Needed By**: Feb 10, 2026
- **Status**: Pending

## How to Test

### Step 1: Login as Admin
1. Open the app
2. Login with admin credentials:
   - Email: `admin@gmail.com`
   - Password: `Admin@2026!!`

### Step 2: View NGO Requests from Dashboard
1. Navigate to Admin Dashboard
2. You should see an orange alert card showing "2 Pending NGO Requests"
3. Tap on the alert card OR tap the "NGO Requests" chip below

### Step 3: View NGO Requests Screen
1. You should see 2 pending requests listed
2. Each card shows:
   - Request title and NGO name
   - Status badge (orange for pending)
   - Description
   - Food category and quantity
   - Delivery address
   - Needed by date
   - Created date
   - Approve and Deny buttons

### Step 4: Test Filtering
1. Tap on filter chips at the top:
   - "All" - Shows all requests
   - "Pending" - Shows only pending requests
   - "Approved" - Shows approved requests (empty for now)
   - "Denied" - Shows denied requests (empty for now)
   - "Converted" - Shows converted requests (empty for now)

### Step 5: Test Approval
1. Tap "Approve" button on any request
2. You should see a success message
3. The request card should update to show:
   - Status badge changes to green "Approved"
   - Approve/Deny buttons disappear
   - Review info appears showing admin and timestamp
4. The pending count on dashboard should decrease

### Step 6: Test Denial
1. Tap "Deny" button on any request
2. A dialog appears asking for denial reason
3. Enter a reason (e.g., "Insufficient resources")
4. Tap "Deny" button in dialog
5. You should see a success message
6. The request card should update to show:
   - Status badge changes to red "Denied"
   - Approve/Deny buttons disappear
   - Review info appears with denial reason

### Step 7: Test Real-time Updates
1. Open the app on two devices (or use web + mobile)
2. Login as admin on both
3. Navigate to NGO Requests screen on both
4. Approve/deny a request on one device
5. The other device should update automatically (within 1-2 seconds)

### Step 8: Test Notifications
1. After approving/denying a request, check notifications
2. Navigate to Notifications screen
3. You should see notifications about the request actions
4. (Note: NGO notifications will be sent to the NGO user, not visible to admin)

## Expected Behavior

### ✅ What Should Work:
- View all NGO requests
- Filter requests by status
- Approve requests
- Deny requests with reason
- Real-time updates across devices
- Notifications to admins and NGOs
- Dashboard alert showing pending count
- Navigation from dashboard to requests screen

### ⚠️ Known Limitations:
1. **No NGO Request Creation UI**: Currently, NGO requests must be created programmatically or via API. A future update should add a UI for NGOs to submit requests.
2. **Quantity is Integer**: The database stores quantity as integer, not float. This means decimal quantities (e.g., 2.5 kg) will be rounded.
3. **No Metadata Column**: The optional metadata column couldn't be added due to column limit. This doesn't affect core functionality.

## Troubleshooting

### Issue: "Table not found" error
**Solution**: The table exists. Try refreshing the app or restarting.

### Issue: Requests not showing
**Solution**: 
1. Check if you're logged in as admin
2. Verify test data exists by checking Appwrite console
3. Try pulling down to refresh the list

### Issue: Real-time updates not working
**Solution**:
1. Check internet connection
2. Verify Appwrite Realtime is enabled in project settings
3. Restart the app

### Issue: Notifications not appearing
**Solution**:
1. Check notification permissions
2. Verify notification repository is properly initialized
3. Check Appwrite console for notification records

## Next Steps

### Recommended Enhancements:
1. **NGO Request Creation UI**: Add a screen for NGOs to submit requests from the app
2. **Request Editing**: Allow NGOs to edit pending requests
3. **Request Cancellation**: Allow NGOs to cancel their own requests
4. **Bulk Actions**: Allow admins to approve/deny multiple requests at once
5. **Request History**: Show history of all actions on a request
6. **Email Notifications**: Send email notifications in addition to in-app notifications
7. **Request Templates**: Allow NGOs to save and reuse request templates
8. **Attachment Support**: Allow NGOs to attach documents to requests

## Files Modified/Created

### Created:
- `lib/ui/screens/admin/ngo_requests_screen.dart` - Main NGO requests screen
- `docs/NGO_REQUESTS_FEATURE.md` - Feature documentation
- `docs/NGO_REQUESTS_TESTING_GUIDE.md` - This file

### Modified:
- `lib/ui/screens/admin/admin_dashboard.dart` - Added NGO requests alert and navigation
- `lib/providers/admin_providers.dart` - Added NGO request providers
- `lib/router/app_router.dart` - Added NGO requests route

### Existing (Used):
- `lib/data/models/ngo_request.dart` - NGO request model
- `lib/data/repositories/ngo_request_repository.dart` - Repository with notification logic

## Database State

```
Database: hra_fodas_main
Table: ngo_requests
Rows: 2 (test data)
Status: ✅ Fully configured and operational
```

## Conclusion

The NGO Requests feature is fully implemented and ready for testing. The system includes:
- ✅ Database table with all required columns and indexes
- ✅ Admin UI for viewing and managing requests
- ✅ Real-time updates
- ✅ Notification system
- ✅ Test data for immediate testing

You can now test the feature by logging in as admin and navigating to the NGO Requests screen from the admin dashboard.
