import 'package:flutter/material.dart';
import '../../services/appwrite_notification_service.dart';
import 'notification_popup.dart';

/// Demo widget showing different notification types
/// Use this as a reference for implementing notifications in your app
class NotificationDemo extends StatelessWidget {
  const NotificationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pop-up Messages (Immediate UI Feedback)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Success SnackBar
            ElevatedButton.icon(
              onPressed: () => NotificationPopup.showSuccess(
                context,
                'Donation created successfully!',
              ),
              icon: const Icon(Icons.check_circle),
              label: const Text('Show Success Message'),
            ),

            // Error SnackBar
            ElevatedButton.icon(
              onPressed: () => NotificationPopup.showError(
                context,
                'Failed to upload donation image',
              ),
              icon: const Icon(Icons.error),
              label: const Text('Show Error Message'),
            ),

            // Warning SnackBar
            ElevatedButton.icon(
              onPressed: () => NotificationPopup.showWarning(
                context,
                'Donation expires in 2 hours',
              ),
              icon: const Icon(Icons.warning),
              label: const Text('Show Warning Message'),
            ),

            // Info SnackBar
            ElevatedButton.icon(
              onPressed: () => NotificationPopup.showInfo(
                context,
                'New volunteer joined your area',
              ),
              icon: const Icon(Icons.info),
              label: const Text('Show Info Message'),
            ),

            const SizedBox(height: 24),
            const Text(
              'Dialog Pop-ups (Confirmations)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Confirmation Dialog
            ElevatedButton.icon(
              onPressed: () async {
                final confirmed = await NotificationPopup.showConfirmation(
                  context,
                  title: 'Delete Donation',
                  message:
                      'Are you sure you want to delete this donation? This action cannot be undone.',
                  confirmText: 'Delete',
                  confirmColor: Colors.red,
                );

                if (confirmed && context.mounted) {
                  NotificationPopup.showSuccess(context, 'Donation deleted');
                }
              },
              icon: const Icon(Icons.delete),
              label: const Text('Show Confirmation Dialog'),
            ),

            // Bottom Sheet
            ElevatedButton.icon(
              onPressed: () => NotificationPopup.showBottomSheet(
                context,
                title: 'New Donation Available',
                message:
                    'Fresh meals are available for pickup in your area. Would you like to view details?',
                icon: Icons.volunteer_activism,
                iconColor: Colors.green,
                actionText: 'View Donation',
                onAction: () {
                  NotificationPopup.showInfo(
                    context,
                    'Navigating to donation...',
                  );
                },
              ),
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('Show Bottom Sheet'),
            ),

            const SizedBox(height: 24),
            const Text(
              'System Notifications (Persistent)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Local Notification
            ElevatedButton.icon(
              onPressed: () async {
                await AppwriteNotificationService.instance.showNotification(
                  id: (DateTime.now().millisecondsSinceEpoch % 2147483647)
                      .toInt(),
                  title: 'New Donation Available',
                  body: 'Fresh meals available for pickup near you',
                  data: {
                    'type': 'new_donation',
                    'donation_id': 'donation_123',
                    'location': 'Downtown Food Bank',
                  },
                );

                if (context.mounted) {
                  NotificationPopup.showSuccess(
                    context,
                    'Local notification sent! Check your notification tray.',
                  );
                }
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Send Local Notification'),
            ),

            // High Priority Notification (Pop-up style)
            ElevatedButton.icon(
              onPressed: () async {
                await AppwriteNotificationService.instance.showNotification(
                  id: (DateTime.now().millisecondsSinceEpoch % 2147483647)
                      .toInt(),
                  title: 'URGENT: Pickup Required',
                  body:
                      'Donation expires in 30 minutes! Please pickup immediately.',
                  data: {
                    'type': 'pickup_reminder',
                    'priority': 'high',
                    'donation_id': 'donation_456',
                  },
                );

                if (context.mounted) {
                  NotificationPopup.showWarning(
                    context,
                    'High priority notification sent!',
                  );
                }
              },
              icon: const Icon(Icons.priority_high),
              label: const Text('Send High Priority Notification'),
            ),

            const SizedBox(height: 16),

            // FCM Token Info
            ElevatedButton.icon(
              onPressed: () async {
                final token = await AppwriteNotificationService.instance
                    .getToken();
                if (context.mounted) {
                  NotificationPopup.showCustomDialog(
                    context,
                    title: 'FCM Token',
                    content: SelectableText(
                      token ?? 'No token available',
                      style: const TextStyle(fontSize: 12),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  );
                }
              },
              icon: const Icon(Icons.token),
              label: const Text('Show FCM Token'),
            ),
          ],
        ),
      ),
    );
  }
}
