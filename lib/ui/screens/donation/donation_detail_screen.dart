import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';
import '../../../data/models/donation.dart';

class DonationDetailScreen extends ConsumerWidget {
  final String donationId;

  const DonationDetailScreen({super.key, required this.donationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donationAsync = ref.watch(donationProvider(donationId));
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Donation Details')),
      body: donationAsync.when(
        data: (donation) {
          return currentUserAsync.when(
            data: (currentUser) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Image Section
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      child: donation.images.isNotEmpty
                          ? Image.network(
                              donation.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildPlaceholderImage(donation.foodCategory),
                            )
                          : _buildPlaceholderImage(donation.foodCategory),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Status
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  donation.title,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildStatusChip(donation.status),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Category and Quantity
                          Row(
                            children: [
                              Icon(
                                _getCategoryIcon(donation.foodCategory),
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                donation.foodCategory.displayName,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              Text(
                                '${donation.quantity} ${donation.unit}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Description
                          _buildSectionTitle('Description'),
                          const SizedBox(height: 8),
                          Text(
                            donation.description ?? 'No description provided',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 24),

                          // Pickup Details
                          _buildSectionTitle('Pickup Details'),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.location_on,
                            'Location',
                            donation.pickupAddress,
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            Icons.access_time,
                            'Available',
                            '${DateFormat('MMM dd, yyyy').format(donation.expirationDate)} - ${DateFormat('HH:mm').format(donation.pickupStartTime)} to ${DateFormat('HH:mm').format(donation.pickupEndTime)}',
                          ),
                          const SizedBox(height: 24),

                          // Special Instructions
                          if (donation.specialInstructions != null &&
                              donation.specialInstructions!.isNotEmpty) ...[
                            _buildSectionTitle('Special Instructions'),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                donation.specialInstructions!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Assignment Status
                          _buildSectionTitle('Status'),
                          const SizedBox(height: 12),
                          if (donation.assignedVolunteerId != null)
                            _buildInfoRow(
                              Icons.person,
                              'Volunteer',
                              'Assigned',
                            ),
                          if (donation.assignedRecipientId != null)
                            _buildInfoRow(Icons.home, 'Recipient', 'Assigned'),
                          const SizedBox(height: 24),

                          // Action Buttons
                          if (currentUser != null) ...[
                            _buildActionButtons(
                              context,
                              ref,
                              donation,
                              currentUser.$id,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading user: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading donation: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(FoodCategory category) {
    return Center(
      child: Icon(
        _getCategoryIcon(category),
        size: 80,
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildStatusChip(DonationStatus status) {
    Color color;
    switch (status) {
      case DonationStatus.pending:
        color = AppTheme.successColor;
        break;
      case DonationStatus.assigned:
        color = Colors.orange;
        break;
      case DonationStatus.pickedUp:
        color = Colors.blue;
        break;
      case DonationStatus.delivered:
        color = AppTheme.primaryColor;
        break;
      case DonationStatus.cancelled:
        color = AppTheme.errorColor;
        break;
      case DonationStatus.expired:
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(value, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    Donation donation,
    String userId,
  ) {
    final userProfile = ref.watch(userProfileProvider).value;
    if (userProfile == null) return const SizedBox.shrink();

    final isVolunteer = userProfile.role == UserRole.volunteer;
    final isDonor = donation.donorId == userId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cancel Button (for donors)
        if (isDonor &&
            (donation.status == DonationStatus.pending ||
                donation.status == DonationStatus.assigned))
          ElevatedButton.icon(
            onPressed: () => _showCancelDialog(context, ref, donation.id),
            icon: const Icon(Icons.cancel),
            label: const Text('Cancel Donation'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppTheme.errorColor,
            ),
          ),

        // Mark as Picked Up (for volunteers)
        if (isVolunteer &&
            donation.assignedVolunteerId == userId &&
            donation.status == DonationStatus.assigned)
          ElevatedButton.icon(
            onPressed: () => _markAsPickedUp(context, ref, donation.id),
            icon: const Icon(Icons.check_circle),
            label: const Text('Mark as Picked Up'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.orange,
            ),
          ),

        // Mark as Delivered (for volunteers)
        if (isVolunteer &&
            donation.assignedVolunteerId == userId &&
            donation.status == DonationStatus.pickedUp)
          ElevatedButton.icon(
            onPressed: () => _markAsDelivered(context, ref, donation.id),
            icon: const Icon(Icons.done_all),
            label: const Text('Mark as Delivered'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppTheme.successColor,
            ),
          ),

        // Completion Message (when delivered)
        if (donation.status == DonationStatus.delivered)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.successColor),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This donation has been successfully delivered!',
                    style: TextStyle(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showCancelDialog(
    BuildContext context,
    WidgetRef ref,
    String donationId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Donation'),
        content: const Text(
          'Are you sure you want to cancel this donation? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelDonation(context, ref, donationId);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelDonation(
    BuildContext context,
    WidgetRef ref,
    String donationId,
  ) async {
    try {
      final userAsync = ref.read(currentUserProvider);
      final user = userAsync.value;
      if (user == null) return;

      await ref
          .read(donationRepositoryProvider)
          .cancelDonation(donationId, user.$id);

      // Invalidate providers to refresh data
      ref.invalidate(donationProvider(donationId));
      ref.invalidate(myDonationsProvider);
      ref.invalidate(availableDonationsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation cancelled successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _markAsPickedUp(
    BuildContext context,
    WidgetRef ref,
    String donationId,
  ) async {
    try {
      final userAsync = ref.read(currentUserProvider);
      final user = userAsync.value;
      if (user == null) return;

      // Show loading dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      await ref
          .read(donationRepositoryProvider)
          .markAsPickedUp(donationId, user.$id);

      // Invalidate providers to refresh data
      ref.invalidate(donationProvider(donationId));
      ref.invalidate(myDeliveriesProvider);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Marked as picked up successfully!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _markAsDelivered(
    BuildContext context,
    WidgetRef ref,
    String donationId,
  ) async {
    try {
      final userAsync = ref.read(currentUserProvider);
      final user = userAsync.value;
      if (user == null) return;

      // Show loading dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      await ref
          .read(donationRepositoryProvider)
          .markAsDelivered(donationId, user.$id);

      // Invalidate providers to refresh data
      ref.invalidate(donationProvider(donationId));
      ref.invalidate(myDeliveriesProvider);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Delivery completed successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  IconData _getCategoryIcon(FoodCategory category) {
    switch (category) {
      case FoodCategory.freshProduce:
        return Icons.eco;
      case FoodCategory.meat:
        return Icons.egg;
      case FoodCategory.dairy:
        return Icons.local_drink;
      case FoodCategory.bakery:
        return Icons.cake;
      case FoodCategory.prepared:
        return Icons.restaurant;
      case FoodCategory.canned:
        return Icons.inventory_2;
      case FoodCategory.other:
        return Icons.fastfood;
    }
  }
}
