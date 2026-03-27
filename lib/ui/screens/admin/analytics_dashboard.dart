import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/providers.dart';
import '../../../data/models/analytics_data.dart';

class AnalyticsDashboard extends ConsumerWidget {
  final bool embedded;

  const AnalyticsDashboard({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final categoryAsync = ref.watch(categoryDistributionProvider);
    final volunteersAsync = ref.watch(topVolunteersProvider);

    final content = RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(dashboardStatsProvider);
        ref.invalidate(categoryDistributionProvider);
        ref.invalidate(topVolunteersProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Overview
            statsAsync.when(
              data: (stats) => _StatsOverview(stats: stats),
              loading: () => const _LoadingCard(height: 200),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
            const SizedBox(height: 24),

            // Impact Metrics
            const Text(
              'Impact Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            statsAsync.when(
              data: (stats) => _ImpactMetrics(stats: stats),
              loading: () => const _LoadingCard(height: 120),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
            const SizedBox(height: 24),

            // Category Distribution
            const Text(
              'Food Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            categoryAsync.when(
              data: (categories) =>
                  _CategoryDistributionCard(categories: categories),
              loading: () => const _LoadingCard(height: 200),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
            const SizedBox(height: 24),

            // Top Volunteers
            const Text(
              'Top Volunteers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            volunteersAsync.when(
              data: (volunteers) => _TopVolunteersCard(volunteers: volunteers),
              loading: () => const _LoadingCard(height: 200),
              error: (e, _) => _ErrorCard(message: e.toString()),
            ),
          ],
        ),
      ),
    );

    if (embedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard')),
      body: content,
    );
  }
}

class _StatsOverview extends StatelessWidget {
  final DashboardStats stats;

  const _StatsOverview({required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _StatCard(
          title: 'Total Donations',
          value: stats.totalDonations.toString(),
          icon: Icons.volunteer_activism,
          color: Colors.green,
        ),
        _StatCard(
          title: 'Pending',
          value: stats.pendingDonations.toString(),
          icon: Icons.pending_actions,
          color: Colors.orange,
        ),
        _StatCard(
          title: 'Delivered',
          value: stats.deliveredDonations.toString(),
          icon: Icons.check_circle,
          color: Colors.blue,
        ),
        _StatCard(
          title: 'Active Volunteers',
          value: stats.activeVolunteers.toString(),
          icon: Icons.people,
          color: Colors.purple,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 24),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactMetrics extends StatelessWidget {
  final DashboardStats stats;

  const _ImpactMetrics({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _ImpactItem(
              icon: Icons.restaurant,
              value: '${stats.mealsProvided}',
              label: 'Meals Provided',
            ),
            _ImpactItem(
              icon: Icons.scale,
              value: '${stats.totalFoodSaved.toStringAsFixed(1)} kg',
              label: 'Food Saved',
            ),
            _ImpactItem(
              icon: Icons.eco,
              value: '${stats.co2Saved.toStringAsFixed(1)} kg',
              label: 'CO₂ Saved',
            ),
          ],
        ),
      ),
    );
  }
}

class _ImpactItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _ImpactItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class _CategoryDistributionCard extends StatelessWidget {
  final List<CategoryDistribution> categories;

  const _CategoryDistributionCard({required this.categories});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No data available')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      cat.category,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: cat.percentage / 100,
                        minHeight: 20,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${cat.percentage.toStringAsFixed(1)}%',
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TopVolunteersCard extends StatelessWidget {
  final List<VolunteerPerformance> volunteers;

  const _TopVolunteersCard({required this.volunteers});

  @override
  Widget build(BuildContext context) {
    if (volunteers.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No volunteer data available')),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: volunteers.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final volunteer = volunteers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: index < 3 ? Colors.amber : Colors.grey[300],
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: index < 3 ? Colors.white : Colors.black,
                ),
              ),
            ),
            title: Text(volunteer.volunteerName),
            subtitle: Text('${volunteer.totalDeliveries} deliveries'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (volunteer.averageRating > 0) ...[
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(volunteer.averageRating.toStringAsFixed(1)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final double height;

  const _LoadingCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;

  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text('Error: $message')),
          ],
        ),
      ),
    );
  }
}
