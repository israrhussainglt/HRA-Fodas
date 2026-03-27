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
import 'volunteer_map_screen.dart';

class VolunteerDashboard extends ConsumerStatefulWidget {
  const VolunteerDashboard({super.key});

  @override
  ConsumerState<VolunteerDashboard> createState() => _VolunteerDashboardState();
}

class _VolunteerDashboardState extends ConsumerState<VolunteerDashboard> {
  int _currentIndex = 0;
  String _searchQuery = '';
  FoodCategory? _selectedCategory;
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
        title: const Text('Volunteer Dashboard'),
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
          _buildHomeTab(userProfile, availableDonations),
          _buildAvailableTab(availableDonations),
          _buildMyDeliveriesTab(),
          _buildMapTab(),
          const MealPlannerScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Available',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'My Deliveries',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
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
                'Welcome, ${profile?.fullName ?? 'Volunteer'}!',
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
                    title: 'Completed',
                    value: '0',
                    icon: Icon(Icons.check_circle),
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Nearby Donations',
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
                          const Text('No available donations nearby'),
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
                            DonationCard(donation: d, showAcceptButton: true),
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

  Widget _buildAvailableTab(AsyncValue availableDonations) {
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
                    showAcceptButton: true,
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

  Widget _buildMyDeliveriesTab() {
    final myDeliveries = ref.watch(myDeliveriesProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myDeliveriesProvider);
      },
      child: myDeliveries.when(
        data: (deliveries) {
          if (deliveries.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(32),
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  size: 64,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'No active deliveries',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Accept a delivery to see it here',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              final delivery = deliveries[index];
              // Fetch the donation for this delivery
              final donationAsync = ref.watch(
                donationProvider(delivery.donationId),
              );

              return donationAsync.when(
                data: (donation) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () =>
                        context.push('/donation/${delivery.donationId}'),
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
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.local_shipping,
                                  color: AppTheme.primaryColor,
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
                                      '${donation.quantity} ${donation.unit}',
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
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDonationStatusColor(
                                    donation.status,
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  donation.status.displayName,
                                  style: TextStyle(
                                    color: _getDonationStatusColor(
                                      donation.status,
                                    ),
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
                                    color: Colors.grey[400],
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                loading: () => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, _) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.error, color: Colors.red),
                    title: Text('Error loading delivery'),
                    subtitle: Text(
                      'Delivery ID: ${delivery.id.substring(0, 8)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () =>
                        context.push('/donation/${delivery.donationId}'),
                  ),
                ),
              );
            },
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
                'Error loading deliveries',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(myDeliveriesProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDonationStatusColor(DonationStatus status) {
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

  Widget _buildMapTab() {
    return const VolunteerMapScreen();
  }
}
