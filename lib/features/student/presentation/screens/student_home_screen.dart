import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../../authentication/models/app_user.dart';
import '../../../authentication/providers/auth_providers.dart';
import '../../../internships/models/opportunity.dart';
import '../../../internships/providers/internship_providers.dart';

import '../../../applications/providers/application_providers.dart';
import '../../../notifications/providers/notification_providers.dart';
import '../../../messages/providers/message_providers.dart';

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider).valueOrNull;
    final opportunitiesAsync = ref.watch(opportunitiesStreamProvider);
    final bookmarksAsync = ref.watch(bookmarkedIdsStreamProvider);
    final applicationsAsync = ref.watch(studentApplicationsStreamProvider);

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
            Text(
              'ALU Launch',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final unreadMessages = ref.watch(studentUnreadMessagesCountProvider);
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
          ),
          Consumer(
            builder: (context, ref, child) {
              final unreadCount = ref.watch(unreadNotificationsCountProvider);
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push('/notifications'),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 16, top: 8, bottom: 8),
                  child: unreadCount > 0
                      ? Badge(
                          label: Text(unreadCount.toString()),
                          child: const Icon(Icons.notifications_outlined),
                        )
                      : const Icon(Icons.notifications_none_outlined),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(opportunitiesStreamProvider);
          ref.invalidate(bookmarkedIdsStreamProvider);
          ref.invalidate(studentApplicationsStreamProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting Section
              Text(
                'Hello, ${user?.displayName ?? 'Student'}!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Discover and apply to student-led startup internships',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Verification Status Banner
              _buildVerificationBanner(context, user),
              const SizedBox(height: AppSpacing.lg),

              // Dashboard Statistics
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Bookmarks',
                      value: bookmarksAsync.when(
                        data: (ids) => ids.length.toString(),
                        loading: () => '...',
                        error: (_, __) => '0',
                      ),
                      icon: Icons.bookmark_border_outlined,
                      color: theme.colorScheme.primary,
                      onTap: () => context.push('/student/bookmarks'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      title: 'Applications',
                      value: applicationsAsync.when(
                        data: (apps) => apps.length.toString(),
                        loading: () => '...',
                        error: (_, __) => '0',
                      ),
                      icon: Icons.send_outlined,
                      color: theme.colorScheme.secondary,
                      onTap: () {
                        // Switch tab to Applications using GoRouter
                        context.go('/student/applications');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Recommended section title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Opportunities',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Switch tab to Explore using GoRouter
                      context.go('/student/explore');
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              // Recommended Opportunities List
              opportunitiesAsync.when(
                data: (opportunities) {
                  if (opportunities.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  // Take top 3
                  final featured = opportunities.take(3).toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: featured.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final opp = featured[index];
                      return _buildOpportunityCard(context, opp, ref);
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, _) => Center(
                  child: Text('Error loading opportunities: $error'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationBanner(BuildContext context, AppUser? user) {
    final theme = Theme.of(context);
    final isVerified = user?.isVerified ?? false;

    return Card(
      color: isVerified
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
          : theme.colorScheme.errorContainer.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isVerified
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              isVerified ? Icons.verified_user : Icons.gpp_maybe_outlined,
              color: isVerified ? theme.colorScheme.primary : theme.colorScheme.error,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isVerified ? 'Profile Verified' : 'Verification Pending',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isVerified ? theme.colorScheme.primary : theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isVerified
                        ? 'Your profile is fully verified for internship submissions.'
                        : 'Submit verification docs in profile to apply for internships.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard(BuildContext context, Opportunity opp, WidgetRef ref) {
    final theme = Theme.of(context);
    final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).valueOrNull ?? [];
    final isBookmarked = bookmarkedIds.contains(opp.id);

    return InkWell(
      onTap: () => context.push('/student/opportunity/${opp.id}'),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: opp.startupLogoUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: Image.network(opp.startupLogoUrl!, fit: BoxFit.cover),
                          )
                        : Icon(Icons.business, color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Title and startup
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opp.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () => context.push('/student/startup/${opp.startupId}'),
                          child: Text(
                            opp.startupName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bookmark toggle
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? theme.colorScheme.primary : null,
                    ),
                    onPressed: () async {
                      final userId = ref.read(currentUserIdProvider).valueOrNull;
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please sign in to bookmark opportunities.')),
                        );
                        return;
                      }
                      try {
                        final repo = ref.read(internshipRepositoryProvider);
                        await repo.toggleBookmark(
                          userId: userId,
                          opportunityId: opp.id,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isBookmarked
                                    ? 'Bookmark removed successfully!'
                                    : 'Opportunity bookmarked successfully!',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to update bookmark: $e')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // Tags
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  Chip(
                    label: Text(opp.type),
                    backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                    labelStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Chip(
                    label: Text(opp.location),
                    backgroundColor: theme.colorScheme.surfaceContainer,
                    labelStyle: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (opp.stipend != null)
                    Chip(
                      label: Text(opp.stipend!),
                      backgroundColor: theme.colorScheme.secondaryContainer.withValues(alpha: 0.1),
                      labelStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Icon(Icons.work_outline, size: 48, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No opportunities available yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
