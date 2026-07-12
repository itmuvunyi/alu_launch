import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../applications/models/application.dart';
import '../../../applications/providers/application_providers.dart';
import '../../providers/startup_providers.dart';

class ApplicantsManagementScreen extends ConsumerWidget {
  const ApplicantsManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final startupAsync = ref.watch(currentFounderStartupStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicants'),
      ),
      body: startupAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading startup: $err')),
        data: (startup) {
          if (startup == null) {
            return const Center(child: Text('Please complete your startup profile first.'));
          }

          final applicationsAsync = ref.watch(startupApplicationsStreamProvider(startup.id));

          return applicationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(child: Text('Error loading applicants: $err')),
            data: (applications) {
              if (applications.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No applications yet',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'When students apply to your positions, they will show up here.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                itemCount: applications.length,
                itemBuilder: (context, idx) {
                  final app = applications[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          app.studentName.isNotEmpty ? app.studentName.substring(0, 1).toUpperCase() : 'S',
                          style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(app.studentName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Applied to: ${app.opportunityTitle}', style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${app.createdAt.day}/${app.createdAt.month}/${app.createdAt.year}',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusPill(context, app.status),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, size: 16),
                        ],
                      ),
                      onTap: () => context.push('/startup/applicant/${app.id}'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, ApplicationStatus status) {
    final theme = Theme.of(context);
    Color color;
    Color bgColor;

    switch (status) {
      case ApplicationStatus.applied:
        color = theme.colorScheme.primary;
        bgColor = theme.colorScheme.primaryContainer;
        break;
      case ApplicationStatus.shortlisted:
        color = Colors.blue;
        bgColor = Colors.blue.withValues(alpha: 0.15);
        break;
      case ApplicationStatus.rejected:
        color = Colors.red;
        bgColor = Colors.red.withValues(alpha: 0.15);
        break;
      case ApplicationStatus.interviewScheduled:
        color = Colors.orange;
        bgColor = Colors.orange.withValues(alpha: 0.15);
        break;
      case ApplicationStatus.accepted:
        color = Colors.green;
        bgColor = Colors.green.withValues(alpha: 0.15);
        break;
      case ApplicationStatus.underReview:
        color = theme.colorScheme.secondary;
        bgColor = theme.colorScheme.secondaryContainer;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
