import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:appwrite/appwrite.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/providers.dart';
import '../../../appwrite_options.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/notification_badge.dart';
import 'analytics_dashboard.dart';
import 'user_management_screen.dart';
import 'reports_screen.dart';
import 'feedback_moderation_screen.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  int _currentIndex = 0;
  RealtimeSubscription? _donationsSubscription;
  RealtimeSubscription? _usersSubscription;
  RealtimeSubscription? _notificationsSubscription;
  RealtimeSubscription? _ngoRequestsSubscription;

  @override
  void initState() {
    super.initState();
    _setupRealtimeSubscriptions();
  }

  @override
  void dispose() {
    _donationsSubscription?.close();
    _usersSubscription?.close();
    _notificationsSubscription?.close();
    _ngoRequestsSubscription?.close();
    super.dispose();
  }

  void _setupRealtimeSubscriptions() {
    final realtime = ref.read(appwriteRealtimeProvider);

    // Subscribe to donations collection
    _donationsSubscription = realtime.subscribe([
      'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.donationsCollection}.documents',
    ]);

    _donationsSubscription!.stream.listen((response) {
      if (response.events.contains('databases.*.collections.*.documents.*')) {
        // Refresh donations data
        ref.invalidate(dashboardStatsProvider);
        ref.invalidate(donationsProvider(null));
      }
    });

    // Subscribe to user_profiles collection
    _usersSubscription = realtime.subscribe([
      'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.userProfilesCollection}.documents',
    ]);

    _usersSubscription!.stream.listen((response) {
      if (response.events.contains('databases.*.collections.*.documents.*')) {
        // Refresh user data
        ref.invalidate(userStatisticsProvider);
        ref.invalidate(allUsersProvider(null));
      }
    });

    // Subscribe to notifications collection for current user
    final userAsync = ref.read(currentUserProvider);
    userAsync.whenData((user) {
      if (user != null) {
        _notificationsSubscription = realtime.subscribe([
          'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.notificationsCollection}.documents',
        ]);

        _notificationsSubscription!.stream.listen((response) {
          if (response.events.contains(
            'databases.*.collections.*.documents.*',
          )) {
            // Refresh notifications
            ref.invalidate(notificationsProvider(user.$id));
            ref.invalidate(unreadNotificationCountProvider);
          }
        });
      }
    });

    // Subscribe to ngo_requests collection
    _ngoRequestsSubscription = realtime.subscribe([
      'databases.${AppwriteOptions.databaseId}.collections.ngo_requests.documents',
    ]);

    _ngoRequestsSubscription!.stream.listen((response) {
      if (response.events.contains('databases.*.collections.*.documents.*')) {
        // Refresh NGO requests data
        ref.invalidate(pendingNGORequestsProvider);
        ref.invalidate(ngoRequestsProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          const NotificationBadge(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildOverviewTab(),
          const UserManagementScreen(),
          _buildDonationsTab(),
          const AnalyticsDashboard(embedded: true),
          const ReportsScreen(),
          const FeedbackModerationScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final userStatsAsync = ref.watch(userStatisticsProvider);
    final pendingNGORequestsAsync = ref.watch(pendingNGORequestsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Overview',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          statsAsync.when(
            data: (stats) => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatsCard(
                  title: 'Total Donations',
                  value: stats.totalDonations.toString(),
                  icon: Icons.volunteer_activism,
                  color: AppTheme.primaryColor,
                ),
                StatsCard(
                  title: 'Pending',
                  value: stats.pendingDonations.toString(),
                  icon: Icons.pending_actions,
                  color: AppTheme.warningColor,
                ),
                StatsCard(
                  title: 'Delivered',
                  value: stats.deliveredDonations.toString(),
                  icon: Icons.check_circle,
                  color: AppTheme.successColor,
                ),
                StatsCard(
                  title: 'Active Volunteers',
                  value: stats.activeVolunteers.toString(),
                  icon: Icons.people,
                  color: AppTheme.accentColor,
                ),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          const SizedBox(height: 24),
          Text(
            'User Statistics',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          userStatsAsync.when(
            data: (userStats) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(
                      label: 'Total Users',
                      value: userStats['total'] ?? 0,
                    ),
                    _StatColumn(
                      label: 'Donors',
                      value: userStats['donor'] ?? 0,
                    ),
                    _StatColumn(
                      label: 'Recipients',
                      value: userStats['recipient'] ?? 0,
                    ),
                    _StatColumn(
                      label: 'Volunteers',
                      value: userStats['volunteer'] ?? 0,
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
          // NGO Requests Card
          pendingNGORequestsAsync.when(
            data: (requests) {
              if (requests.isNotEmpty) {
                return Card(
                  color: Colors.orange[100],
                  elevation: 2,
                  child: InkWell(
                    onTap: () => context.push('/admin/ngo-requests'),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${requests.length} Pending NGO Request${requests.length == 1 ? '' : 's'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[900],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap to review and approve/deny',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.orange[700],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
          Text(
            'Quick Actions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                label: const Text('NGO Requests'),
                avatar: const Icon(Icons.business, size: 18),
                onPressed: () => context.push('/admin/ngo-requests'),
              ),
              ActionChip(
                label: const Text('Generate Report'),
                avatar: const Icon(Icons.description, size: 18),
                onPressed: () => setState(() => _currentIndex = 4),
              ),
              ActionChip(
                label: const Text('Manage Users'),
                avatar: const Icon(Icons.people, size: 18),
                onPressed: () => setState(() => _currentIndex = 1),
              ),
              ActionChip(
                label: const Text('Moderate Feedback'),
                avatar: const Icon(Icons.feedback, size: 18),
                onPressed: () => setState(() => _currentIndex = 5),
              ),
              ActionChip(
                label: const Text('View Analytics'),
                avatar: const Icon(Icons.analytics, size: 18),
                onPressed: () => setState(() => _currentIndex = 3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsTab() {
    final donationsAsync = ref.watch(donationsProvider(null));

    return donationsAsync.when(
      data: (donations) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final donation = donations[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(donation.title),
              subtitle: Text('Status: ${donation.status.name}'),
              trailing: Text('${donation.quantity} ${donation.unit}'),
              onTap: () => context.push('/donations/${donation.id}'),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final int value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
