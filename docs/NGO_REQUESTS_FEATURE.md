# NGO Request Feature

## Overview
The NGO Request feature allows recipient organizations (NGOs) to request specific donations. When an NGO clicks the "Request" button on a donation card, it creates a request that goes to the admin for approval. Once approved, the recipient is assigned to the donation and volunteers are notified.

## User Flow

### 1. NGO Requests a Donation
- NGO browses available donations in their dashboard
- NGO clicks the "Request" button on a donation card
- System creates an NGO request with:
  - Link to the specific donation (`donation_id`)
  - NGO details (ID, name, delivery address)
  - Donation details (title, description, category, quantity)
  - Needed by date (donation expiration date)
- Request status is set to "pending"
- All admins receive a notification about the new request

### 2. Admin Reviews Request
- Admin sees pending requests in the Admin Dashboard (alert card)
- Admin navigates to NGO Requests screen
- Admin can view request details including:
  - NGO name and delivery address
  - Requested food category and quantity
  - Needed by date
  - Request submission date
- Admin can either:
  - **Approve**: Assigns the NGO as recipient to the donation
  - **Deny**: Rejects the request with a reason

### 3. Request Approval
When admin approves a request:
- Request status changes to "approved"
- NGO is automatically assigned as recipient to the linked donation
- NGO receives notification about approval
- If a volunteer is already assigned to the donation:
  - Volunteer receives notification with recipient details
  - Volunteer can see delivery address and recipient name
- If no volunteer is assigned yet:
  - Volunteer will be notified when they accept the delivery
- Other admins receive notification about the approval

### 4. Request Denial
When admin denies a request:
- Request status changes to "denied"
- Denial reason is recorded
- NGO receives notification with denial reason
- Other admins receive notification about the denial
- Donation remains available for other NGOs to request

## Database Schema

### ngo_requests Table
```
- id (string, primary key)
- ngo_id (string, required) - User ID of the NGO
- ngo_name (string, required) - Name of the NGO
- title (string, required) - Request title (e.g., "Request for: Fresh Vegetables")
- description (string, required) - Detailed description
- food_category (enum, required) - freshProduce, dairy, meat, bakery, canned, prepared, other
- quantity (double, required) - Amount requested
- unit (string, required) - Unit of measurement
- delivery_address (string, required) - NGO delivery address
- needed_by (datetime, required) - When the food is needed
- status (enum, required) - pending, approved, denied, converted, cancelled
- donation_id (string, optional) - Link to specific donation being requested
- reviewed_by (string, optional) - Admin user ID who reviewed
- reviewed_at (datetime, optional) - When the request was reviewed
- denial_reason (string, optional) - Reason for denial
- converted_donation_id (string, optional) - If converted to donation
- created_at (datetime)
- updated_at (datetime)
```

## Key Components

### 1. DonationCard Widget (`lib/ui/widgets/donation_card.dart`)
- Shows "Request" button for NGOs
- On click, creates NGO request linked to the donation
- Shows "Requested" status if already requested by current user
- Shows "Already Requested" if requested by another NGO

### 2. NGORequestRepository (`lib/data/repositories/ngo_request_repository.dart`)
- `createRequest()` - Creates new NGO request with optional donation link
- `approveRequest()` - Approves request and assigns recipient to donation
- `denyRequest()` - Denies request with reason
- `getRequests()` - Fetches requests with filters
- `getPendingRequests()` - Fetches only pending requests
- Handles all notifications for admins, NGOs, and volunteers

### 3. NGORequestsScreen (`lib/ui/screens/admin/ngo_requests_screen.dart`)
- Admin interface for reviewing requests
- Shows pending, approved, and denied requests in tabs
- Approve/deny actions with confirmation dialogs
- Real-time updates via Appwrite subscriptions

### 4. RecipientDashboard (`lib/ui/screens/recipient/recipient_dashboard.dart`)
- Shows available donations with "Request" button
- Browse and filter donations
- View inventory and incoming deliveries

## Notification Flow

### When NGO Submits Request
- **To**: All admins
- **Type**: `ngoRequestSubmitted`
- **Title**: "New NGO Request"
- **Body**: "{NGO Name} has submitted a request for {quantity} {unit} of {category}"

### When Admin Approves Request
- **To**: NGO
  - **Type**: `ngoRequestApproved`
  - **Title**: "Request Approved"
  - **Body**: "Your request for {quantity} {unit} of {category} has been approved"

- **To**: Volunteer (if assigned)
  - **Type**: `deliveryAssigned`
  - **Title**: "Recipient Assigned"
  - **Body**: "A recipient ({NGO Name}) has been assigned to your delivery. Deliver to: {address}"

- **To**: Other admins
  - **Type**: `ngoRequestApproved`
  - **Title**: "Request Approved"
  - **Body**: "{Admin Name} approved {NGO Name}'s request for {category}"

### When Admin Denies Request
- **To**: NGO
  - **Type**: `ngoRequestDenied`
  - **Title**: "Request Denied"
  - **Body**: "Your request has been denied. Reason: {reason}"

- **To**: Other admins
  - **Type**: `ngoRequestDenied`
  - **Title**: "Request Denied"
  - **Body**: "{Admin Name} denied {NGO Name}'s request for {category}"

## Real-time Updates

The system uses Appwrite Realtime subscriptions to automatically refresh data:

1. **Admin Dashboard**: Subscribes to `ngo_requests` collection
   - Updates pending request count in real-time
   - Refreshes request list when new requests arrive

2. **NGO Dashboard**: Subscribes to `donations` collection
   - Updates available donations when status changes
   - Shows real-time availability

3. **Notifications**: All users subscribe to their notifications
   - Instant notification delivery
   - Real-time unread count updates

## Testing Guide

See [NGO_REQUESTS_TESTING_GUIDE.md](./NGO_REQUESTS_TESTING_GUIDE.md) for detailed testing instructions.

## Future Enhancements

1. **Bulk Approval**: Allow admins to approve multiple requests at once
2. **Request Priority**: Add priority levels for urgent requests
3. **Request History**: Show NGO's past request history to admins
4. **Auto-matching**: Automatically match requests with suitable donations
5. **Request Expiry**: Auto-cancel requests after a certain time
6. **Request Editing**: Allow NGOs to edit pending requests
7. **Request Analytics**: Track approval rates, response times, etc.

## Related Files

- `lib/data/models/ngo_request.dart` - NGO Request model
- `lib/data/repositories/ngo_request_repository.dart` - Repository
- `lib/ui/screens/admin/ngo_requests_screen.dart` - Admin UI
- `lib/ui/widgets/donation_card.dart` - Request button
- `lib/providers/admin_providers.dart` - State management
- `docs/NGO_REQUESTS_TESTING_GUIDE.md` - Testing guide
