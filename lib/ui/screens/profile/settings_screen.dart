import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

// Settings state provider
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
final darkModeProvider = StateProvider<bool>((ref) => true);
final locationEnabledProvider = StateProvider<bool>((ref) => true);
final emailNotificationsProvider = StateProvider<bool>((ref) => true);
final pushNotificationsProvider = StateProvider<bool>((ref) => true);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final darkMode = ref.watch(darkModeProvider);
    final locationEnabled = ref.watch(locationEnabledProvider);
    final emailNotifications = ref.watch(emailNotificationsProvider);
    final pushNotifications = ref.watch(pushNotificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Notifications'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications),
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive app notifications'),
            value: notificationsEnabled,
            onChanged: (value) {
              ref.read(notificationsEnabledProvider.notifier).state = value;
              _showSnackBar(
                context,
                'Notifications ${value ? 'enabled' : 'disabled'}',
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.email),
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive updates via email'),
            value: emailNotifications,
            onChanged: notificationsEnabled
                ? (value) {
                    ref.read(emailNotificationsProvider.notifier).state = value;
                    _showSnackBar(
                      context,
                      'Email notifications ${value ? 'enabled' : 'disabled'}',
                    );
                  }
                : null,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.phone_android),
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive push notifications'),
            value: pushNotifications,
            onChanged: notificationsEnabled
                ? (value) {
                    ref.read(pushNotificationsProvider.notifier).state = value;
                    _showSnackBar(
                      context,
                      'Push notifications ${value ? 'enabled' : 'disabled'}',
                    );
                  }
                : null,
          ),
          const Divider(),
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: darkMode,
            onChanged: (value) {
              ref.read(darkModeProvider.notifier).state = value;
              _showSnackBar(
                context,
                'Dark mode ${value ? 'enabled' : 'disabled'}',
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'Privacy'),
          SwitchListTile(
            secondary: const Icon(Icons.location_on),
            title: const Text('Location Services'),
            subtitle: const Text('Allow app to access location'),
            value: locationEnabled,
            onChanged: (value) {
              ref.read(locationEnabledProvider.notifier).state = value;
              _showSnackBar(
                context,
                'Location services ${value ? 'enabled' : 'disabled'}',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showTermsOfService(context),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Account'),
          ListTile(
            leading: const Icon(Icons.password),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showChangePasswordDialog(context, ref),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever,
              color: AppTheme.errorColor,
            ),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: AppTheme.errorColor),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppTheme.errorColor,
            ),
            onTap: () => _showDeleteAccountDialog(context, ref),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Data'),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export My Data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showSnackBar(context, 'Preparing data export...');
            },
          ),
          ListTile(
            leading: const Icon(Icons.cached),
            title: const Text('Clear Cache'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showClearCacheDialog(context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'HRA-FoDAS Privacy Policy\n\n'
            '1. Information Collection\n'
            'We collect information you provide directly, including name, email, '
            'phone number, and location data for donation coordination.\n\n'
            '2. Use of Information\n'
            'Your information is used to facilitate food donations, connect donors '
            'with recipients, and improve our services.\n\n'
            '3. Data Sharing\n'
            'We share necessary information with volunteers and recipients to '
            'complete donations. We do not sell your data.\n\n'
            '4. Data Security\n'
            'We implement security measures to protect your personal information.\n\n'
            '5. Contact\n'
            'For privacy concerns, contact us at privacy@hrafodas.org',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'HRA-FoDAS Terms of Service\n\n'
            '1. Acceptance\n'
            'By using HRA-FoDAS, you agree to these terms.\n\n'
            '2. User Responsibilities\n'
            '- Provide accurate information\n'
            '- Ensure food safety standards\n'
            '- Complete scheduled donations\n'
            '- Treat all users with respect\n\n'
            '3. Food Safety\n'
            'Donors must ensure food is safe for consumption. Recipients accept '
            'food at their own discretion.\n\n'
            '4. Liability\n'
            'HRA-FoDAS facilitates connections but is not liable for food quality '
            'or delivery issues.\n\n'
            '5. Account Termination\n'
            'We may terminate accounts that violate these terms.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, WidgetRef ref) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                _showSnackBar(context, 'Passwords do not match');
                return;
              }
              if (newPasswordController.text.length < 6) {
                _showSnackBar(
                  context,
                  'Password must be at least 6 characters',
                );
                return;
              }
              Navigator.pop(context);
              _showSnackBar(context, 'Password changed successfully');
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone. '
          'All your data, including donations and history, will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(
                context,
                'Account deletion requested. You will receive a confirmation email.',
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data. You may need to reload some content.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(context, 'Cache cleared successfully');
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
