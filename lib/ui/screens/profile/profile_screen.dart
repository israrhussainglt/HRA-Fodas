import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils/logger.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: userProfile.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.primaryColor,
                  backgroundImage: profile.avatarUrl != null
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: profile.avatarUrl == null
                      ? Text(
                          profile.fullName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  profile.fullName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(profile.email, style: TextStyle(color: Colors.grey[400])),
                const SizedBox(height: 8),
                Chip(
                  label: Text(profile.role.displayName.toUpperCase()),
                  backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                ),
                if (profile.isVerified)
                  const Chip(
                    label: Text('Verified'),
                    avatar: Icon(Icons.verified, size: 18),
                    backgroundColor: Colors.green,
                  ),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('Phone'),
                        subtitle: Text(profile.phone ?? 'Not set'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: const Text('Address'),
                        subtitle: Text(profile.address ?? 'Not set'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.psychology),
                        title: const Text('LLM Settings'),
                        subtitle: const Text('Configure AI model server'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/settings/llm'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Settings'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/settings'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Help & Support'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/help'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('About'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/about'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      AppLogger.auth('Starting sign out...', tag: 'PROFILE');

                      try {
                        // Try to delete the session on the server
                        await ref.read(authRepositoryProvider).signOut();
                        AppLogger.success(
                          'Sign out successful',
                          tag: 'PROFILE',
                        );
                      } catch (e) {
                        // Even if server sign out fails, we still want to clear local state
                        AppLogger.warning(
                          'Sign out API failed, but clearing local state',
                          tag: 'PROFILE',
                          error: e,
                        );
                      }

                      // Always invalidate providers and navigate to login
                      // This ensures the user is logged out locally even if the API call failed
                      AppLogger.info(
                        'Invalidating providers...',
                        tag: 'PROFILE',
                      );
                      ref.invalidate(authStateProvider);
                      ref.invalidate(currentUserProvider);
                      ref.invalidate(userProfileProvider);

                      AppLogger.success(
                        'Navigating to login...',
                        tag: 'PROFILE',
                      );
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    icon: const Icon(Icons.logout, color: AppTheme.errorColor),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(color: AppTheme.errorColor),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.errorColor),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
