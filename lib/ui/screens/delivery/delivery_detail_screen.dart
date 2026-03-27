import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/models/delivery.dart';
import '../../../data/models/donation.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';

class DeliveryDetailScreen extends ConsumerWidget {
  final String deliveryId;

  const DeliveryDetailScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryAsync = ref.watch(deliveryProvider(deliveryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
      ),
      body: deliveryAsync.when(
        data: (delivery) => _buildContent(context, ref, delivery),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, Delivery delivery) {
    final donationAsync = ref.watch(donationProvider(delivery.donationId));

    return donationAsync.when(
      data: (Donation donation) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusTimeline(delivery),
            const SizedBox(height: 24),
            _buildDonationInfo(donation),
            const SizedBox(height: 24),
            _buildDeliveryInfo(delivery),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error loading donation: $error')),
    );
  }

  Widget _buildStatusTimeline(Delivery delivery) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusStep(
              'Assigned',
              delivery.status.index >= DeliveryStatus.assigned.index,
              Icons.assignment,
            ),
            _buildStatusStep(
              'En Route to Pickup',
              delivery.status.index >= DeliveryStatus.enRoutePickup.index,
              Icons.directions_car,
            ),
            _buildStatusStep(
              'Picked Up',
              delivery.status.index >= DeliveryStatus.pickedUp.index,
              Icons.check_circle,
            ),
            _buildStatusStep(
              'En Route to Delivery',
              delivery.status.index >= DeliveryStatus.enRouteDelivery.index,
              Icons.local_shipping,
            ),
            _buildStatusStep(
              'Delivered',
              delivery.status == DeliveryStatus.delivered,
              Icons.done_all,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStep(String title, bool isCompleted, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isCompleted ? AppTheme.successColor : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: isCompleted ? AppTheme.successColor : Colors.grey,
              fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationInfo(Donation donation) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Donation Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Title', donation.title),
            _buildInfoRow('Category', donation.foodCategory.displayName),
            _buildInfoRow('Quantity', '${donation.quantity} ${donation.unit}'),
            _buildInfoRow(
              'Pickup Address',
              donation.pickupAddress,
            ),
            _buildInfoRow(
              'Pickup Time',
              DateFormat('MMM dd, yyyy HH:mm').format(donation.pickupStartTime),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(Delivery delivery) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Status', delivery.status.displayName),
            if (delivery.estimatedArrival != null)
              _buildInfoRow(
                'Estimated Arrival',
                DateFormat('MMM dd, yyyy HH:mm').format(delivery.estimatedArrival!),
              ),
            if (delivery.pickupTime != null)
              _buildInfoRow(
                'Picked Up At',
                DateFormat('MMM dd, yyyy HH:mm').format(delivery.pickupTime!),
              ),
            if (delivery.deliveryTime != null)
              _buildInfoRow(
                'Delivered At',
                DateFormat('MMM dd, yyyy HH:mm').format(delivery.deliveryTime!),
              ),
            if (delivery.notes != null && delivery.notes!.isNotEmpty)
              _buildInfoRow('Notes', delivery.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
