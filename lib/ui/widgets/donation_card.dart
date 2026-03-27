import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/donation.dart';
import '../../data/models/delivery.dart';
import '../../data/repositories/ngo_request_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/enums/enums.dart';
import '../../providers/providers.dart';

class DonationCard extends ConsumerStatefulWidget {
  final Donation donation;
  final bool showAcceptButton;
  final bool showRequestButton;
  final bool showDeleteButton;
  final VoidCallback? onDelete;

  const DonationCard({
    super.key,
    required this.donation,
    this.showAcceptButton = false,
    this.showRequestButton = false,
    this.showDeleteButton = false,
    this.onDelete,
  });

  @override
  ConsumerState<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends ConsumerState<DonationCard> {
  bool _isAccepting = false;
  bool _isRequesting = false;
  bool _hasRequested = false;

  @override
  void initState() {
    super.initState();
    if (widget.showRequestButton) {
      _checkIfAlreadyRequested();
    }
  }

  Future<void> _checkIfAlreadyRequested() async {
    final userAsync = ref.read(currentUserProvider);
    final user = userAsync.value;
    if (user == null) return;

    try {
      final isDuplicate = await ref
          .read(ngoRequestRepositoryProvider)
          .checkDuplicateRequest(
            ngoId: user.$id,
            donationId: widget.donation.id,
          );

      if (mounted) {
        setState(() => _hasRequested = isDuplicate);
      }
    } catch (e) {
      // Ignore errors in duplicate check
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

  Future<void> _acceptDelivery(BuildContext context) async {
    // Prevent double-clicks
    if (_isAccepting) return;

    try {
      setState(() => _isAccepting = true);

      final userAsync = ref.read(currentUserProvider);
      final user = userAsync.value;
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please log in to accept deliveries'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
        return;
      }

      // Check if donation is already assigned to prevent duplicate accepts
      if (widget.donation.assignedVolunteerId != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This delivery has already been accepted'),
              backgroundColor: AppTheme.warningColor,
            ),
          );
        }
        return;
      }

      // Show loading dialog
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      // First, assign volunteer to donation (this will fail if already assigned)
      await ref
          .read(donationRepositoryProvider)
          .assignVolunteer(widget.donation.id, user.$id);

      // Always create delivery when volunteer accepts, regardless of recipient status
      // This ensures volunteers can see their accepted donations in "My Deliveries"
      try {
        final delivery = Delivery(
          id: '', // Will be set by database
          donationId: widget.donation.id,
          volunteerId: user.$id,
          recipientId:
              widget.donation.assignedRecipientId, // Can be null initially
          status: DeliveryStatus.assigned,
          estimatedArrival: widget.donation.pickupStartTime.add(
            const Duration(hours: 1),
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await ref.read(deliveryRepositoryProvider).createDelivery(delivery);
      } catch (deliveryError) {
        // If delivery creation fails, log it but don't fail the entire operation
        // The volunteer assignment was successful, so we continue
      }

      // Invalidate providers to force refetch
      ref.invalidate(donationProvider(widget.donation.id));
      ref.invalidate(availableDonationsProvider);
      ref.invalidate(myDeliveriesProvider);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        final message = 'Delivery accepted successfully!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accepting delivery: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAccepting = false);
      }
    }
  }

  Future<void> _requestDonation(BuildContext context) async {
    // Prevent double-clicks
    if (_isRequesting || _hasRequested) return;

    setState(() => _isRequesting = true);

    try {
      final userAsync = ref.read(currentUserProvider);
      final user = userAsync.value;
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please log in to request donations'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
        setState(() => _isRequesting = false);
        return;
      }

      // Get user profile to get NGO name and delivery address
      final userProfile = await ref
          .read(authRepositoryProvider)
          .getUserProfile(user.$id);
      if (userProfile == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to load your profile'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
        setState(() => _isRequesting = false);
        return;
      }

      // Create NGO request linked to this donation
      await ref
          .read(ngoRequestRepositoryProvider)
          .createRequest(
            ngoId: user.$id,
            ngoName: userProfile.fullName,
            title: 'Request for: ${widget.donation.title}',
            description:
                'Requesting ${widget.donation.quantity} ${widget.donation.unit} of ${widget.donation.foodCategory.displayName}. ${widget.donation.description ?? ""}',
            foodCategory: widget.donation.foodCategory,
            quantity: widget.donation.quantity,
            unit: widget.donation.unit,
            deliveryAddress: userProfile.address ?? 'Address not set',
            neededBy: widget.donation.expirationDate,
            donationId: widget.donation.id, // Link to specific donation
          );

      // Invalidate providers to force refetch
      ref.invalidate(donationProvider(widget.donation.id));
      ref.invalidate(availableDonationsProvider);
      ref.invalidate(
        hasPendingRequestForDonationProvider((
          userId: user.$id,
          donationId: widget.donation.id,
        )),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request submitted successfully'),
            backgroundColor: AppTheme.successColor,
            duration: Duration(seconds: 3),
          ),
        );
      }

      setState(() {
        _hasRequested = true;
        _isRequesting = false;
      });
    } on DuplicateRequestException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.orange),
        );
      }
      setState(() {
        _hasRequested = true;
        _isRequesting = false;
      });
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to submit request. Please try again.'),
            backgroundColor: AppTheme.errorColor,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _requestDonation(context),
            ),
          ),
        );
      }
      setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.value;

    // Watch the specific donation to get live updates
    final donationAsync = ref.watch(donationProvider(widget.donation.id));

    // Use the refreshed donation data, or fall back to the original if loading
    final currentDonation =
        donationAsync.whenOrNull(
          data: (d) => d,
          loading: () => null,
          error: (e, st) => null,
        ) ??
        widget.donation;

    final daysUntilExpiry = currentDonation.expirationDate
        .difference(DateTime.now())
        .inDays;
    final isExpiringSoon = daysUntilExpiry <= 2 && daysUntilExpiry >= 0;

    // Check if donation is already accepted by a volunteer
    final isAccepted = currentDonation.assignedVolunteerId != null;
    final isAcceptedByCurrentUser =
        currentUser != null &&
        currentDonation.assignedVolunteerId == currentUser.$id;
    final isAcceptedByOther = isAccepted && !isAcceptedByCurrentUser;

    // Check if donation is already requested by a recipient
    final isRequested = currentDonation.assignedRecipientId != null;
    final isRequestedByCurrentUser =
        currentUser != null &&
        currentDonation.assignedRecipientId == currentUser.$id;
    final isRequestedByOther = isRequested && !isRequestedByCurrentUser;

    // Check if current user has a pending NGO request for this donation
    final hasPendingRequestAsync = currentUser != null
        ? ref.watch(
            hasPendingRequestForDonationProvider((
              userId: currentUser.$id,
              donationId: currentDonation.id,
            )),
          )
        : const AsyncValue.data(false);

    final hasPendingRequest = hasPendingRequestAsync.value ?? false;

    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => context.push('/donation/${currentDonation.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(currentDonation.foodCategory),
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentDonation.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${currentDonation.quantity} ${currentDonation.unit} • ${currentDonation.foodCategory.displayName}',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: AppConstraints.donationCardCategoryMaxWidth,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        currentDonation.status,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentDonation.status.displayName,
                      style: TextStyle(
                        color: _getStatusColor(currentDonation.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      currentDonation.pickupAddress,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Pickup: ${DateFormat('MMM dd, HH:mm').format(currentDonation.pickupStartTime)}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const Spacer(),
                  if (isExpiringSoon)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        daysUntilExpiry == 0
                            ? 'Expires today!'
                            : 'Expires in $daysUntilExpiry days',
                        style: const TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              if (widget.showAcceptButton ||
                  widget.showRequestButton ||
                  widget.showDeleteButton) ...[
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    if (widget.showAcceptButton)
                      Expanded(
                        child: isAcceptedByCurrentUser
                            ? ElevatedButton.icon(
                                onPressed: null, // Disabled
                                icon: const Icon(Icons.check_circle, size: 18),
                                label: const Text('Accepted'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                  backgroundColor: AppTheme.successColor,
                                  foregroundColor: Colors.white,
                                ),
                              )
                            : isAcceptedByOther
                            ? ElevatedButton.icon(
                                onPressed: null, // Disabled
                                icon: const Icon(Icons.block, size: 18),
                                label: const Text('Already Accepted'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white70,
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: _isAccepting
                                    ? null
                                    : () => _acceptDelivery(context),
                                icon: _isAccepting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Icon(Icons.check, size: 18),
                                label: Text(
                                  _isAccepting
                                      ? 'Accepting...'
                                      : 'Accept Delivery',
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                ),
                              ),
                      ),
                    if (widget.showRequestButton)
                      Expanded(
                        child:
                            _hasRequested ||
                                hasPendingRequest ||
                                isRequestedByCurrentUser
                            ? ElevatedButton.icon(
                                onPressed: null, // Disabled
                                icon: const Icon(Icons.check_circle, size: 18),
                                label: Text(
                                  _hasRequested || isRequestedByCurrentUser
                                      ? 'Already Requested'
                                      : 'Pending Review',
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                  backgroundColor: hasPendingRequest
                                      ? Colors.orange
                                      : Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                              )
                            : isRequestedByOther
                            ? ElevatedButton.icon(
                                onPressed: null, // Disabled
                                icon: const Icon(Icons.block, size: 18),
                                label: const Text('Already Requested'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white70,
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: _isRequesting
                                    ? null
                                    : () => _requestDonation(context),
                                icon: _isRequesting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Icon(Icons.add, size: 18),
                                label: Text(
                                  _isRequesting ? 'Requesting...' : 'Request',
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                ),
                              ),
                      ),
                    if (widget.showDeleteButton) ...[
                      if (widget.showAcceptButton || widget.showRequestButton)
                        SizedBox(width: AppSpacing.sm),
                      IconButton(
                        onPressed: widget.onDelete,
                        icon: Icon(
                          Icons.delete,
                          color: AppTheme.errorColor,
                          size: AppIconSize.md,
                        ),
                        tooltip: 'Delete Donation',
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.errorColor.withValues(
                            alpha: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(FoodCategory category) {
    switch (category) {
      case FoodCategory.freshProduce:
        return Icons.eco;
      case FoodCategory.dairy:
        return Icons.egg;
      case FoodCategory.meat:
        return Icons.restaurant;
      case FoodCategory.bakery:
        return Icons.bakery_dining;
      case FoodCategory.canned:
        return Icons.inventory_2;
      case FoodCategory.prepared:
        return Icons.lunch_dining;
      case FoodCategory.other:
        return Icons.fastfood;
    }
  }
}
