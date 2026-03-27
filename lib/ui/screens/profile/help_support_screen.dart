import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for help...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                _showSnackBar(context, 'Searching for "$query"...');
              }
            },
          ),
          const SizedBox(height: 24),
          
          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.chat_bubble,
                  title: 'Live Chat',
                  onTap: () => _showLiveChatDialog(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.email,
                  title: 'Email Us',
                  onTap: () => _showEmailDialog(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.phone,
                  title: 'Call Us',
                  onTap: () => _showCallDialog(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // FAQs
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _FAQItem(
            question: 'How do I create a donation?',
            answer: 'To create a donation:\n'
                '1. Go to your dashboard\n'
                '2. Tap the "+" or "New Donation" button\n'
                '3. Fill in the food details, quantity, and pickup location\n'
                '4. Set the expiration date and preferred pickup time\n'
                '5. Submit your donation',
          ),
          _FAQItem(
            question: 'How do I become a volunteer?',
            answer: 'To become a volunteer:\n'
                '1. Register with a volunteer account\n'
                '2. Complete your profile with contact details\n'
                '3. Verify your identity (if required)\n'
                '4. Start accepting delivery requests from the available donations list',
          ),
          _FAQItem(
            question: 'What types of food can I donate?',
            answer: 'You can donate:\n'
                '• Fresh produce (fruits, vegetables)\n'
                '• Packaged foods (canned goods, dry goods)\n'
                '• Prepared meals (must be properly stored)\n'
                '• Dairy products (within expiration)\n'
                '• Baked goods\n\n'
                'Please ensure all food is safe for consumption and properly labeled.',
          ),
          _FAQItem(
            question: 'How do I track my donation?',
            answer: 'You can track your donation status in the "My Donations" section. '
                'You\'ll see real-time updates when:\n'
                '• A volunteer accepts the pickup\n'
                '• The food is picked up\n'
                '• The delivery is in progress\n'
                '• The donation is delivered',
          ),
          _FAQItem(
            question: 'Is my personal information safe?',
            answer: 'Yes! We take privacy seriously:\n'
                '• Your data is encrypted\n'
                '• We never sell your information\n'
                '• Location is only shared with assigned volunteers\n'
                '• You can delete your account anytime',
          ),
          const SizedBox(height: 24),
          
          // Contact Info
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email, color: AppTheme.primaryColor),
                  title: const Text('Email'),
                  subtitle: const Text('support@hrafodas.org'),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: 'support@hrafodas.org'));
                      _showSnackBar(context, 'Email copied to clipboard');
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.phone, color: AppTheme.primaryColor),
                  title: const Text('Phone'),
                  subtitle: const Text('+1 (800) 123-4567'),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: '+18001234567'));
                      _showSnackBar(context, 'Phone number copied to clipboard');
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.access_time, color: AppTheme.primaryColor),
                  title: const Text('Support Hours'),
                  subtitle: const Text('Mon-Fri: 9AM - 6PM\nSat-Sun: 10AM - 4PM'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Report Issue
          ElevatedButton.icon(
            onPressed: () => _showReportIssueDialog(context),
            icon: const Icon(Icons.bug_report),
            label: const Text('Report an Issue'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showLiveChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Live Chat'),
        content: const Text(
          'Our support team is available:\n\n'
          'Mon-Fri: 9AM - 6PM\n'
          'Sat-Sun: 10AM - 4PM\n\n'
          'Would you like to start a chat session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(context, 'Connecting to support agent...');
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _showEmailDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email Support'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Brief description of your issue',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  hintText: 'Describe your issue in detail...',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (subjectController.text.isEmpty || messageController.text.isEmpty) {
                _showSnackBar(context, 'Please fill in all fields');
                return;
              }
              Navigator.pop(context);
              _showSnackBar(context, 'Email sent! We\'ll respond within 24 hours.');
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone, size: 48, color: AppTheme.primaryColor),
            SizedBox(height: 16),
            Text(
              '+1 (800) 123-4567',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Tap to call our support line'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(context, 'Opening phone dialer...');
            },
            icon: const Icon(Icons.call),
            label: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    final descriptionController = TextEditingController();
    String selectedType = 'Bug';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Report an Issue'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Issue Type'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  items: ['Bug', 'Feature Request', 'Performance', 'Other']
                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedType = value!),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Please describe the issue...',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (descriptionController.text.isEmpty) {
                  _showSnackBar(context, 'Please describe the issue');
                  return;
                }
                Navigator.pop(context);
                _showSnackBar(context, 'Issue reported. Thank you for your feedback!');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppTheme.primaryColor),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(widget.question),
        trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(widget.answer),
          ),
        ],
      ),
    );
  }
}
