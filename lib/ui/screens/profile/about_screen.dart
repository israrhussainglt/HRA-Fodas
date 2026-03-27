import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // App Logo and Name
            const SizedBox(height: 24),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.volunteer_activism,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'HRA-FoDAS',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Food Donation & Distribution System',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Chip(
              label: Text('Version 1.0.0'),
              backgroundColor: AppTheme.surfaceColor,
            ),
            const SizedBox(height: 32),
            
            // Mission Statement
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Our Mission',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'HRA-FoDAS connects food donors with those in need, reducing food waste '
                      'while fighting hunger in our communities. We believe that no good food '
                      'should go to waste when people are hungry.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Impact Stats
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.insights, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Our Impact',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ImpactStat(
                            icon: Icons.restaurant,
                            value: '50K+',
                            label: 'Meals Provided',
                          ),
                        ),
                        Expanded(
                          child: _ImpactStat(
                            icon: Icons.eco,
                            value: '25T',
                            label: 'CO₂ Saved',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ImpactStat(
                            icon: Icons.people,
                            value: '1K+',
                            label: 'Volunteers',
                          ),
                        ),
                        Expanded(
                          child: _ImpactStat(
                            icon: Icons.store,
                            value: '200+',
                            label: 'Partners',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Features
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Features',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FeatureItem(icon: Icons.volunteer_activism, text: 'Easy food donation posting'),
                    _FeatureItem(icon: Icons.location_on, text: 'Location-based matching'),
                    _FeatureItem(icon: Icons.local_shipping, text: 'Volunteer delivery coordination'),
                    _FeatureItem(icon: Icons.inventory, text: 'Inventory management for recipients'),
                    _FeatureItem(icon: Icons.analytics, text: 'Impact tracking & analytics'),
                    _FeatureItem(icon: Icons.chat, text: 'In-app messaging'),
                    _FeatureItem(icon: Icons.notifications, text: 'Real-time notifications'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Team
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.groups, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Our Team',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'HRA-FoDAS is developed by a passionate team dedicated to reducing '
                      'food waste and hunger. We work with local communities, food banks, '
                      'restaurants, and volunteers to make a difference.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Links
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Website'),
                    subtitle: const Text('www.hrafodas.org'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _showSnackBar(context, 'Opening website...'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('Open Source'),
                    subtitle: const Text('View on GitHub'),
                    trailing: const Icon(Icons.open_in_new),
                    onTap: () => _showSnackBar(context, 'Opening GitHub...'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.rate_review),
                    title: const Text('Rate Us'),
                    subtitle: const Text('Share your feedback'),
                    trailing: const Icon(Icons.star_border),
                    onTap: () => _showRateDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('Share App'),
                    subtitle: const Text('Invite friends to join'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showShareDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Legal
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _showLicenses(context),
                  child: const Text('Licenses'),
                ),
                const Text('•'),
                TextButton(
                  onPressed: () {},
                  child: const Text('Privacy'),
                ),
                const Text('•'),
                TextButton(
                  onPressed: () {},
                  child: const Text('Terms'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '© 2024 HRA-FoDAS. All rights reserved.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showRateDialog(BuildContext context) {
    int rating = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Rate HRA-FoDAS'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How would you rate your experience?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                    onPressed: () => setState(() => rating = index + 1),
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: rating > 0 ? () {
                Navigator.pop(context);
                _showSnackBar(context, 'Thank you for your $rating-star rating!');
              } : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share HRA-FoDAS'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share the app with friends and family!'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ShareButton(icon: Icons.message, label: 'SMS', onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Opening SMS...');
                }),
                _ShareButton(icon: Icons.email, label: 'Email', onTap: () {
                  Navigator.pop(context);
                  _showSnackBar(context, 'Opening email...');
                }),
                _ShareButton(icon: Icons.copy, label: 'Copy', onTap: () {
                  Clipboard.setData(const ClipboardData(
                    text: 'Check out HRA-FoDAS - Help reduce food waste! Download at: https://hrafodas.org/download',
                  ));
                  Navigator.pop(context);
                  _showSnackBar(context, 'Link copied to clipboard!');
                }),
              ],
            ),
          ],
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

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'HRA-FoDAS',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.volunteer_activism, color: Colors.white, size: 36),
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ImpactStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShareButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppTheme.primaryColor),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
