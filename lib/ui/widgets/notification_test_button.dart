import 'package:flutter/material.dart';
import '../../services/appwrite_notification_service.dart';
import 'notification_popup.dart';

/// Simple test button to verify notification system
class NotificationTestButton extends StatelessWidget {
  const NotificationTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showTestMenu(context),
      tooltip: 'Test Notifications',
      child: const Icon(Icons.notifications_active),
    );
  }

  void _showTestMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Test Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Success Message'),
              onTap: () {
                Navigator.pop(context);
                NotificationPopup.showSuccess(
                  context,
                  'Success! This is a test success message.',
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: const Text('Error Message'),
              onTap: () {
                Navigator.pop(context);
                NotificationPopup.showError(
                  context,
                  'Error! This is a test error message.',
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.warning, color: Colors.orange),
              title: const Text('Warning Message'),
              onTap: () {
                Navigator.pop(context);
                NotificationPopup.showWarning(
                  context,
                  'Warning! This is a test warning message.',
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('Info Message'),
              onTap: () {
                Navigator.pop(context);
                NotificationPopup.showInfo(
                  context,
                  'Info! This is a test info message.',
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Local Notification'),
              onTap: () async {
                Navigator.pop(context);
                await AppwriteNotificationService.instance.showNotification(
                  id: (DateTime.now().millisecondsSinceEpoch % 2147483647)
                      .toInt(),
                  title: 'Test Notification',
                  body: 'This is a test local notification!',
                  data: {'test': 'true'},
                );

                if (context.mounted) {
                  NotificationPopup.showSuccess(
                    context,
                    'Local notification sent!',
                  );
                }
              },
            ),

            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Confirmation Dialog'),
              onTap: () async {
                Navigator.pop(context);
                final confirmed = await NotificationPopup.showConfirmation(
                  context,
                  title: 'Test Confirmation',
                  message: 'Do you want to proceed with this test?',
                );

                if (confirmed && context.mounted) {
                  NotificationPopup.showSuccess(context, 'Confirmed!');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
