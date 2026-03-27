import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:intl/intl.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';
import '../../../appwrite_options.dart';
import '../../../data/models/ngo_request.dart';

class NGORequestsScreen extends ConsumerStatefulWidget {
  const NGORequestsScreen({super.key});

  @override
  ConsumerState<NGORequestsScreen> createState() => _NGORequestsScreenState();
}

class _NGORequestsScreenState extends ConsumerState<NGORequestsScreen> {
  NGORequestStatus? _selectedStatus;
  RealtimeSubscription? _ngoRequestsSubscription;

  @override
  void initState() {
    super.initState();
    _setupRealtimeSubscriptions();
  }

  @override
  void dispose() {
    _ngoRequestsSubscription?.close();
    super.dispose();
  }

  void _setupRealtimeSubscriptions() {
    final realtime = ref.read(appwriteRealtimeProvider);

    // Subscribe to ngo_requests collection
    _ngoRequestsSubscription = realtime.subscribe([
      'databases.${AppwriteOptions.databaseId}.collections.ngo_requests.documents',
    ]);

    _ngoRequestsSubscription!.stream.listen((response) {
      if (response.events.contains('databases.*.collections.*.documents.*')) {
        // Refresh NGO requests data
        ref.invalidate(ngoRequestsProvider);
        ref.invalidate(pendingNGORequestsProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ngoRequests = ref.watch(ngoRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NGO Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(ngoRequestsProvider);
              ref.invalidate(pendingNGORequestsProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
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
                    selected: _selectedStatus == NGORequestStatus.pending,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected
                            ? NGORequestStatus.pending
                            : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Approved'),
                    selected: _selectedStatus == NGORequestStatus.approved,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected
                            ? NGORequestStatus.approved
                            : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Denied'),
                    selected: _selectedStatus == NGORequestStatus.denied,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected
                            ? NGORequestStatus.denied
                            : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Converted'),
                    selected: _selectedStatus == NGORequestStatus.converted,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected
                            ? NGORequestStatus.converted
                            : null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Requests list
          Expanded(
            child: ngoRequests.when(
              data: (requests) {
                // Apply filter
                var filteredRequests = requests;
                if (_selectedStatus != null) {
                  filteredRequests = requests
                      .where((r) => r.status == _selectedStatus)
                      .toList();
                }

                if (filteredRequests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedStatus != null
                              ? 'No ${_selectedStatus!.displayName.toLowerCase()} requests'
                              : 'No NGO requests yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(ngoRequestsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = filteredRequests[index];
                      return _buildRequestCard(context, request);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => ref.invalidate(ngoRequestsProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, NGORequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${request.ngoName}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                      request.status,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status.displayName,
                    style: TextStyle(
                      color: _getStatusColor(request.status),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              request.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            // Details
            Row(
              children: [
                Icon(Icons.category, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  request.foodCategory.displayName,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.scale, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${request.quantity} ${request.unit}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    request.deliveryAddress,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Needed by: ${DateFormat('MMM dd, yyyy').format(request.neededBy)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Requested: ${request.createdAt != null ? DateFormat('MMM dd, yyyy HH:mm').format(request.createdAt!) : 'Unknown'}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            // Action buttons for pending requests
            if (request.status == NGORequestStatus.pending) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDenyDialog(context, request),
                      icon: const Icon(Icons.close),
                      label: const Text('Deny'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                        side: const BorderSide(color: AppTheme.errorColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approveRequest(context, request),
                      icon: const Icon(Icons.check),
                      label: const Text('Approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            // Show review info for reviewed requests
            if (request.reviewedBy != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reviewed by Admin',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'On ${request.reviewedAt != null ? DateFormat('MMM dd, yyyy HH:mm').format(request.reviewedAt!) : 'Unknown'}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    if (request.denialReason != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Reason: ${request.denialReason}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(NGORequestStatus status) {
    switch (status) {
      case NGORequestStatus.pending:
        return Colors.orange;
      case NGORequestStatus.approved:
        return AppTheme.successColor;
      case NGORequestStatus.denied:
        return AppTheme.errorColor;
      case NGORequestStatus.converted:
        return Colors.blue;
      case NGORequestStatus.cancelled:
        return Colors.grey;
    }
  }

  Future<void> _approveRequest(BuildContext context, NGORequest request) async {
    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) return;

      await ref
          .read(ngoRequestRepositoryProvider)
          .approveRequest(requestId: request.id, adminId: user.$id);

      ref.invalidate(ngoRequestsProvider);
      ref.invalidate(pendingNGORequestsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request approved successfully'),
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

  void _showDenyDialog(BuildContext context, NGORequest request) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deny Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to deny this request from ${request.ngoName}?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for denial',
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _denyRequest(context, request, reasonController.text);
            },
            child: const Text(
              'Deny',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _denyRequest(
    BuildContext context,
    NGORequest request,
    String reason,
  ) async {
    if (reason.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a reason for denial'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) return;

      await ref
          .read(ngoRequestRepositoryProvider)
          .denyRequest(
            requestId: request.id,
            adminId: user.$id,
            reason: reason,
          );

      ref.invalidate(ngoRequestsProvider);
      ref.invalidate(pendingNGORequestsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request denied'),
            backgroundColor: AppTheme.errorColor,
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
}
