import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/feedback_rating.dart';
import '../../../providers/providers.dart';
import 'package:intl/intl.dart';

class FeedbackModerationScreen extends ConsumerStatefulWidget {
  const FeedbackModerationScreen({super.key});

  @override
  ConsumerState<FeedbackModerationScreen> createState() =>
      _FeedbackModerationScreenState();
}

class _FeedbackModerationScreenState
    extends ConsumerState<FeedbackModerationScreen> {
  String _filter = 'all'; // all, flagged, low_rating

  @override
  Widget build(BuildContext context) {
    final feedbackAsync = ref.watch(pendingFeedbackProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Moderation'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Feedback')),
              const PopupMenuItem(
                value: 'low_rating',
                child: Text('Low Ratings'),
              ),
              const PopupMenuItem(value: 'flagged', child: Text('Flagged')),
            ],
          ),
        ],
      ),
      body: feedbackAsync.when(
        data: (feedback) {
          final filtered = _filterFeedback(feedback);
          return filtered.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _buildFeedbackCard(filtered[index]),
                );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  List<FeedbackRating> _filterFeedback(List<FeedbackRating> feedback) {
    switch (_filter) {
      case 'low_rating':
        return feedback.where((f) => f.rating <= 2).toList();
      case 'flagged':
        // Would need to check moderation table
        return feedback;
      default:
        return feedback;
    }
  }

  Widget _buildFeedbackCard(FeedbackRating feedback) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildRatingStars(feedback.rating),
                const Spacer(),
                Text(
                  DateFormat.yMMMd().format(feedback.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Type: ${feedback.type.name}',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (feedback.comment != null) ...[
              const SizedBox(height: 8),
              Text(feedback.comment!),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (feedback.isAnonymous)
                  const Chip(
                    label: Text('Anonymous', style: TextStyle(fontSize: 12)),
                    avatar: Icon(Icons.visibility_off, size: 16),
                  ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _approveFeedback(feedback),
                  icon: const Icon(Icons.check, color: Colors.green),
                  label: const Text('Approve'),
                ),
                TextButton.icon(
                  onPressed: () => _flagFeedback(feedback),
                  icon: const Icon(Icons.flag, color: Colors.orange),
                  label: const Text('Flag'),
                ),
                TextButton.icon(
                  onPressed: () => _rejectFeedback(feedback),
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.feedback_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No feedback to moderate',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Future<void> _approveFeedback(FeedbackRating feedback) async {
    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    await ref
        .read(adminRepositoryProvider)
        .moderateFeedback(
          feedbackId: feedback.id,
          moderatedBy: user.$id,
          action: 'approved',
          isApproved: true,
        );

    ref.invalidate(pendingFeedbackProvider);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Feedback approved')));
    }
  }

  Future<void> _flagFeedback(FeedbackRating feedback) async {
    final reason = await _showReasonDialog('Flag Feedback');
    if (reason == null) return;

    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    await ref
        .read(adminRepositoryProvider)
        .moderateFeedback(
          feedbackId: feedback.id,
          moderatedBy: user.$id,
          action: 'flagged',
          reason: reason,
          isFlagged: true,
        );

    ref.invalidate(pendingFeedbackProvider);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Feedback flagged')));
    }
  }

  Future<void> _rejectFeedback(FeedbackRating feedback) async {
    final reason = await _showReasonDialog('Reject Feedback');
    if (reason == null) return;

    final user = await ref.read(currentUserProvider.future);
    if (user == null) return;

    await ref
        .read(adminRepositoryProvider)
        .moderateFeedback(
          feedbackId: feedback.id,
          moderatedBy: user.$id,
          action: 'rejected',
          reason: reason,
          isApproved: false,
        );

    ref.invalidate(pendingFeedbackProvider);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Feedback rejected')));
    }
  }

  Future<String?> _showReasonDialog(String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Reason',
            hintText: 'Enter reason for this action',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
