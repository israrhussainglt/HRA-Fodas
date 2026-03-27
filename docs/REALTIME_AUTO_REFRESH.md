# Real-Time Auto-Refresh Feature

## Overview

The HRA-FoDAS app now includes **real-time auto-refresh** functionality using Appwrite Realtime subscriptions. This means all dashboards automatically update when new data is added to the database, without requiring manual refresh.

## Date Implemented

January 26, 2026

## How It Works

### Appwrite Realtime Subscriptions

The app uses Appwrite's Realtime API to subscribe to database collection changes. When any document is created, updated, or deleted in a subscribed collection, the app receives an event and automatically refreshes the relevant data.

### Subscription Pattern

```dart
// Subscribe to a collection
_subscription = realtime.subscribe([
  'databases.${databaseId}.collections.${collectionId}.documents',
]);

// Listen for changes
_subscription!.stream.listen((response) {
  if (response.events.contains('databases.*.collections.*.documents.*')) {
    // Invalidate Riverpod providers to trigger refresh
    ref.invalidate(dataProvider);
  }
});
```

## Dashboards with Real-Time Updates

### 1. Admin Dashboard
**File**: `lib/ui/screens/admin/admin_dashboard.dart`

**Subscriptions**:
- ✅ **Donations Collection**: Auto-refreshes donation stats and list
- ✅ **User Profiles Collection**: Auto-refreshes user statistics
- ✅ **Notifications Collection**: Auto-refreshes notification badge

**What Updates Automatically**:
- Total donations count
- User statistics (donors, volunteers, recipients, admins)
- Donation status changes
- New user registrations
- Notification bell icon badge

### 2. Donor Dashboard
**File**: `lib/ui/screens/donor/donor_dashboard.dart`

**Subscriptions**:
- ✅ **Donations Collection**: Auto-refreshes donor's donations
- ✅ **Notifications Collection**: Auto-refreshes notifications

**What Updates Automatically**:
- My donations list
- Donation status changes (when volunteer accepts, picks up, delivers)
- New notifications
- Notification badge count

### 3. Volunteer Dashboard
**File**: `lib/ui/screens/volunteer/volunteer_dashboard.dart`

**Subscriptions**:
- ✅ **Donations Collection**: Auto-refreshes available donations
- ✅ **Notifications Collection**: Auto-refreshes notifications

**What Updates Automatically**:
- Available donations list
- New donations appear instantly
- Donation status changes
- New notifications
- Notification badge count

### 4. Recipient Dashboard
**File**: `lib/ui/screens/recipient/recipient_dashboard.dart`

**Subscriptions**:
- ✅ **Donations Collection**: Auto-refreshes available donations
- ✅ **Inventory Collection**: Auto-refreshes inventory items
- ✅ **Notifications Collection**: Auto-refreshes notifications

**What Updates Automatically**:
- Available donations list
- Inventory items
- Expiring items alerts
- New notifications
- Notification badge count

### 5. Notifications Screen
**File**: `lib/ui/screens/notifications/notifications_screen.dart`

**Subscriptions**:
- ✅ **Notifications Collection**: Auto-refreshes notification list

**What Updates Automatically**:
- New notifications appear instantly
- Read/unread status changes
- Deleted notifications removed instantly

## Benefits

### 1. Better User Experience
- No need to manually pull-to-refresh
- Instant updates when data changes
- Always see the latest information

### 2. Real-Time Collaboration
- Multiple users see changes simultaneously
- Admins see new donations immediately
- Volunteers see new opportunities instantly
- Recipients get real-time inventory updates

### 3. Improved Efficiency
- Faster response times
- Better coordination between users
- Reduced confusion from stale data

## Technical Implementation

### Lifecycle Management

Each dashboard properly manages subscription lifecycle:

```dart
@override
void initState() {
  super.initState();
  _setupRealtimeSubscriptions();
}

@override
void dispose() {
  _subscription?.close();
  super.dispose();
}
```

### Provider Invalidation

When changes are detected, Riverpod providers are invalidated to trigger data refresh:

```dart
_subscription!.stream.listen((response) {
  if (response.events.contains('databases.*.collections.*.documents.*')) {
    ref.invalidate(dataProvider);
  }
});
```

### Memory Management

- Subscriptions are properly closed in `dispose()`
- No memory leaks
- Efficient resource usage

## Event Types

The app listens for these Appwrite Realtime events:

- `databases.*.collections.*.documents.*` - Any document change
- `databases.*.collections.*.documents.*.create` - Document created
- `databases.*.collections.*.documents.*.update` - Document updated
- `databases.*.collections.*.documents.*.delete` - Document deleted

## Collections Monitored

1. **donations** - All donation-related changes
2. **user_profiles** - User registration and profile updates
3. **notifications** - New notifications and status changes
4. **inventory** - Inventory item changes (recipients only)

## Performance Considerations

### Efficient Updates
- Only invalidates relevant providers
- Uses Riverpod's smart caching
- Minimal network overhead

### Bandwidth Usage
- Realtime subscriptions use WebSocket (efficient)
- Only receives events for subscribed collections
- Automatic reconnection on network issues

### Battery Impact
- Minimal battery drain
- WebSocket connection is lightweight
- Subscriptions closed when screen is disposed

## Testing Real-Time Updates

### Test Scenario 1: New Donation
1. Open admin dashboard
2. Create a donation from donor account (different device/browser)
3. Admin dashboard should update automatically
4. No manual refresh needed

### Test Scenario 2: Notification
1. Open notifications screen
2. Create a donation (triggers notification)
3. Notification should appear instantly
4. Badge count updates automatically

### Test Scenario 3: Status Change
1. Volunteer opens dashboard
2. Donor creates donation
3. Donation appears in volunteer's available list instantly
4. Volunteer accepts donation
5. Donor sees status change immediately

## Troubleshooting

### Issue: Updates Not Appearing

**Possible Causes**:
1. Network connection lost
2. Appwrite Realtime not enabled
3. Subscription not properly initialized

**Solutions**:
1. Check internet connection
2. Verify Appwrite project has Realtime enabled
3. Restart the app
4. Check console logs for subscription errors

### Issue: Too Many Updates

**Possible Causes**:
1. Multiple subscriptions to same collection
2. Provider invalidation too aggressive

**Solutions**:
1. Ensure only one subscription per collection per screen
2. Check `dispose()` is properly closing subscriptions

## Future Enhancements

### Planned Features
- [ ] Selective updates (only for specific documents)
- [ ] Optimistic UI updates
- [ ] Offline queue with sync on reconnect
- [ ] Real-time chat messages
- [ ] Live location tracking for deliveries

### Potential Improvements
- [ ] Debounce rapid updates
- [ ] Show "New items available" banner
- [ ] Animate new items appearing
- [ ] Sound/vibration on important updates

## Code Examples

### Basic Subscription Setup

```dart
RealtimeSubscription? _subscription;

void _setupRealtimeSubscription() {
  final realtime = ref.read(appwriteRealtimeProvider);
  
  _subscription = realtime.subscribe([
    'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.donationsCollection}.documents',
  ]);

  _subscription!.stream.listen((response) {
    if (response.events.contains('databases.*.collections.*.documents.*')) {
      ref.invalidate(donationsProvider);
    }
  });
}
```

### Multiple Subscriptions

```dart
RealtimeSubscription? _donationsSubscription;
RealtimeSubscription? _notificationsSubscription;

void _setupRealtimeSubscriptions() {
  final realtime = ref.read(appwriteRealtimeProvider);

  // Donations
  _donationsSubscription = realtime.subscribe([
    'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.donationsCollection}.documents',
  ]);

  _donationsSubscription!.stream.listen((response) {
    if (response.events.contains('databases.*.collections.*.documents.*')) {
      ref.invalidate(donationsProvider);
    }
  });

  // Notifications
  _notificationsSubscription = realtime.subscribe([
    'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.notificationsCollection}.documents',
  ]);

  _notificationsSubscription!.stream.listen((response) {
    if (response.events.contains('databases.*.collections.*.documents.*')) {
      ref.invalidate(notificationsProvider);
    }
  });
}

@override
void dispose() {
  _donationsSubscription?.close();
  _notificationsSubscription?.close();
  super.dispose();
}
```

## Best Practices

1. **Always close subscriptions** in `dispose()`
2. **Check for null** before accessing user data
3. **Use specific events** when possible for efficiency
4. **Invalidate only relevant providers** to avoid unnecessary rebuilds
5. **Test on real devices** to verify performance

## Related Documentation

- [Appwrite Realtime Documentation](https://appwrite.io/docs/realtime)
- [Riverpod Provider Invalidation](https://riverpod.dev/docs/concepts/reading#invalidating-a-provider)
- [Flutter Lifecycle Methods](https://api.flutter.dev/flutter/widgets/State-class.html)

---

**Status**: ✅ Implemented and Production Ready  
**Version**: 1.0.0  
**Last Updated**: January 26, 2026
