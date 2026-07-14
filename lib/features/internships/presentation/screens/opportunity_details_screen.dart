import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../providers/internship_providers.dart';
import '../../../applications/providers/application_providers.dart';
import '../../../authentication/providers/auth_providers.dart';
import '../../../messages/providers/message_providers.dart';
import '../../models/opportunity.dart';

class OpportunityDetailsScreen extends ConsumerStatefulWidget {
  const OpportunityDetailsScreen({required this.opportunityId, super.key});

  final String opportunityId;

  @override
  ConsumerState<OpportunityDetailsScreen> createState() => _OpportunityDetailsScreenState();
}

class _OpportunityDetailsScreenState extends ConsumerState<OpportunityDetailsScreen> {
  bool _isSubmitting = false;

  Future<void> _handleApply(Opportunity opp) async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(applyControllerProvider.notifier).submit(
            opportunityId: opp.id,
            opportunityTitle: opp.title,
            startupId: opp.startupId,
            startupName: opp.startupName,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application submitted successfully!')),
      );
      Navigator.of(context).pop(); // Close bottom sheet
      context.go('/student/applications');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit application: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showApplyBottomSheet(Opportunity opp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
        return Consumer(
          builder: (context, ref, child) {
            final user = ref.watch(currentUserProvider).valueOrNull;
            final resumeUrl = user?.resumeUrl;
            final hasResume = resumeUrl != null && resumeUrl.isNotEmpty;
            final portfolioUrls = user?.portfolioUrls ?? [];
            final hasPortfolio = portfolioUrls.isNotEmpty;

            return StatefulBuilder(
              builder: (context, setModalState) {
                return Container(
                  padding: EdgeInsets.only(
                    left: AppSpacing.marginMobile,
                    right: AppSpacing.marginMobile,
                    top: AppSpacing.lg,
                    bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Apply for ${opp.title}',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'at ${opp.startupName}',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Resume & Portfolio Verification Card
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: hasResume
                              ? theme.colorScheme.primaryContainer.withOpacity(0.05)
                              : theme.colorScheme.errorContainer.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: hasResume
                                ? theme.colorScheme.primary.withOpacity(0.3)
                                : theme.colorScheme.error.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  hasResume ? Icons.check_circle_outline : Icons.error_outline,
                                  color: hasResume ? theme.colorScheme.primary : theme.colorScheme.error,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Required Documents',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: hasResume ? theme.colorScheme.primary : theme.colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            if (hasResume) ...[
                              Text(
                                '✓ Resume is ready for submission.',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface),
                              ),
                              if (hasPortfolio) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '✓ ${portfolioUrls.length} portfolio link(s) will be attached.',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface),
                                ),
                              ] else ...[
                                const SizedBox(height: 4),
                                Text(
                                  'ℹ No portfolio links uploaded (optional).',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ] else ...[
                              Text(
                                'No resume uploaded! You must upload a resume PDF in your profile tab before you can apply for this internship.',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      ElevatedButton(
                        onPressed: (!hasResume || _isSubmitting)
                            ? null
                            : () async {
                                setModalState(() => _isSubmitting = true);
                                await _handleApply(opp);
                              },
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Submit Application'),
                      ),
                      if (!hasResume) ...[
                        const SizedBox(height: AppSpacing.md),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close bottom sheet
                            context.go('/student/profile');
                          },
                          child: const Text('Go to Profile to Upload'),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opportunityAsync = ref.watch(opportunityDetailsProvider(widget.opportunityId));
    final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).valueOrNull ?? [];
    final isBookmarked = bookmarkedIds.contains(widget.opportunityId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
        actions: opportunityAsync.whenOrNull(
          data: (opp) => [
            if (opp != null)
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? theme.colorScheme.primary : null,
                ),
                onPressed: () {
                  final userId = ref.read(currentUserIdProvider).valueOrNull;
                  if (userId != null) {
                    ref.read(internshipRepositoryProvider).toggleBookmark(
                          userId: userId,
                          opportunityId: opp.id,
                        );
                  }
                },
              ),
          ],
        ),
      ),
      body: opportunityAsync.when(
        data: (opp) {
          if (opp == null) {
            return const Center(child: Text('Opportunity not found'));
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.marginMobile,
                  right: AppSpacing.marginMobile,
                  top: AppSpacing.md,
                  bottom: 100, // height for bottom apply bar
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Startup Info Row
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: opp.startupLogoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                  child: Image.network(opp.startupLogoUrl!, fit: BoxFit.cover),
                                )
                              : Icon(Icons.business, size: 32, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opp.title,
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              GestureDetector(
                                onTap: () => context.push('/student/startup/${opp.startupId}'),
                                child: Text(
                                  opp.startupName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Quick metadata chips
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        _buildMetaBadge(context, Icons.work_outline, opp.type),
                        _buildMetaBadge(context, Icons.location_on_outlined, opp.location),
                        _buildMetaBadge(context, Icons.timelapse, opp.duration),
                        if (opp.stipend != null)
                          _buildMetaBadge(context, Icons.monetization_on_outlined, opp.stipend!),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Description section
                    Text(
                      'Job Description',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      opp.description,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Requirements
                    Text(
                      'Requirements',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...opp.requirements.map(
                      (req) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Expanded(child: Text(req, style: theme.textTheme.bodyLarge)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Responsibilities (if any)
                    if (opp.responsibilities != null && opp.responsibilities!.isNotEmpty) ...[
                      Text(
                        'Key Responsibilities',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...opp.responsibilities!.map(
                        (resp) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Expanded(child: Text(resp, style: theme.textTheme.bodyLarge)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],

                    // Skills Required
                    Text(
                      'Skills Required',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: opp.skillsRequired.map((skill) {
                        return Chip(
                          label: Text(skill),
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          labelStyle: theme.textTheme.bodyMedium,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Bottom Apply Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        offset: const Offset(0, -4),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(16),
                        ),
                        onPressed: () async {
                          final user = ref.read(currentUserProvider).valueOrNull;
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please sign in to message recruiters.')),
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
                                  studentId: user.uid,
                                  studentName: user.displayName,
                                  studentPhotoUrl: user.photoUrl,
                                  startupId: opp.startupId,
                                  startupName: opp.startupName,
                                  startupLogoUrl: opp.startupLogoUrl,
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
                        child: Icon(Icons.chat_bubble_outline, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showApplyBottomSheet(opp),
                          child: const Text('Apply For This Position'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading details: $error')),
      ),
    );
  }

  Widget _buildMetaBadge(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
