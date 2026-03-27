# Notification and Approval Workflow System

## Overview

This document describes the complete notification and approval workflow for the HRA-FoDAS platform, distinguishing between **Donor-Initiated Donations** and **NGO-Initiated Requests**.

## Key Roles

| Role | Primary Function | Oversight/Notifications |
|------|-----------------|------------------------|
| **Donor** | Offers items for donation | Receives confirmation of Volunteer acceptance |
| **NGO (Recipient)** | Receives donation offers or submits specific requests | Receives notification of new donation offers |
| **Volunteer** | Accepts and executes the delivery/pickup of donations | Receives notification of new donation offers |
| **Admin** | System oversight and request approval | Receives ALL status updates and key event notifications |

## Workflow 1: Donor-Initiated Donation (Standard Flow)

This workflow begins when a Donor offers an item for donation.

### Step 1: Donation Offer
**Action**: Donor creates and submits a new donation offer

**Notification Recipients**:
- ✅ NGO (All recipients)
- ✅ Volunteer (All volunteers)
- ✅ Admin (All admins)

**Notification Type**: `new_donation`

**Implementation**: `DonationRepository.createDonation()`

---

### Step 2: Delivery Acceptance
**Action**: Volunteer accepts the task to pick up and deliver the donation

**Notification Recipients**:
- ✅ Donor (Original donor)
- ✅ Admin (All admins)

**Notification Type**: `volunteer_accepted`

**Implementation**: `DonationRepository.assignVolunteer()`

---

### Step 3: Pickup Completion
**Action**: Volunteer marks the donation as picked up

**Notification Recipients**:
- ✅ Donor (Original donor)
- ✅ Admin (All admins)

**Notification Type**: `donation_picked_up`

**Implementation**: `DonationRepository.markAsPickedUp()`

---

### Step 4: Delivery Completion
**Action**: Volunteer marks the delivery as complete

**Notification Recipients**:
- ✅ NGO (Assigned recipient, if any)
- ✅ Donor (Original donor)
- ✅ Admin (All admins)

**Notification Type**: `donation_delivered`

**Implementation**: `DonationRepository.markAsDelivered()`

---

### Additional Events

#### NGO Requests Delivery
**Action**: NGO requests delivery of an available donation

**Notification Recipients**:
- ✅ Volunteer (Assigned volunteer)
- ✅ Admin (All admins)

**Notification Type**: `ngo_requested`

**Implementation**: `DonationRepository.assignRecipient()`

---

#### Donation Cancelled
**Action**: Donor cancels the donation

**Notification Recipients**:
- ✅ Volunteer (If assigned)
- ✅ NGO (If assigned)
- ✅ Admin (All admins)

**Notification Type**: `donation_cancelled`

**Implementation**: `DonationRepository.cancelDonation()`

---

## Workflow 2: NGO-Initiated Request (Approval Flow)

This workflow begins when an NGO submits a request for a specific item or resource. This process requires explicit administrative approval before proceeding.

### Step 1: Request Submission
**Action**: NGO submits a formal request for a specific item

**Notification Recipients**:
- ✅ Admin (All admins)

**Notification Type**: `ngo_request_submitted`

**Implementation**: `NGORequestRepository.createRequest()`

**Database Table**: `ngo_requests`

---

### Step 2: Administrative Review
**Action**: Admin reviews the request and must explicitly **Approve** or **Deny** it

**Notification Recipients**: None (Action by Admin)

**Implementation**: 
- `NGORequestRepository.approveRequest()`
- `NGORequestRepository.denyRequest()`

---

### Step 3: Request Outcome

#### If Approved
**Action**: The request is converted into an active, open opportunity

**Notification Recipients**:
- ✅ NGO (Requesting organization)
- ✅ Admin (All other admins, excluding the approving admin)

**Notification Type**: `ngo_request_approved`

**Next Steps**: The approved request can be converted into a donation opportunity that donors and volunteers can see

---

#### If Denied
**Action**: The request is closed with a reason

**Notification Recipients**:
- ✅ NGO (Requesting organization)
- ✅ Admin (All other admins, excluding the denying admin)

**Notification Type**: `ngo_request_denied`

**Denial Reason**: Stored in `ngo_requests.denial_reason`

---

## System-Wide Oversight Requirement

**The Admin role receives a notification for EVERY status change and key event** across both the Donor-Initiated and NGO-Initiated workflows. This ensures comprehensive oversight of all platform activities.

### Admin Notifications Summary

Admins are notified for:
1. ✅ New donation created
2. ✅ Volunteer accepts donation
3. ✅ NGO requests delivery
4. ✅ Donation picked up
5. ✅ Donation delivered
6. ✅ Donation cancelled
7. ✅ NGO request submitted
8. ✅ NGO request approved (by another admin)
9. ✅ NGO request denied (by another admin)

---

## Database Schema

### ngo_requests Table

```sql
CREATE TABLE ngo_requests (
  id VARCHAR(36) PRIMARY KEY,
  ngo_id VARCHAR(36) NOT NULL,
  ngo_name VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  food_category VARCHAR(50) NOT NULL,
  quantity DECIMAL(10,2) NOT NULL,
  unit VARCHAR(50) NOT NULL,
  delivery_address TEXT NOT NULL,
  needed_by DATETIME NOT NULL,
  status VARCHAR(50) NOT NULL, -- pending, approved, denied, converted, cancelled
  denial_reason TEXT,
  reviewed_by VARCHAR(36),
  reviewed_at DATETIME,
  converted_donation_id VARCHAR(36),
  created_at DATETIME NOT NULL,
  updated_at DATETIME,
  metadata JSON
);
```

### Notification Types

All notification types are defined in `lib/data/models/notification_model.dart`:

```dart
enum NotificationType {
  newDonation,              // Donor creates donation
  volunteerAccepted,        // Volunteer accepts donation
  ngoRequested,             // NGO requests delivery
  donationPickedUp,         // Volunteer picks up donation
  donationDelivered,        // Volunteer delivers donation
  donationCancelled,        // Donor cancels donation
  ngoRequestSubmitted,      // NGO submits request
  ngoRequestApproved,       // Admin approves request
  ngoRequestDenied,         // Admin denies request
  // ... other types
}
```

---

## Implementation Files

### Models
- `lib/data/models/ngo_request.dart` - NGO request model
- `lib/data/models/notification_model.dart` - Notification types and models

### Repositories
- `lib/data/repositories/ngo_request_repository.dart` - NGO request CRUD and notifications
- `lib/data/repositories/donation_repository.dart` - Donation workflow with admin notifications
- `lib/data/repositories/notification_repository.dart` - Notification management

### Services
- `lib/services/enhanced_notification_service.dart` - Multi-channel notification delivery

---

## Testing the Workflow

### Test Workflow 1: Donor-Initiated Donation

1. **Login as Donor** → Create a new donation
   - ✅ Check: Admin receives "New Donation" notification
   - ✅ Check: Volunteers receive notification
   - ✅ Check: NGOs receive notification

2. **Login as Volunteer** → Accept the donation
   - ✅ Check: Donor receives "Volunteer Accepted" notification
   - ✅ Check: Admin receives notification

3. **As Volunteer** → Mark as picked up
   - ✅ Check: Donor receives "Donation Picked Up" notification
   - ✅ Check: Admin receives notification

4. **As Volunteer** → Mark as delivered
   - ✅ Check: Donor receives "Donation Delivered" notification
   - ✅ Check: Admin receives notification
   - ✅ Check: NGO receives notification (if assigned)

### Test Workflow 2: NGO-Initiated Request

1. **Login as NGO** → Submit a request
   - ✅ Check: Admin receives "NGO Request Submitted" notification

2. **Login as Admin** → Approve the request
   - ✅ Check: NGO receives "Request Approved" notification
   - ✅ Check: Other admins receive notification

3. **Login as Admin** → Deny a request (with reason)
   - ✅ Check: NGO receives "Request Denied" notification with reason
   - ✅ Check: Other admins receive notification

---

## Future Enhancements

1. **Auto-matching**: Automatically match approved NGO requests with suitable donors
2. **Request expiration**: Auto-deny requests that are too old
3. **Priority levels**: Allow admins to set priority for urgent requests
4. **Batch approval**: Allow admins to approve multiple requests at once
5. **Request templates**: Pre-defined request templates for common items
6. **Notification preferences**: Allow users to customize which notifications they receive
7. **Email notifications**: Send email summaries of important notifications
8. **SMS alerts**: Critical notifications via SMS

---

## Status: ✅ IMPLEMENTED

All core workflows and admin oversight notifications have been implemented and are ready for testing.

**Last Updated**: January 26, 2026
