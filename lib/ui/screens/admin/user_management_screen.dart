import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/admin_providers.dart';
import '../../../providers/providers.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  String? _roleFilter;

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(allUsersProvider(_roleFilter));
    final statsAsync = ref.watch(userStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) =>
                setState(() => _roleFilter = value == 'all' ? null : value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Users')),
              const PopupMenuItem(value: 'donor', child: Text('Donors')),
              const PopupMenuItem(
                value: 'recipient',
                child: Text('Recipients'),
              ),
              const PopupMenuItem(
                value: 'volunteer',
                child: Text('Volunteers'),
              ),
              const PopupMenuItem(value: 'admin', child: Text('Admins')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          statsAsync.when(
            data: (stats) => _buildStatsBar(stats),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const Divider(),
          Expanded(
            child: usersAsync.when(
              data: (users) => users.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: users.length,
                      itemBuilder: (context, index) =>
                          _buildUserCard(users[index]),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(Map<String, int> stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'Total', value: stats['total'] ?? 0),
          _StatItem(label: 'Donors', value: stats['donor'] ?? 0),
          _StatItem(label: 'Recipients', value: stats['recipient'] ?? 0),
          _StatItem(label: 'Volunteers', value: stats['volunteer'] ?? 0),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final userId = user['id'] as String;
    final name = user['full_name'] as String? ?? 'Unknown';
    final email = user['email'] as String? ?? '';
    final role = user['role'] as String? ?? 'user';
    final isActive = user['is_active'] as bool? ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(child: Text(name[0].toUpperCase())),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(email),
            const SizedBox(height: 4),
            Row(
              children: [
                Chip(
                  label: Text(role, style: const TextStyle(fontSize: 12)),
                  avatar: Icon(_getRoleIcon(role), size: 16),
                ),
                const SizedBox(width: 8),
                if (!isActive)
                  const Chip(
                    label: Text('Inactive', style: TextStyle(fontSize: 12)),
                    backgroundColor: Colors.red,
                  ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrustScoreSection(userId),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () => _viewUserDetails(userId),
                      icon: const Icon(Icons.visibility),
                      label: const Text('View Details'),
                    ),
                    TextButton.icon(
                      onPressed: () => _toggleUserStatus(userId, !isActive),
                      icon: Icon(isActive ? Icons.block : Icons.check_circle),
                      label: Text(isActive ? 'Deactivate' : 'Activate'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustScoreSection(String userId) {
    final trustScoreAsync = ref.watch(userTrustScoreProvider(userId));

    return trustScoreAsync.when(
      data: (trustScore) {
        if (trustScore == null) {
          return TextButton.icon(
            onPressed: () => _calculateTrustScore(userId),
            icon: const Icon(Icons.calculate),
            label: const Text('Calculate Trust Score'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trust & Reliability',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TrustScoreBar(
                    label: 'Trust',
                    score: trustScore.trustScore,
                    level: trustScore.trustLevel,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _TrustScoreBar(
                    label: 'Reliability',
                    score: trustScore.reliabilityScore,
                    level: trustScore.reliabilityLevel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Based on ${trustScore.totalInteractions} interactions',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Failed to load trust score'),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'donor':
        return Icons.volunteer_activism;
      case 'recipient':
        return Icons.restaurant;
      case 'volunteer':
        return Icons.delivery_dining;
      case 'admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  Future<void> _calculateTrustScore(String userId) async {
    await ref.read(adminRepositoryProvider).calculateTrustScore(userId);
    ref.invalidate(userTrustScoreProvider(userId));

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Trust score calculated')));
    }
  }

  Future<void> _toggleUserStatus(String userId, bool isActive) async {
    await ref.read(adminRepositoryProvider).updateUserStatus(userId, isActive);
    ref.invalidate(allUsersProvider(_roleFilter));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isActive ? 'User activated' : 'User deactivated'),
        ),
      );
    }
  }

  void _viewUserDetails(String userId) {
    // Navigate to user detail screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: const Text('Detailed user view coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class _TrustScoreBar extends StatelessWidget {
  final String label;
  final int score;
  final String level;

  const _TrustScoreBar({
    required this.label,
    required this.score,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    if (score >= 80) {
      color = Colors.green;
    } else if (score >= 60) {
      color = Colors.blue;
    } else if (score >= 40) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$score% - $level',
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
