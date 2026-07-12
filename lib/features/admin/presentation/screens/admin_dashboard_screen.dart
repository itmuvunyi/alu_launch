import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../authentication/providers/auth_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/alu_logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            const Text('ALU Admin Control Panel'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Admin ${user?.displayName ?? ''}!',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Account: ${user?.email ?? ''}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Statistics panels (Live queries from Firestore)
            Text('Moderation Status', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreCollections.internships)
                      .where('status', isEqualTo: OpportunityStatus.pendingReview.name)
                      .snapshots(),
                  builder: (context, snap) {
                    final count = snap.data?.docs.length ?? 0;
                    return _buildStatCard(
                      context,
                      'Pending Listings',
                      count.toString(),
                      Icons.rate_review,
                      Colors.orange,
                      () => context.push('/admin/approvals'),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreCollections.startups)
                      .where('isVerified', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snap) {
                    // Filter in-memory for those with verificationDocPath
                    final docs = (snap.data?.docs ?? []).where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data.containsKey('verificationDocPath') && data['verificationDocPath'] != null;
                    }).toList();

                    return _buildStatCard(
                      context,
                      'Pending Verifications',
                      docs.length.toString(),
                      Icons.gpp_maybe,
                      Colors.red,
                      () => context.push('/admin/verifications'),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Admin Actions Navigation
            Text('Admin Tasks', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.playlist_add_check, color: Colors.orange),
                    title: const Text('Moderate Internship Listings'),
                    subtitle: const Text('Review, approve, or reject new internship postings'),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                    onTap: () => context.push('/admin/approvals'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.shield_outlined, color: Colors.green),
                    title: const Text('Verify Startup Accounts'),
                    subtitle: const Text('Review legal documentation to authorize startup accounts'),
                    trailing: const Icon(Icons.chevron_right, size: 16),
                    onTap: () => context.push('/admin/verifications'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 24),
                  Text(
                    value,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
