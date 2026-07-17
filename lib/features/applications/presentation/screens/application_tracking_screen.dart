import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../authentication/providers/auth_providers.dart';
import '../../../notifications/providers/notification_providers.dart';
import '../../models/application.dart';
import '../../providers/application_providers.dart';

class ApplicationTrackingScreen extends ConsumerWidget {
  const ApplicationTrackingScreen({required this.applicationId, super.key});

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    // Auto-mark notifications for this application as read
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = ref.read(currentUserIdProvider).valueOrNull;
      if (userId != null) {
        ref.read(notificationRepositoryProvider).markApplicationNotificationAsRead(userId, applicationId);
      }
    });

    final applicationAsync = ref.watch(applicationDetailsStreamProvider(applicationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Tracking'),
      ),
      body: applicationAsync.when(
        data: (app) {
          if (app == null) {
            return const Center(child: Text('Application not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Application summary card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          app.opportunityTitle,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          app.startupName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildCandidateInfoRow(context, 'Candidate', app.studentName),
                        _buildCandidateInfoRow(context, 'Email', app.studentEmail),
                        _buildCandidateResumeRow(context, 'Submitted Resume', app.studentResumeUrl),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Timeline Checklist header
                Text(
                  'Application Timeline',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.md),

                // Vertical stepper timeline
                _buildTimelineStepper(context, app),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading application: $error')),
      ),
    );
  }

  Widget _buildCandidateInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCandidateResumeRow(BuildContext context, String label, String? url) {
    final theme = Theme.of(context);
    final filename = url != null ? url.split('/').last.split('?').first : 'No resume uploaded';
    final hasUrl = url != null && url.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          if (hasUrl)
            InkWell(
              onTap: () async {
                final uri = Uri.parse(url);
                try {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open resume: $e')),
                    );
                  }
                }
              },
              child: Text(
                filename,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          else
            Text(
              filename,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineStepper(BuildContext context, Application app) {
    // Define the sequence of status stages
    final stages = [
      ApplicationStatus.applied,
      ApplicationStatus.underReview,
      ApplicationStatus.shortlisted,
      ApplicationStatus.interviewScheduled,
      // The decision stage can be either accepted or rejected
      app.status == ApplicationStatus.rejected ? ApplicationStatus.rejected : ApplicationStatus.accepted,
    ];

    // Find the current stage index
    int currentStageIndex = stages.indexOf(app.status);
    if (currentStageIndex == -1) {
      // Fallback in case of mismatch
      currentStageIndex = 0;
    }

    return Column(
      children: List.generate(stages.length, (index) {
        final stage = stages[index];
        final isCompleted = index <= currentStageIndex;
        final isActive = index == currentStageIndex;
        final isLast = index == stages.length - 1;

        // Find matching event in application timeline
        final matchingEvent = app.timeline.cast<ApplicationTimelineEvent?>().firstWhere(
              (event) => event?.status == stage,
              orElse: () => null,
            );

        return _buildTimelineStep(
          context,
          stage: stage,
          isCompleted: isCompleted,
          isActive: isActive,
          isLast: isLast,
          event: matchingEvent,
        );
      }),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context, {
    required ApplicationStatus stage,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
    ApplicationTimelineEvent? event,
  }) {
    final theme = Theme.of(context);

    String title = switch (stage) {
      ApplicationStatus.applied => 'Application Submitted',
      ApplicationStatus.underReview => 'Under Review',
      ApplicationStatus.shortlisted => 'Candidate Shortlisted',
      ApplicationStatus.interviewScheduled => 'Interview Scheduled',
      ApplicationStatus.accepted => 'Offer Accepted / Approved',
      ApplicationStatus.rejected => 'Application Declined',
    };

    String defaultDesc = switch (stage) {
      ApplicationStatus.applied => 'Your application was received by the startup.',
      ApplicationStatus.underReview => 'The founder is reviewing your qualifications and resume.',
      ApplicationStatus.shortlisted => 'Your profile matches their criteria. Preparing next steps.',
      ApplicationStatus.interviewScheduled => 'An interview has been scheduled. Check your email.',
      ApplicationStatus.accepted => 'Congratulations! You have been accepted for this role.',
      ApplicationStatus.rejected => 'Thank you for your interest. The startup has chosen other candidates.',
    };

    Color stepColor = isCompleted
        ? (stage == ApplicationStatus.rejected ? theme.colorScheme.error : theme.colorScheme.primary)
        : theme.colorScheme.outlineVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step line and bullet indicators
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted ? stepColor : theme.colorScheme.surfaceContainerLowest,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: stepColor,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? stepColor : theme.colorScheme.outlineVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),

          // Content card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isActive ? stepColor : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (event != null)
                        Text(
                          _formatDate(event.time),
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event?.notes ?? defaultDesc,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isCompleted ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
