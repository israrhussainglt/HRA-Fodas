import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/logger.dart';

/// A notification icon button with an unread count badge
/// Provides visual feedback for new notifications with accessibility support
///
/// Fixed sizing implementation:
/// - Icon size: AppIconSize.lg (24px) - Requirements 1.1, 1.2
/// - Container padding: AppSpacing.sm (8px) on all sides - Requirement 1.4
/// - Badge counter positioned absolutely to not affect icon size
class NotificationBadge extends ConsumerWidget {
  const NotificationBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return _buildNotificationIcon(
            context: context,
            unreadCount: 0,
            onPressed: () => context.push('/notifications'),
          );
        }

        // Watch notifications to get unread count
        final notificationsAsync = ref.watch(notificationsProvider(user.$id));

        return notificationsAsync.when(
          data: (notifications) {
            final unreadCount = notifications.where((n) => !n.isRead).length;

            return _buildNotificationIcon(
              context: context,
              unreadCount: unreadCount,
              onPressed: () {
                context.push('/notifications');
                // Invalidate to refresh count when returning
                ref.invalidate(notificationsProvider(user.$id));
              },
            );
          },
          loading: () => _buildNotificationIcon(
            context: context,
            unreadCount: 0,
            onPressed: () => context.push('/notifications'),
          ),
          error: (error, stack) {
            // Log error for debugging but don't show to user
            AppLogger.debug(
              'Error loading notifications: $error',
              tag: 'NOTIFICATION_BADGE',
            );
            // Show error indicator with subtle visual cue
            return _buildNotificationIcon(
              context: context,
              unreadCount: 0,
              onPressed: () => context.push('/notifications'),
              showErrorIndicator: true,
            );
          },
        );
      },
      loading: () => _buildNotificationIcon(
        context: context,
        unreadCount: 0,
        onPressed: () => context.push('/notifications'),
      ),
      error: (_, _) => _buildNotificationIcon(
        context: context,
        unreadCount: 0,
        onPressed: () => context.push('/notifications'),
      ),
    );
  }

  /// Builds the notification icon with fixed sizing and optional badge
  ///
  /// Fixed dimensions:
  /// - Icon: 24x24px (AppIconSize.lg)
  /// - Container padding: 8px on all sides (AppSpacing.sm)
  /// - Badge positioned absolutely to not affect icon size
  Widget _buildNotificationIcon({
    required BuildContext context,
    required int unreadCount,
    required VoidCallback onPressed,
    bool showErrorIndicator = false,
  }) {
    return Container(
      // Fixed padding of 8px on all sides - Requirement 1.4
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            // Fixed icon size of 24px - Requirements 1.1, 1.2
            iconSize: AppIconSize.lg,
            icon: Icon(
              unreadCount > 0
                  ? Icons.notifications_active
                  : Icons.notifications_outlined,
            ),
            tooltip: unreadCount > 0
                ? '$unreadCount unread notification${unreadCount == 1 ? '' : 's'}'
                : showErrorIndicator
                ? 'Notifications (error loading count)'
                : 'Notifications',
            onPressed: onPressed,
            // Remove default padding to ensure consistent sizing
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: AppIconSize.lg,
              minHeight: AppIconSize.lg,
            ),
          ),
          // Badge counter positioned absolutely - doesn't affect icon size
          if (unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.errorColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          // Error indicator positioned absolutely
          if (showErrorIndicator && unreadCount == 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
