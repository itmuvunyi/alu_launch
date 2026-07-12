import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../authentication/providers/auth_providers.dart';

import '../../../applications/providers/application_providers.dart';
import '../../models/startup.dart';
import '../../providers/startup_providers.dart';

import '../../../messages/providers/message_providers.dart';

class StartupDashboardScreen extends ConsumerWidget {
  const StartupDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider).valueOrNull;
    final startupAsync = ref.watch(currentFounderStartupStreamProvider);

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
            const Text('Founder Dashboard'),
          ],
        ),
        actions: [
          startupAsync.maybeWhen(
            data: (startup) {
              if (startup == null) return const SizedBox();
              return Consumer(
                builder: (context, ref, child) {
                  final unreadMessages = ref.watch(startupUnreadMessagesCountProvider(startup.id));
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.push('/messages'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: unreadMessages > 0
                          ? Badge(
                              label: Text(unreadMessages.toString()),
                              child: const Icon(Icons.chat_bubble_outline),
                            )
                          : const Icon(Icons.chat_bubble_outline),
                    ),
                  );
                },
              );
            },
            orElse: () => const SizedBox(),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ref.read(authControllerProvider.notifier).signOut(),
            child: const Padding(
              padding: EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: startupAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading startup: $err')),
        data: (startup) {
          if (startup == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.rocket_launch, size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome, ${user?.displayName ?? 'Founder'}!',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'To get started and recruit talent, you first need to create your Startup Profile.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/startup/profile-edit'),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Startup Profile'),
                    ),
                  ],
                ),
              ),
            );
          }

          final applicationsAsync = ref.watch(startupApplicationsStreamProvider(startup.id));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome and profile link card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: startup.logoUrl != null
                              ? ClipOval(child: Image.network(startup.logoUrl!, fit: BoxFit.cover))
                              : Icon(Icons.business, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                startup.name,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${startup.industry} • ${startup.location}',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Edit Profile',
                          onPressed: () => context.push('/startup/profile-edit'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Verification Warning Alert
                _buildVerificationStatusCard(context, startup),
                const SizedBox(height: AppSpacing.lg),

                // Quick stats summary
                applicationsAsync.maybeWhen(
                  data: (apps) => StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(FirestoreCollections.internships)
                        .where('startupId', isEqualTo: startup.id)
                        .snapshots(),
                    builder: (context, oppSnapshot) {
                      final oppCount = oppSnapshot.data?.docs.length ?? 0;
                      final pendingApps = apps.where((a) => a.status == ApplicationStatus.applied).length;

                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.5,
                        children: [
                          _buildStatCard(context, 'Postings', oppCount.toString(), Icons.campaign, Colors.blue),
                          _buildStatCard(context, 'Total Applicants', apps.length.toString(), Icons.people, Colors.green),
                          _buildStatCard(context, 'Pending Review', pendingApps.toString(), Icons.pending_actions, Colors.orange),
                          _buildStatCard(
                            context,
                            'Verified Status',
                            startup.isVerified ? 'VERIFIED' : 'PENDING',
                            Icons.verified_user,
                            startup.isVerified ? Colors.green : Colors.grey,
                          ),
                        ],
                      );
                    },
                  ),
                  orElse: () => const Center(child: CircularProgressIndicator()),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Main navigation actions
                Text('Founder Toolkit', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.post_add, color: Colors.blue),
                        title: const Text('Post a New Position'),
                        subtitle: const Text('Recruit ALU students for internships'),
                        trailing: const Icon(Icons.chevron_right, size: 16),
                        onTap: () => context.push('/startup/opportunities/create'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.list_alt, color: Colors.indigo),
                        title: const Text('Manage Open Listings'),
                        subtitle: const Text('Track approval statuses, edit or close listings'),
                        trailing: const Icon(Icons.chevron_right, size: 16),
                        onTap: () => context.push('/startup/opportunities'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.groups, color: Colors.green),
                        title: const Text('Review Applications'),
                        subtitle: const Text('Shortlist, interview, or make offers to candidates'),
                        trailing: const Icon(Icons.chevron_right, size: 16),
                        onTap: () => context.push('/startup/applicants'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.verified, color: Colors.orange),
                        title: const Text('Verification Centre'),
                        subtitle: const Text('Submit legal documents to verify startup account'),
                        trailing: const Icon(Icons.chevron_right, size: 16),
                        onTap: () => context.push('/startup/verification'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationStatusCard(BuildContext context, Startup startup) {
    final theme = Theme.of(context);
    if (startup.isVerified) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified, color: Colors.green),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Your startup is verified. Your posted listings are visible to students.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green[800], fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    final hasUploaded = startup.verificationDocPath != null && startup.verificationDocPath!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  hasUploaded
                      ? 'Verification document submitted. Awaiting ALU Admin review.'
                      : 'Verification Required: Submit legal documents to publish internships.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.orange[800], fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (!hasUploaded) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.push('/startup/verification'),
                child: const Text('Verify Now'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Card(
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
    );
  }
}
