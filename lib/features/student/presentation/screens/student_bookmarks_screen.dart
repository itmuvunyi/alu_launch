import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../internships/models/opportunity.dart';
import '../../../internships/providers/internship_providers.dart';
import '../../../../core/providers/firebase_providers.dart';

class StudentBookmarksScreen extends ConsumerWidget {
  const StudentBookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bookmarkedOppsAsync = ref.watch(bookmarkedOpportunitiesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Bookmarks'),
      ),
      body: bookmarkedOppsAsync.when(
        data: (opportunities) {
          if (opportunities.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            itemCount: opportunities.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final opp = opportunities[index];
              return _buildBookmarkedOpportunityCard(context, opp, ref);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading bookmarks: $error')),
      ),
    );
  }

  Widget _buildBookmarkedOpportunityCard(BuildContext context, Opportunity opp, WidgetRef ref) {
    final theme = Theme.of(context);

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
                        Text(
                          opp.startupName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Remove bookmark
                  IconButton(
                    icon: Icon(Icons.bookmark, color: theme.colorScheme.primary),
                    onPressed: () async {
                      final userId = ref.read(currentUserIdProvider).valueOrNull;
                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please sign in to manage bookmarks.')),
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
                            const SnackBar(
                              content: Text('Bookmark removed successfully!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to remove bookmark: $e')),
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No saved bookmarks',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Opportunities you bookmark will appear here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
