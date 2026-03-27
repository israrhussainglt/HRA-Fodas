import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/feedback_rating.dart';
import '../../providers/providers.dart';

class FeedbackRatingWidget extends ConsumerStatefulWidget {
  final String toUserId;
  final String? donationId;
  final String? deliveryId;
  final FeedbackType type;
  final VoidCallback? onSubmitted;

  const FeedbackRatingWidget({
    super.key,
    required this.toUserId,
    this.donationId,
    this.deliveryId,
    required this.type,
    this.onSubmitted,
  });

  @override
  ConsumerState<FeedbackRatingWidget> createState() =>
      _FeedbackRatingWidgetState();
}

class _FeedbackRatingWidgetState extends ConsumerState<FeedbackRatingWidget> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rate Your Experience',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  );
                }),
              ),
            ),
            if (_rating > 0) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comments (optional)',
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Submit anonymously'),
                value: _isAnonymous,
                onChanged: (value) =>
                    setState(() => _isAnonymous = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitFeedback,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit Feedback'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _submitFeedback() async {
    if (_rating == 0) return;

    setState(() => _isSubmitting = true);

    try {
      final user = await ref.read(currentUserProvider.future);
      if (user == null) {
        throw Exception('User not logged in');
      }

      final feedback = await ref
          .read(feedbackRepositoryProvider)
          .submitFeedback(
            fromUserId: user.$id,
            toUserId: widget.toUserId,
            donationId: widget.donationId,
            deliveryId: widget.deliveryId,
            type: widget.type,
            rating: _rating,
            comment: _commentController.text.isEmpty
                ? null
                : _commentController.text,
            isAnonymous: _isAnonymous,
          );

      if (feedback != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: Colors.green,
          ),
        );

        widget.onSubmitted?.call();

        // Reset form
        setState(() {
          _rating = 0;
          _commentController.clear();
          _isAnonymous = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit feedback: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}

class FeedbackDisplayWidget extends ConsumerWidget {
  final String userId;

  const FeedbackDisplayWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingStatsAsync = ref.watch(userRatingStatsProvider(userId));

    return ratingStatsAsync.when(
      data: (stats) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Rating',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        stats.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (${stats.totalRatings})',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _RatingBar(
                label: '5 stars',
                count: stats.fiveStarCount,
                total: stats.totalRatings,
              ),
              _RatingBar(
                label: '4 stars',
                count: stats.fourStarCount,
                total: stats.totalRatings,
              ),
              _RatingBar(
                label: '3 stars',
                count: stats.threeStarCount,
                total: stats.totalRatings,
              ),
              _RatingBar(
                label: '2 stars',
                count: stats.twoStarCount,
                total: stats.totalRatings,
              ),
              _RatingBar(
                label: '1 star',
                count: stats.oneStarCount,
                total: stats.totalRatings,
              ),
            ],
          ),
        ),
      ),
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Error loading ratings: $e'),
        ),
      ),
    );
  }
}

class _RatingBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;

  const _RatingBar({
    required this.label,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? count / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation(Colors.amber),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              count.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
