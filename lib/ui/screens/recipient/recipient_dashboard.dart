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
import 'inventory_screen.dart';
import '../meal_planner/meal_planner_screen.dart';

class RecipientDashboard extends ConsumerStatefulWidget {
  const RecipientDashboard({super.key});

  @override
  ConsumerState<RecipientDashboard> createState() => _RecipientDashboardState();
}

class _RecipientDashboardState extends ConsumerState<RecipientDashboard> {
  int _currentIndex = 0;
  String _searchQuery = '';
  FoodCategory? _selectedCategory;
  RealtimeSubscription? _donationsSubscription;
  RealtimeSubscription? _notificationsSubscription;
  RealtimeSubscription? _inventorySubscription;

  @override
  void initState() {
    super.initState();
    _setupRealtimeSubscriptions();
  }

  @override
  void dispose() {
    _donationsSubscription?.close();
    _notificationsSubscription?.close();
    _inventorySubscription?.close();
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
        ref.invalidate(availableDonationsProvider);
      }
    });

    // Subscribe to inventory collection
    _inventorySubscription = realtime.subscribe([
      'databases.${AppwriteOptions.databaseId}.collections.${AppwriteOptions.inventoryCollection}.documents',
    ]);

    _inventorySubscription!.stream.listen((response) {
      if (response.events.contains('databases.*.collections.*.documents.*')) {
        // Refresh inventory data
        final userAsync = ref.read(currentUserProvider);
        userAsync.whenData((user) {
          if (user != null) {
            ref.invalidate(inventoryProvider(user.$id));
            ref.invalidate(expiringItemsProvider(user.$id));
          }
        });
      }
    });

    // Subscribe to notifications
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
            ref.invalidate(notificationsProvider(user.$id));
            ref.invalidate(unreadNotificationCountProvider);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final availableDonations = ref.watch(availableDonationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () => context.push('/conversations'),
          ),
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
          _buildHomeTab(userProfile, availableDonations),
          _buildBrowseTab(availableDonations),
          _buildInventoryTab(),
          _buildIncomingTab(),
          const MealPlannerScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Incoming',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meal Planner',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(AsyncValue userProfile, AsyncValue availableDonations) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(availableDonationsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userProfile.when(
              data: (profile) => Text(
                'Welcome, ${profile?.fullName ?? 'Organization'}!',
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
                    title: 'Available',
                    value: availableDonations.when(
                      data: (list) => list.length.toString(),
                      loading: () => '-',
                      error: (e, s) => '0',
                    ),
                    icon: Icons.volunteer_activism,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: StatsCard(
                    title: 'Inventory Items',
                    value: '0',
                    icon: Icon(Icons.inventory),
                    color: AppTheme.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Available Donations',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            availableDonations.when(
              data: (donations) {
                if (donations.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(height: 16),
                          const Text('No available donations'),
                        ],
                      ),
                    ),
                  );
                }
                return Column(
                  children: donations
                      .take(5)
                      .map<Widget>(
                        (d) =>
                            DonationCard(donation: d, showRequestButton: true),
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

  Widget _buildBrowseTab(AsyncValue availableDonations) {
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
                      selected: _selectedCategory == null,
                      onSelected: (selected) {
                        setState(() => _selectedCategory = null);
                      },
                    ),
                    const SizedBox(width: 8),
                    ...FoodCategory.values.map(
                      (category) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category.displayName),
                          selected: _selectedCategory == category,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : null;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Donations List
        Expanded(
          child: availableDonations.when(
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
                final matchesCategory =
                    _selectedCategory == null ||
                    d.foodCategory == _selectedCategory;
                return matchesSearch && matchesCategory;
              }).toList();

              if (filteredDonations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isNotEmpty || _selectedCategory != null
                            ? 'No donations match your filters'
                            : 'No available donations',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (_searchQuery.isNotEmpty ||
                          _selectedCategory != null) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _selectedCategory = null;
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
                  ref.invalidate(availableDonationsProvider);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDonations.length,
                  itemBuilder: (context, index) => DonationCard(
                    donation: filteredDonations[index],
                    showRequestButton: true,
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
                    onPressed: () => ref.invalidate(availableDonationsProvider),
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

  Widget _buildInventoryTab() {
    return const InventoryScreen(embedded: true);
  }

  Widget _buildIncomingTab() {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Please log in'));
        }

        // Get donations assigned to this recipient
        final assignedDonationsAsync = ref.watch(availableDonationsProvider);

        return assignedDonationsAsync.when(
          data: (allDonations) {
            // Filter donations assigned to this recipient
            final incomingDonations = allDonations
                .where((d) => d.assignedRecipientId == user.$id)
                .toList();

            // Sort by status priority: assigned > picked_up > delivered
            incomingDonations.sort((a, b) {
              final statusPriority = {
                DonationStatus.assigned: 1,
                DonationStatus.pickedUp: 2,
                DonationStatus.delivered: 3,
              };
              return (statusPriority[a.status] ?? 99).compareTo(
                statusPriority[b.status] ?? 99,
              );
            });

            if (incomingDonations.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(availableDonationsProvider);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Incoming Deliveries',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Request donations from the Browse tab',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => setState(() => _currentIndex = 1),
                            icon: const Icon(Icons.search),
                            label: const Text('Browse Donations'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(availableDonationsProvider);
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: incomingDonations.length,
                itemBuilder: (context, index) {
                  final donation = incomingDonations[index];
                  return _buildIncomingDeliveryCard(donation);
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading deliveries: $error'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(availableDonationsProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildIncomingDeliveryCard(donation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/donation/${donation.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
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
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        donation.status,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(donation.status),
                      style: TextStyle(
                        color: _getStatusColor(donation.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Pickup location
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'From: ${donation.pickupAddress}',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Volunteer info if assigned
              if (donation.assignedVolunteerId != null) ...[
                const SizedBox(height: 8),
                FutureBuilder(
                  future: ref
                      .read(authRepositoryProvider)
                      .getUserProfile(donation.assignedVolunteerId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[500]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Volunteer: ${snapshot.data!.fullName}',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),

              // Status timeline
              _buildStatusTimeline(donation.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusTimeline(DonationStatus status) {
    final steps = [
      {'label': 'Assigned', 'status': DonationStatus.assigned},
      {'label': 'Picked Up', 'status': DonationStatus.pickedUp},
      {'label': 'Delivered', 'status': DonationStatus.delivered},
    ];

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line
          final stepIndex = index ~/ 2;
          final isCompleted =
              status.index >
              (steps[stepIndex]['status'] as DonationStatus).index;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? AppTheme.successColor : Colors.grey[300],
            ),
          );
        } else {
          // Step circle
          final stepIndex = index ~/ 2;
          final stepStatus = steps[stepIndex]['status'] as DonationStatus;
          final isCompleted = status.index >= stepStatus.index;
          final isCurrent = status == stepStatus;

          return Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted ? AppTheme.successColor : Colors.grey[300],
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(color: AppTheme.successColor, width: 3)
                      : null,
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIndex]['label'] as String,
                style: TextStyle(
                  fontSize: 11,
                  color: isCompleted ? AppTheme.successColor : Colors.grey[500],
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  Color _getStatusColor(DonationStatus status) {
    switch (status) {
      case DonationStatus.assigned:
        return Colors.blue;
      case DonationStatus.pickedUp:
        return Colors.orange;
      case DonationStatus.delivered:
        return AppTheme.successColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(DonationStatus status) {
    switch (status) {
      case DonationStatus.assigned:
        return Icons.assignment_turned_in;
      case DonationStatus.pickedUp:
        return Icons.local_shipping;
      case DonationStatus.delivered:
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _getStatusText(DonationStatus status) {
    switch (status) {
      case DonationStatus.assigned:
        return 'Volunteer Assigned';
      case DonationStatus.pickedUp:
        return 'On The Way';
      case DonationStatus.delivered:
        return 'Delivered';
      default:
        return status.displayName;
    }
  }
}
