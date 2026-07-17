import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../startup/models/startup.dart';
import '../../../startup/providers/startup_upload_controllers.dart';

final unverifiedStartupsStreamProvider = StreamProvider.autoDispose<List<Startup>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection(FirestoreCollections.startups)
      .where('isVerified', isEqualTo: false)
      .snapshots()
      .map((snapshot) {
    final docs = snapshot.docs.where((doc) {
      final data = doc.data();
      return data.containsKey('verificationDocPath') && data['verificationDocPath'] != null;
    }).toList();

    return docs.map((doc) => Startup.fromJson({...doc.data(), 'id': doc.id})).toList();
  });
});

class StartupVerificationApprovalScreen extends ConsumerWidget {
  const StartupVerificationApprovalScreen({super.key});

  Future<void> _approveStartup(BuildContext context, WidgetRef ref, Startup startup) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verify Startup?'),
        content: Text('This will verify "${startup.name}" and grant them access to publish approved opportunities.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Verify')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(firestoreProvider)
            .collection(FirestoreCollections.startups)
            .doc(startup.id)
            .update({'isVerified': true});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Startup "${startup.name}" successfully verified!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify: $e')),
        );
      }
    }
  }

  Future<void> _rejectStartup(BuildContext context, WidgetRef ref, Startup startup) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Verification?'),
        content: Text('This will reject the verification request for "${startup.name}" and clear their registration document path.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Reject Request')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(firestoreProvider)
            .collection(FirestoreCollections.startups)
            .doc(startup.id)
            .update({
          'isVerified': false,
          'verificationDocPath': null,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification rejected for "${startup.name}".')),
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
    final startupsAsync = ref.watch(unverifiedStartupsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Verification Approvals'),
      ),
      body: startupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (startups) {
          if (startups.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 64, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text('No pending verifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('All submitted startup registration documents have been reviewed.', textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            itemCount: startups.length,
            itemBuilder: (context, idx) {
              final startup = startups[idx];

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ExpansionTile(
                  title: Text(startup.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text('${startup.industry} • ${startup.location}', style: theme.textTheme.bodyMedium),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Divider(),
                          Text('About Startup:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(startup.description, style: theme.textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.md),
                          _buildDetailRow(context, 'Founder Email', startup.email),
                          _buildDetailRow(context, 'Phone', startup.phone ?? 'Not provided'),
                          _buildDetailRow(context, 'Website', startup.website ?? 'None'),
                          const SizedBox(height: AppSpacing.md),

                          // Load Signed Document URL from Supabase Storage
                          Consumer(
                            builder: (context, ref, child) {
                              return ref.watch(verificationDocSignedUrlProvider(startup.verificationDocPath!)).when(
                                    loading: () => const Center(child: CircularProgressIndicator()),
                                    error: (err, st) => Text('Error loading document: $err', style: TextStyle(color: theme.colorScheme.error)),
                                    data: (signedUrl) => Container(
                                      padding: const EdgeInsets.all(AppSpacing.md),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceContainer,
                                        borderRadius: BorderRadius.circular(AppRadius.md),
                                        border: Border.all(color: theme.colorScheme.outlineVariant),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.picture_as_pdf, color: theme.colorScheme.primary, size: 28),
                                          const SizedBox(width: AppSpacing.md),
                                          const Expanded(
                                            child: Text('Verification_Document.pdf', style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              final url = Uri.parse(signedUrl);
                                              try {
                                                await launchUrl(url, mode: LaunchMode.externalApplication);
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Could not open document: $e')),
                                                  );
                                                }
                                              }
                                            },
                                            icon: const Icon(Icons.open_in_new, size: 16),
                                            label: const Text('Open PDF'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                            },
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
                                icon: const Icon(Icons.cancel_outlined, size: 16),
                                label: const Text('Reject'),
                                onPressed: () => _rejectStartup(context, ref, startup),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.verified_outlined, size: 16),
                                label: const Text('Verify Startup'),
                                onPressed: () => _approveStartup(context, ref, startup),
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

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
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
