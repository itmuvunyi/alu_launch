import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../internships/providers/internship_providers.dart';
import '../../providers/startup_providers.dart';



class StartupProfileReadOnlyScreen extends ConsumerWidget {
  const StartupProfileReadOnlyScreen({required this.startupId, super.key});

  final String startupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final startupAsync = ref.watch(startupDetailsStreamProvider(startupId));
    final opportunitiesAsync = ref.watch(opportunitiesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Profile'),
      ),
      body: startupAsync.when(
        data: (startup) {
          if (startup == null) {
            return const Center(child: Text('Startup profile not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header (Logo + Name + Industry + Location)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            shape: BoxShape.circle,
                          ),
                          child: startup.logoUrl != null
                              ? ClipOval(
                                  child: Image.network(startup.logoUrl!, fit: BoxFit.cover),
                                )
                              : Icon(Icons.business, size: 40, color: theme.colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          startup.name,
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          startup.industry,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              startup.location,
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        if (startup.website != null && startup.website!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(120, 36),
                            ),
                            icon: const Icon(Icons.language, size: 16),
                            label: const Text('Visit Website'),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Opening website: ${startup.website}')),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // About section
                Text(
                  'About the Startup',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  startup.description,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Open Roles section
                Text(
                  'Open Internship Opportunities',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.sm),

                opportunitiesAsync.when(
                  data: (opportunities) {
                    final startupOpps = opportunities.where((o) => o.startupId == startupId).toList();
                    if (startupOpps.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        child: Text(
                          'No active opportunities at the moment.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: startupOpps.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final opp = startupOpps[index];
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                            title: Text(opp.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('${opp.type} • ${opp.location}'),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () => context.push('/student/opportunity/${opp.id}'),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text('Error loading opportunities: $error'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error loading startup profile: $error')),
      ),
    );
  }
}
