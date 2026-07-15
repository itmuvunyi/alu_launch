import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../internships/models/opportunity.dart';
import '../../../internships/providers/internship_providers.dart';
import '../../../../core/providers/firebase_providers.dart';

class StudentExploreScreen extends ConsumerStatefulWidget {
  const StudentExploreScreen({super.key});

  @override
  ConsumerState<StudentExploreScreen> createState() => _StudentExploreScreenState();
}

class _StudentExploreScreenState extends ConsumerState<StudentExploreScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Filters
  String? _selectedLocation;
  String? _selectedType;

  final List<String> _locations = ['Kigali', 'Mauritius', 'Remote'];
  final List<String> _types = ['Internship', 'Part-time', 'Full-time'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opportunitiesAsync = ref.watch(opportunitiesStreamProvider);
    final bookmarkedIds = ref.watch(bookmarkedIdsStreamProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Opportunities'),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search internships, startup name...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim().toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Location Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'Location: ',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ..._locations.map((loc) {
                        final selected = _selectedLocation == loc;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(loc),
                            selected: selected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedLocation = selected ? loc : null;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),

                // Type Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'Type: ',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ..._types.map((type) {
                        final selected = _selectedType == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(type),
                            selected: selected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedType = selected ? type : null;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Opportunities List
          Expanded(
            child: opportunitiesAsync.when(
              data: (opportunities) {
                // Apply search and filters in-memory
                final filtered = opportunities.where((opp) {
                  final matchesSearch = opp.title.toLowerCase().contains(_searchQuery) ||
                      opp.startupName.toLowerCase().contains(_searchQuery) ||
                      opp.description.toLowerCase().contains(_searchQuery) ||
                      opp.skillsRequired.any((skill) => skill.toLowerCase().contains(_searchQuery));

                  final matchesLocation = _selectedLocation == null ||
                      opp.location.toLowerCase() == _selectedLocation!.toLowerCase();

                  final matchesType = _selectedType == null ||
                      opp.type.toLowerCase() == _selectedType!.toLowerCase();

                  return matchesSearch && matchesLocation && matchesType;
                }).toList();

                if (filtered.isEmpty) {
                  return _buildEmptyState(context);
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final opp = filtered[index];
                    final isBookmarked = bookmarkedIds.contains(opp.id);
                    return _buildOpportunityCard(context, opp, isBookmarked);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error loading opportunities: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard(BuildContext context, Opportunity opp, bool isBookmarked) {
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
              const SizedBox(height: AppSpacing.sm),
              // Description excerpt
              Text(
                opp.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No matching opportunities found',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Try adjusting your search filters or text.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
