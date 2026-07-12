import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../applications/models/application.dart';
import '../../../applications/providers/application_providers.dart';
import '../../providers/startup_providers.dart';
import '../../../messages/providers/message_providers.dart';

class ApplicantDetailsScreen extends ConsumerWidget {
  const ApplicantDetailsScreen({required this.applicationId, super.key});

  final String applicationId;

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    ApplicationStatus newStatus,
  ) async {
    final noteController = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Status to ${newStatus.name.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add an optional update message or note for the student:'),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Enter status updates here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final repo = ref.read(applicationRepositoryProvider);
        await repo.updateApplicationStatus(
          applicationId: applicationId,
          newStatus: newStatus,
          notes: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Applicant status updated to ${newStatus.name}!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final applicationAsync = ref.watch(applicationDetailsStreamProvider(applicationId));
    final startupAsync = ref.watch(currentFounderStartupStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
      ),
      body: applicationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading application: $err')),
        data: (app) {
          if (app == null) {
            return const Center(child: Text('Application not found.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Applicant Basic Information
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            app.studentName.isNotEmpty ? app.studentName.substring(0, 1).toUpperCase() : 'S',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          app.studentName,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          app.studentEmail,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Chip(
                          label: Text(app.status.name.toUpperCase()),
                          backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('Message Candidate'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 44),
                          ),
                          onPressed: () async {
                            final startup = startupAsync.valueOrNull;
                            if (startup == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Startup profile not loaded yet.')),
                              );
                              return;
                            }

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );

                            try {
                              final roomId = await ref.read(messageRepositoryProvider).getOrCreateChatRoom(
                                    studentId: app.studentId,
                                    studentName: app.studentName,
                                    studentPhotoUrl: null,
                                    startupId: startup.id,
                                    startupName: startup.name,
                                    startupLogoUrl: startup.logoUrl,
                                  );
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                context.push('/messages/$roomId');
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error opening chat: $e')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Application meta details
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Opportunity Details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.md),
                        _buildDetailRow(context, 'Applied For', app.opportunityTitle),
                        _buildDetailRow(context, 'Date Applied', '${app.createdAt.day}/${app.createdAt.month}/${app.createdAt.year}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Resume download/view section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Candidate Resume', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: theme.colorScheme.outlineVariant),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary, size: 32),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Resume.pdf', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 2),
                                    Text(
                                      app.studentResumeUrl != null
                                          ? 'Ready for review'
                                          : 'No resume provided by student',
                                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                    ),
                                  ],
                                ),
                              ),
                              if (app.studentResumeUrl != null)
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    final url = Uri.parse(app.studentResumeUrl!);
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  icon: const Icon(Icons.open_in_new, size: 16),
                                  label: const Text('Open'),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Application history timeline
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Application Timeline', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.md),
                        ...app.timeline.reversed.map((event) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.md),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.history_toggle_off, color: theme.colorScheme.primary, size: 18),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              event.status.name.toUpperCase(),
                                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '${event.time.day}/${event.time.month} ${event.time.hour}:${event.time.minute.toString().padLeft(2, '0')}',
                                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                            ),
                                          ],
                                        ),
                                        if (event.notes != null) ...[
                                          const SizedBox(height: 4),
                                          Text(event.notes!, style: theme.textTheme.bodyMedium),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Interactive Management Actions
                if (app.status != ApplicationStatus.rejected && app.status != ApplicationStatus.accepted) ...[
                  Text(
                    'Update Application Status',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          onPressed: () => _updateStatus(context, ref, ApplicationStatus.rejected),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      if (app.status == ApplicationStatus.applied)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateStatus(context, ref, ApplicationStatus.shortlisted),
                            child: const Text('Shortlist'),
                          ),
                        ),
                      if (app.status == ApplicationStatus.shortlisted)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _updateStatus(context, ref, ApplicationStatus.interviewScheduled),
                            child: const Text('Invite to Interview'),
                          ),
                        ),
                      if (app.status == ApplicationStatus.interviewScheduled)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _updateStatus(context, ref, ApplicationStatus.accepted),
                            child: const Text('Make Offer'),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
