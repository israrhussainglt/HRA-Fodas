import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:appwrite/appwrite.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';
import '../../../appwrite_options.dart';
import '../../widgets/donation_card.dart';
import '../../widgets/stats_card.dart';
import '../../widgets/notification_badge.dart';
import '../meal_planner/meal_planner_screen.dart';

class DonorDashboard extends ConsumerStatefulWidget {
  const DonorDashboard({super.key});

  @override
  ConsumerState<DonorDashboard> createState() => _DonorDashboardState();
}

class _DonorDashboardState extends ConsumerState<DonorDashboard> {
  int _currentIndex = 0;
  String _searchQuery = '';
  DonationStatus? _selectedStatus;
  RealtimeSubscription? _donationsSubscription;
  RealtimeSubscription? _notificationsSubscription;

  @override
  void initState() {
    super.initState();
    _setupRealtimeSubscriptions();
  }

  @override
  void dispose() {
    _donationsSubscription?.close();
    _notificationsSubscription?.close();
    super.dispose();
  }

  void _setupRealtimeSubscriptions() {
    final realtime = ref.read(appwriteRealtimeProvider);

    // Subscribe to donations collection with error handling
    try {
      _donationsSubscription = realtime.subscribe([
        'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.donationsCollection}.documents',
      ]);

      _donationsSubscription!.stream.listen(
        (response) {
          if (response.events.contains(
            'databases.*.collections.*.documents.*',
          )) {
            // Refresh donations data
            ref.invalidate(myDonationsProvider);
          }
        },
        onError: (error) {
          // Silently handle realtime errors - connection will auto-reconnect
        },
        cancelOnError: false,
      );
    } catch (e) {
      // Ignore subscription errors
    }

    // Subscribe to notifications with error handling
    final userAsync = ref.read(currentUserProvider);
    userAsync.whenData((user) {
      if (user != null) {
        try {
          _notificationsSubscription = realtime.subscribe([
            'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.notificationsCollection}.documents',
          ]);

          _notificationsSubscription!.stream.listen(
            (response) {
              if (response.events.contains(
                'databases.*.collections.*.documents.*',
              )) {
                ref.invalidate(notificationsProvider(user.$id));
                ref.invalidate(unreadNotificationCountProvider);
              }
            },
            onError: (error) {
              // Silently handle realtime errors - connection will auto-reconnect
            },
            cancelOnError: false,
          );
        } catch (e) {
          // Ignore subscription errors
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final myDonations = ref.watch(myDonationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Dashboard'),
        actions: [
          const NotificationBadge(),
          IconButton(
            icon: const Icon(Icons.person_outlined),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(userProfile, myDonations),
          _buildDonationsTab(myDonations),
          _buildHistoryTab(),
          _buildChatTab(),
        ],
      ),
      floatingActionButton: _currentIndex == 3
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push('/donation/create'),
              icon: const Icon(Icons.add),
              label: const Text('New Donation'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Donations',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meal Planner',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(AsyncValue userProfile, AsyncValue myDonations) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myDonationsProvider);
        ref.invalidate(userProfileProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userProfile.when(
              data: (profile) => Text(
                'Welcome, ${profile?.fullName ?? 'Donor'}!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: StatsCard(
                    title: 'Total Donations',
                    value: myDonations.when(
                      data: (list) => list.length.toString(),
                      loading: () => '-',
                      error: (e, s) => '0',
                    ),
                    icon: Icons.volunteer_activism,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatsCard(
                    title: 'Delivered',
                    value: myDonations.when(
                      data: (list) => list
                          .where((d) => d.status == DonationStatus.delivered)
                          .length
                          .toString(),
                      loading: () => '-',
                      error: (e, s) => '0',
                    ),
                    icon: Icons.check_circle,
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Donations',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            myDonations.when(
              data: (donations) {
                if (donations.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.volunteer_activism,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No donations yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap the button below to create your first donation!',
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  children: donations
                      .take(5)
                      .map<Widget>(
                        (donation) => DonationCard(
                          donation: donation,
                          showDeleteButton: true,
                          onDelete: () =>
                              _showDeleteDialog(context, donation.id),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationsTab(AsyncValue myDonations) {
    return Column(
      children: [
        // Search and Filter Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search donations...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _selectedStatus == null,
                      onSelected: (selected) {
                        setState(() => _selectedStatus = null);
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Pending'),
                      selected: _selectedStatus == DonationStatus.pending,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = selected
                              ? DonationStatus.pending
                              : null;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Assigned'),
                      selected: _selectedStatus == DonationStatus.assigned,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = selected
                              ? DonationStatus.assigned
                              : null;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Picked Up'),
                      selected: _selectedStatus == DonationStatus.pickedUp,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = selected
                              ? DonationStatus.pickedUp
                              : null;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Delivered'),
                      selected: _selectedStatus == DonationStatus.delivered,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = selected
                              ? DonationStatus.delivered
                              : null;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Cancelled'),
                      selected: _selectedStatus == DonationStatus.cancelled,
                      onSelected: (selected) {
                        setState(() {
                          _selectedStatus = selected
                              ? DonationStatus.cancelled
                              : null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Donations List
        Expanded(
          child: myDonations.when(
            data: (donations) {
              // Apply filters
              var filteredDonations = donations.where((d) {
                final matchesSearch =
                    _searchQuery.isEmpty ||
                    d.title.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    d.pickupAddress.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    );
                final matchesStatus =
                    _selectedStatus == null || d.status == _selectedStatus;
                return matchesSearch && matchesStatus;
              }).toList();

              if (filteredDonations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty || _selectedStatus != null
                            ? 'No donations match your filters'
                            : 'No donations yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (_searchQuery.isNotEmpty ||
                          _selectedStatus != null) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _selectedStatus = null;
                            });
                          },
                          child: const Text('Clear filters'),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(myDonationsProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDonations.length,
                  itemBuilder: (context, index) => DonationCard(
                    donation: filteredDonations[index],
                    showDeleteButton: true,
                    onDelete: () =>
                        _showDeleteDialog(context, filteredDonations[index].id),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref.invalidate(myDonationsProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    final myDonations = ref.watch(myDonationsProvider);

    return myDonations.when(
      data: (donations) {
        // Filter for completed donations (delivered, cancelled, expired)
        final completedDonations = donations
            .where(
              (d) =>
                  d.status == DonationStatus.delivered ||
                  d.status == DonationStatus.cancelled ||
                  d.status == DonationStatus.expired,
            )
            .toList();

        // Sort by most recent first
        completedDonations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (completedDonations.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(myDonationsProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[600]),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'No donation history yet',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Completed donations will appear here',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myDonationsProvider);
          },
          child: Column(
            children: [
              // Header with count
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Donation History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${completedDonations.length} completed donation${completedDonations.length == 1 ? '' : 's'}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              // History list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: completedDonations.length,
                  itemBuilder: (context, index) {
                    final donation = completedDonations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => context.push('/donation/${donation.id}'),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        donation.status,
                                      ).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getStatusIcon(donation.status),
                                      color: _getStatusColor(donation.status),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          donation.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${donation.quantity} ${donation.unit} • ${donation.foodCategory.displayName}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        donation.status,
                                      ).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      donation.status.displayName,
                                      style: TextStyle(
                                        color: _getStatusColor(donation.status),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      donation.pickupAddress,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Created: ${_formatDate(donation.createdAt)}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading history',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(myDonationsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return const MealPlannerScreen(embedded: true);
  }

  void _showDeleteDialog(BuildContext context, String donationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Donation'),
        content: const Text(
          'Are you sure you want to delete this donation? This will permanently remove it and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDonation(context, donationId);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDonation(BuildContext context, String donationId) async {
    try {
      final userAsync = ref.read(currentUserProvider);
      final user = userAsync.value;
      if (user == null) return;

      await ref
          .read(donationRepositoryProvider)
          .deleteDonation(donationId, user.$id);

      ref.invalidate(myDonationsProvider);
      ref.invalidate(availableDonationsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation deleted successfully'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting donation: $e'),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Color _getStatusColor(DonationStatus status) {
    switch (status) {
      case DonationStatus.pending:
        return Colors.grey;
      case DonationStatus.assigned:
        return Colors.blue;
      case DonationStatus.pickedUp:
        return Colors.orange;
      case DonationStatus.delivered:
        return AppTheme.successColor;
      case DonationStatus.cancelled:
      case DonationStatus.expired:
        return AppTheme.errorColor;
    }
  }

  IconData _getStatusIcon(DonationStatus status) {
    switch (status) {
      case DonationStatus.pending:
        return Icons.schedule;
      case DonationStatus.assigned:
        return Icons.person;
      case DonationStatus.pickedUp:
        return Icons.local_shipping;
      case DonationStatus.delivered:
        return Icons.check_circle;
      case DonationStatus.cancelled:
        return Icons.cancel;
      case DonationStatus.expired:
        return Icons.access_time_filled;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    }
  }
}
