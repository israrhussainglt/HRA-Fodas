import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/providers.dart';
import '../../../core/enums/enums.dart';
import '../donor/donor_dashboard.dart';
import '../recipient/recipient_dashboard.dart';
import '../volunteer/volunteer_dashboard.dart';
import '../admin/admin_dashboard.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return userProfileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Scaffold(
            body: Center(child: Text('Please complete your profile')),
          );
        }

        switch (profile.role) {
          case UserRole.donor:
            return const DonorDashboard();
          case UserRole.recipient:
            return const RecipientDashboard();
          case UserRole.volunteer:
            return const VolunteerDashboard();
          case UserRole.admin:
            return const AdminDashboard();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }
}
