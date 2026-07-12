import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../internships/models/opportunity.dart';
import '../../providers/startup_providers.dart';

class ManageOpportunitiesScreen extends ConsumerWidget {
  const ManageOpportunitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final startupAsync = ref.watch(currentFounderStartupStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Postings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Post New Position',
            onPressed: () => context.push('/startup/opportunities/create'),
          ),
        ],
      ),
      body: startupAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading startup: $err')),
        data: (startup) {
          if (startup == null) {
            return const Center(child: Text('No startup profile found. Please create one.'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(FirestoreCollections.internships)
                .where('startupId', isEqualTo: startup.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.post_add, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No postings yet',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create your first internship posting to connect with ALU students.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/startup/opportunities/create'),
                          icon: const Icon(Icons.add),
                          label: const Text('Post an Internship'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final opportunities = docs
                  .map((doc) => Opportunity.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
                  .toList();

              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.marginMobile),
                itemCount: opportunities.length,
                itemBuilder: (context, idx) {
                  final opp = opportunities[idx];
                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(AppSpacing.md),
                      title: Text(opp.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${opp.type} • ${opp.location}', style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildStatusChip(context, opp.status),
                              const Spacer(),
                              Text(
                                'Deadline: ${opp.applicationDeadline == null ? 'Always Open' : '${opp.applicationDeadline!.day}/${opp.applicationDeadline!.month}/${opp.applicationDeadline!.year}'}',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (val) async {
                          if (val == 'edit') {
                            context.push('/startup/opportunities/edit/${opp.id}');
                          } else if (val == 'close') {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Close Internship?'),
                                content: const Text('This will set the listing as expired. Students will no longer be able to apply.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Close Posting'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection(FirestoreCollections.internships)
                                  .doc(opp.id)
                                  .update({'status': OpportunityStatus.expired.name});
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('Edit Listing'),
                              ],
                            ),
                          ),
                          if (opp.status != OpportunityStatus.expired)
                            const PopupMenuItem(
                              value: 'close',
                              child: Row(
                                children: [
                                  Icon(Icons.cancel_outlined, color: Colors.red, size: 18),
                                  SizedBox(width: 8),
                                  Text('Close / Expire', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                        ],
                      ),
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

  Widget _buildStatusChip(BuildContext context, OpportunityStatus status) {
    final theme = Theme.of(context);
    Color color;
    Color bgColor;

    switch (status) {
      case OpportunityStatus.approved:
        color = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        break;
      case OpportunityStatus.pendingReview:
        color = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        break;
      case OpportunityStatus.rejected:
        color = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
        break;
      case OpportunityStatus.expired:
        color = Colors.grey;
        bgColor = Colors.grey.withOpacity(0.1);
        break;
      case OpportunityStatus.draft:
        color = theme.colorScheme.primary;
        bgColor = theme.colorScheme.primary.withOpacity(0.1);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
