import 'package:flutter/material.dart';
import '../../services/appwrite_notification_service.dart';
import 'notification_popup.dart';

/// Quick notification test widget - add this to any screen for testing
class QuickNotificationTest extends StatelessWidget {
  const QuickNotificationTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🧪 Notification Test',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => NotificationPopup.showSuccess(
                  context,
                  'Test success message!',
                ),
                child: const Text('Success'),
              ),
              ElevatedButton(
                onPressed: () =>
                    NotificationPopup.showError(context, 'Test error message!'),
                child: const Text('Error'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AppwriteNotificationService.instance.showNotification(
                    id: (DateTime.now().millisecondsSinceEpoch % 2147483647)
                        .toInt(),
                    title: 'Test Local Notification',
                    body: 'This is a test notification!',
                    data: {'test': 'true'},
                  );

                  if (context.mounted) {
                    NotificationPopup.showInfo(
                      context,
                      'Local notification sent!',
                    );
                  }
                },
                child: const Text('Local'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
