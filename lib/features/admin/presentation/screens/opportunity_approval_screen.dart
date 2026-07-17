import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../internships/models/opportunity.dart';

class OpportunityApprovalScreen extends ConsumerWidget {
  const OpportunityApprovalScreen({super.key});

  Future<void> _approveOpportunity(BuildContext context, Opportunity opp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Listing?'),
        content: Text('This will publish the internship position "${opp.title}" and make it visible to all students.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Approve')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final batch = FirebaseFirestore.instance.batch();

        // 1. Update listing status to approved
        final oppRef = FirebaseFirestore.instance
            .collection(FirestoreCollections.internships)
            .doc(opp.id);
        batch.update(oppRef, {'status': OpportunityStatus.approved.name});

        // 2. Fetch all student users to generate notifications
        final studentsSnapshot = await FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .where('role', isEqualTo: 'student')
            .get();

        for (var doc in studentsSnapshot.docs) {
          final notifyRef = FirebaseFirestore.instance
              .collection(FirestoreCollections.notifications)
              .doc();
          batch.set(notifyRef, {
            'userId': doc.id,
            'title': 'New Opportunity: ${opp.title}',
            'body': '${opp.startupName} is looking for a ${opp.title}! Tap to view and apply.',
            'type': 'newOpportunity',
            'payload': {
              'opportunityId': opp.id,
            },
            'isRead': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        await batch.commit();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Internship "${opp.title}" successfully published and students notified!')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to publish: $e')),
          );
        }
      }
    }
  }

  Future<void> _rejectOpportunity(BuildContext context, Opportunity opp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Listing?'),
        content: Text('This will reject the internship listing for "${opp.title}" and keep it hidden from students.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Reject')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.internships)
            .doc(opp.id)
            .update({'status': OpportunityStatus.rejected.name});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Listing "${opp.title}" has been rejected.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reject: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship Listing Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.internships)
            .where('status', isEqualTo: OpportunityStatus.pendingReview.name)
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
                    Icon(Icons.rate_review_outlined, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text('No listings to review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('All submitted internships have been moderated.', textAlign: TextAlign.center),
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
                child: ExpansionTile(
                  title: Text(opp.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text('Posted by: ${opp.startupName} • ${opp.type}', style: theme.textTheme.bodyMedium),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Divider(),
                          _buildSectionTitle(context, 'Description:'),
                          const SizedBox(height: 4),
                          Text(opp.description, style: theme.textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.md),
                          _buildSectionTitle(context, 'Requirements:'),
                          const SizedBox(height: 4),
                          ...opp.requirements.map((req) => Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text('• $req', style: theme.textTheme.bodyMedium),
                              )),
                          const SizedBox(height: AppSpacing.md),
                          _buildSectionTitle(context, 'Skills Needed:'),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: opp.skillsRequired
                                .map((skill) => Chip(
                                      label: Text(skill, style: const TextStyle(fontSize: 11)),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Location: ${opp.location}',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                              Text(
                                'Stipend: ${opp.stipend ?? 'Unpaid'}',
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                                icon: const Icon(Icons.close, size: 16),
                                label: const Text('Reject Listing'),
                                onPressed: () => _rejectOpportunity(context, opp),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.check, size: 16),
                                label: const Text('Approve & Publish'),
                                onPressed: () => _approveOpportunity(context, opp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
