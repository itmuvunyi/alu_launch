import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../models/application.dart';
import '../../providers/application_providers.dart';

class MyApplicationsScreen extends ConsumerWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final applicationsAsync = ref.watch(studentApplicationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications'),
      ),
      body: applicationsAsync.when(
        data: (applications) {
          if (applications.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            itemCount: applications.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final app = applications[index];
              return _buildApplicationCard(context, app);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading applications: $error')),
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, Application app) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context.push('/student/application-tracking/${app.id}'),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      app.opportunityTitle,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _buildStatusPill(context, app.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                app.startupName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Applied on ${_formatDate(app.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  Row(
                    children: [
                      Text(
                        'Track Progress',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 14, color: theme.colorScheme.primary),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, ApplicationStatus status) {
    final theme = Theme.of(context);
    
    Color backgroundColor;
    Color textColor;

    final isDark = theme.brightness == Brightness.dark;
    switch (status) {
      case ApplicationStatus.applied:
        backgroundColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.15);
        textColor = theme.colorScheme.primary;
        break;
      case ApplicationStatus.underReview:
        backgroundColor = Colors.orange.withValues(alpha: 0.15);
        textColor = isDark ? Colors.orange[300]! : Colors.orange[800]!;
        break;
      case ApplicationStatus.shortlisted:
        backgroundColor = Colors.blue.withValues(alpha: 0.15);
        textColor = isDark ? Colors.blue[300]! : Colors.blue[800]!;
        break;
      case ApplicationStatus.interviewScheduled:
        backgroundColor = Colors.purple.withValues(alpha: 0.15);
        textColor = isDark ? Colors.purple[300]! : Colors.purple[800]!;
        break;
      case ApplicationStatus.accepted:
        backgroundColor = Colors.green.withValues(alpha: 0.15);
        textColor = isDark ? Colors.green[300]! : Colors.green[800]!;
        break;
      case ApplicationStatus.rejected:
        backgroundColor = theme.colorScheme.errorContainer.withValues(alpha: 0.15);
        textColor = theme.colorScheme.error;
        break;
    }

    String label = switch (status) {
      ApplicationStatus.applied => 'Applied',
      ApplicationStatus.underReview => 'Under Review',
      ApplicationStatus.shortlisted => 'Shortlisted',
      ApplicationStatus.interviewScheduled => 'Interviewing',
      ApplicationStatus.accepted => 'Accepted',
      ApplicationStatus.rejected => 'Declined',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_and_archive_outlined, size: 64, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No applications yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Find an internship on Explore and submit your application.',
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
