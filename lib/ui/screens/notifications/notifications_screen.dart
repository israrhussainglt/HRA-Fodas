import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:appwrite/appwrite.dart';
import '../../../providers/providers.dart';
import '../../../data/models/notification_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/logger.dart';
import '../../../appwrite_options.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String? _selectedCategory;
  bool? _selectedReadStatus;
  RealtimeSubscription? _notificationsSubscription;

  @override
  void initState() {
    super.initState();
    _setupRealtimeSubscription();
  }

  @override
  void dispose() {
    _notificationsSubscription?.close();
    super.dispose();
  }

  void _setupRealtimeSubscription() {
    final realtime = ref.read(appwriteRealtimeProvider);
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
            // Auto-refresh notifications when new ones arrive
            ref.invalidate(notificationsProvider(user.$id));
            ref.invalidate(unreadNotificationCountProvider);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Please login to view notifications')),
          );
        }

        final notificationsAsync = ref.watch(notificationsProvider(user.$id));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications'),
            actions: [
              // Filter button
              IconButton(
                icon: Icon(
                  _selectedCategory != null || _selectedReadStatus != null
                      ? Icons.filter_alt
                      : Icons.filter_alt_outlined,
                ),
                onPressed: () => _showFilterDialog(context, user.$id),
              ),
              // More options menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  switch (value) {
                    case 'mark_all_read':
                      try {
                        AppLogger.notification(
                          'Marking all notifications as read for user: ${user.$id}',
                          tag: 'NOTIFICATIONS',
                        );
                        await ref
                            .read(notificationRepositoryProvider)
                            .markAllAsRead(user.$id);
                        ref.invalidate(notificationsProvider(user.$id));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All notifications marked as read'),
                              backgroundColor: AppTheme.successColor,
                            ),
                          );
                        }
                        AppLogger.success(
                          'All notifications marked as read',
                          tag: 'NOTIFICATIONS',
                        );
                      } catch (e) {
                        AppLogger.error(
                          'Failed to mark all as read',
                          tag: 'NOTIFICATIONS',
                          error: e,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${e.toString()}'),
                              backgroundColor: AppTheme.errorColor,
                            ),
                          );
                        }
                      }
                      break;
                    case 'delete_all':
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete All Notifications'),
                          content: const Text(
                            'Are you sure you want to delete all notifications? This cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: AppTheme.errorColor,
                              ),
                              child: const Text('Delete All'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        try {
                          AppLogger.notification(
                            'Deleting all notifications for user: ${user.$id}',
                            tag: 'NOTIFICATIONS',
                          );
                          await ref
                              .read(notificationRepositoryProvider)
                              .deleteAllNotifications(user.$id);
                          ref.invalidate(notificationsProvider(user.$id));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('All notifications deleted'),
                                backgroundColor: AppTheme.successColor,
                              ),
                            );
                          }
                          AppLogger.success(
                            'All notifications deleted',
                            tag: 'NOTIFICATIONS',
                          );
                        } catch (e) {
                          AppLogger.error(
                            'Failed to delete all notifications',
                            tag: 'NOTIFICATIONS',
                            error: e,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: AppTheme.errorColor,
                              ),
                            );
                          }
                        }
                      }
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'mark_all_read',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, size: 20),
                        SizedBox(width: 12),
                        Text('Mark all as read'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete_all',
                    child: Row(
                      children: [
                        Icon(Icons.delete_sweep, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Delete all', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Filter chips
              if (_selectedCategory != null || _selectedReadStatus != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      if (_selectedCategory != null)
                        FilterChip(
                          label: Text(_selectedCategory!),
                          selected: true,
                          onSelected: (selected) {
                            if (!selected) {
                              setState(() => _selectedCategory = null);
                            }
                          },
                          onDeleted: () {
                            setState(() => _selectedCategory = null);
                          },
                        ),
                      if (_selectedReadStatus != null)
                        FilterChip(
                          label: Text(_selectedReadStatus! ? 'Read' : 'Unread'),
                          selected: true,
                          onSelected: (selected) {
                            if (!selected) {
                              setState(() => _selectedReadStatus = null);
                            }
                          },
                          onDeleted: () {
                            setState(() => _selectedReadStatus = null);
                          },
                        ),
                    ],
                  ),
                ),
              // Notifications list
              Expanded(
                child: notificationsAsync.when(
                  data: (allNotifications) {
                    // Apply filters
                    var notifications = allNotifications;

                    if (_selectedCategory != null) {
                      notifications = notifications
                          .where((n) => n.type.category == _selectedCategory)
                          .toList();
                    }

                    if (_selectedReadStatus != null) {
                      notifications = notifications
                          .where((n) => n.isRead == _selectedReadStatus)
                          .toList();
                    }

                    if (notifications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _selectedCategory != null ||
                                      _selectedReadStatus != null
                                  ? Icons.filter_alt_off
                                  : Icons.notifications_off_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _selectedCategory != null ||
                                      _selectedReadStatus != null
                                  ? 'No notifications match your filters'
                                  : 'No notifications yet',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(notificationsProvider(user.$id));
                      },
                      child: ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return _NotificationTile(
                            notification: notification,
                            onDelete: () async {
                              await ref
                                  .read(notificationRepositoryProvider)
                                  .deleteNotification(notification.id);
                              ref.invalidate(notificationsProvider(user.$id));
                            },
                          );
                        },
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }

  void _showFilterDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedCategory == null,
                  onSelected: (selected) {
                    setState(() => _selectedCategory = null);
                    Navigator.pop(context);
                  },
                ),
                ...[
                  'Donations',
                  'Deliveries',
                  'Status Updates',
                  'Reminders',
                  'Messages',
                  'System',
                ].map(
                  (category) => FilterChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(
                        () => _selectedCategory = selected ? category : null,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Status:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedReadStatus == null,
                  onSelected: (selected) {
                    setState(() => _selectedReadStatus = null);
                    Navigator.pop(context);
                  },
                ),
                FilterChip(
                  label: const Text('Unread'),
                  selected: _selectedReadStatus == false,
                  onSelected: (selected) {
                    setState(
                      () => _selectedReadStatus = selected ? false : null,
                    );
                    Navigator.pop(context);
                  },
                ),
                FilterChip(
                  label: const Text('Read'),
                  selected: _selectedReadStatus == true,
                  onSelected: (selected) {
                    setState(
                      () => _selectedReadStatus = selected ? true : null,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final NotificationModel notification;
  final VoidCallback onDelete;

  const _NotificationTile({required this.notification, required this.onDelete});

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.newDonation:
        return Icons.volunteer_activism;
      case NotificationType.volunteerAccepted:
        return Icons.person_add;
      case NotificationType.ngoRequested:
        return Icons.business;
      case NotificationType.donationPickedUp:
        return Icons.local_shipping;
      case NotificationType.donationDelivered:
        return Icons.check_circle;
      case NotificationType.donationCancelled:
        return Icons.cancel;
      case NotificationType.deliveryAssigned:
      case NotificationType.deliveryCompleted:
        return Icons.local_shipping;
      case NotificationType.pickupReminder:
        return Icons.access_time;
      case NotificationType.statusUpdate:
        return Icons.update;
      case NotificationType.chatMessage:
        return Icons.message;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.ngoRequestSubmitted:
        return Icons.request_page;
      case NotificationType.ngoRequestApproved:
        return Icons.check_circle_outline;
      case NotificationType.ngoRequestDenied:
        return Icons.cancel_outlined;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.newDonation:
        return AppTheme.successColor;
      case NotificationType.volunteerAccepted:
        return Colors.green;
      case NotificationType.ngoRequested:
        return Colors.blue;
      case NotificationType.donationPickedUp:
        return Colors.orange;
      case NotificationType.donationDelivered:
        return AppTheme.successColor;
      case NotificationType.donationCancelled:
        return AppTheme.errorColor;
      case NotificationType.deliveryAssigned:
      case NotificationType.deliveryCompleted:
        return Colors.blue;
      case NotificationType.pickupReminder:
        return Colors.orange;
      case NotificationType.statusUpdate:
        return Colors.purple;
      case NotificationType.chatMessage:
        return AppTheme.accentColor;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.ngoRequestSubmitted:
        return Colors.indigo;
      case NotificationType.ngoRequestApproved:
        return AppTheme.successColor;
      case NotificationType.ngoRequestDenied:
        return AppTheme.errorColor;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Notification'),
                content: const Text(
                  'Are you sure you want to delete this notification?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.errorColor,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) {
        AppLogger.notification(
          'Deleting notification: ${notification.id}',
          tag: 'NOTIFICATIONS',
        );
        onDelete();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: notification.isRead ? 0 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: notification.isRead
                ? Colors.grey.withValues(alpha: 0.2)
                : _getIconColor().withValues(alpha: 0.3),
            width: notification.isRead ? 1 : 2,
          ),
        ),
        child: InkWell(
          onTap: () async {
            AppLogger.notification(
              'Notification tapped - ID: ${notification.id}, Type: ${notification.relatedEntityType}, Entity ID: ${notification.relatedEntityId}',
              tag: 'NOTIFICATIONS',
            );

            if (!notification.isRead) {
              try {
                AppLogger.notification(
                  'Marking notification as read: ${notification.id}',
                  tag: 'NOTIFICATIONS',
                );
                await ref
                    .read(notificationRepositoryProvider)
                    .markAsRead(notification.id);
                final userAsync = ref.read(currentUserProvider);
                final user = userAsync.value;
                if (user != null) {
                  ref.invalidate(notificationsProvider(user.$id));
                }
                AppLogger.success(
                  'Notification marked as read',
                  tag: 'NOTIFICATIONS',
                );
              } catch (e) {
                AppLogger.error(
                  'Failed to mark notification as read',
                  tag: 'NOTIFICATIONS',
                  error: e,
                );
              }
            }

            // Navigate to related entity
            if (notification.relatedEntityId != null &&
                notification.relatedEntityType != null) {
              if (context.mounted) {
                AppLogger.notification(
                  'Navigating to ${notification.relatedEntityType}: ${notification.relatedEntityId}',
                  tag: 'NOTIFICATIONS',
                );
                switch (notification.relatedEntityType) {
                  case 'donation':
                    context.push('/donation/${notification.relatedEntityId}');
                    AppLogger.success(
                      'Navigation initiated to donation',
                      tag: 'NOTIFICATIONS',
                    );
                    break;
                  case 'delivery':
                    context.push('/delivery/${notification.relatedEntityId}');
                    AppLogger.success(
                      'Navigation initiated to delivery',
                      tag: 'NOTIFICATIONS',
                    );
                    break;
                  case 'ngo_request':
                    // Navigate to admin NGO requests screen if user is admin
                    context.push('/admin/ngo-requests');
                    AppLogger.success(
                      'Navigation initiated to NGO requests',
                      tag: 'NOTIFICATIONS',
                    );
                    break;
                  default:
                    AppLogger.warning(
                      'Unknown entity type: ${notification.relatedEntityType}',
                      tag: 'NOTIFICATIONS',
                    );
                }
              } else {
                AppLogger.error(
                  'Context not mounted, cannot navigate',
                  tag: 'NOTIFICATIONS',
                );
              }
            } else {
              AppLogger.warning(
                'No related entity data - Type: ${notification.relatedEntityType}, ID: ${notification.relatedEntityId}',
                tag: 'NOTIFICATIONS',
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getIconColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIcon(),
                    color: _getIconColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Category Badge Row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                color: notification.isRead
                                    ? Colors.grey[800]
                                    : Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getIconColor().withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              notification.type.category,
                              style: TextStyle(
                                fontSize: 11,
                                color: _getIconColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Message
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Actor and Time Row
                      Row(
                        children: [
                          if (notification.actorName != null) ...[
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                notification.actorName!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification.createdAt != null
                                ? _formatTime(notification.createdAt!)
                                : 'Just now',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getIconColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Delete button
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Notification'),
                        content: const Text(
                          'Are you sure you want to delete this notification?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.errorColor,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      AppLogger.notification(
                        'Deleting notification via button: ${notification.id}',
                        tag: 'NOTIFICATIONS',
                      );
                      onDelete();
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
