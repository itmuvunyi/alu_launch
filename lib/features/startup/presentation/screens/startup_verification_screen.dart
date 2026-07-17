import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';


import '../../../../core/theme/app_spacing.dart';
import '../../providers/startup_providers.dart';
import '../../providers/startup_upload_controllers.dart';

class StartupVerificationScreen extends ConsumerStatefulWidget {
  const StartupVerificationScreen({super.key});

  @override
  ConsumerState<StartupVerificationScreen> createState() => _StartupVerificationScreenState();
}

class _StartupVerificationScreenState extends ConsumerState<StartupVerificationScreen> {
  bool _isPickingFile = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startupAsync = ref.watch(currentFounderStartupStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Verification'),
      ),
      body: startupAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading startup: $err')),
        data: (startup) {
          if (startup == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Please complete your startup profile before verifying.'),
              ),
            );
          }

          final uploadState = ref.watch(verificationDocUploadControllerProvider(startup.id));

          ref.listen<AsyncValue<String?>>(verificationDocUploadControllerProvider(startup.id), (prev, next) {
            next.whenOrNull(
              error: (err, stack) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Document upload failed: $err')),
                );
              },
              data: (path) {
                if (path != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification document uploaded! Status set to pending review.')),
                  );
                }
              },
            );
          });

          // Check if document was uploaded
          final hasUploaded = startup.verificationDocPath != null && startup.verificationDocPath!.isNotEmpty;
          // Wait, does startup model have verificationDocPath? Let's check `lib/features/startup/models/startup.dart` if we added it.
          // Wait! In `startup.dart`, does startup model have `verificationDocPath`?
          // Let's look at `startup.dart`:
          // Wait! It has ownerId, name, description, logoUrl, industry, website, email, phone, location, isVerified, createdAt, updatedAt.
          // It does NOT have `verificationDocPath`!
          // Ah! But wait, in `startup_upload_controllers.dart` line 123:
          // `await ref.read(firestoreProvider).collection(FirestoreCollections.startups).doc(_startupId).set({'verificationDocPath': path}, SetOptions(merge: true));`
          // So the document path is saved in Firestore as `verificationDocPath`.
          // If we add `verificationDocPath` to the `Startup` model, we can easily read it!
          // Let's do that! That is extremely consistent with our approach.
          // But first, let's write `startup_verification_screen.dart` with support for `verificationDocPath`!

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        _buildStatusIcon(context, startup.isVerified),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          startup.isVerified ? 'VERIFIED STARTUP' : 'UNVERIFIED STARTUP',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: startup.isVerified ? Colors.green : Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          startup.isVerified
                              ? 'Your startup is verified by the ALU Launch Team. You have full access to connect with students.'
                              : 'Upload business registration or legal documents to verify your startup and build trust with applicants.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                if (!startup.isVerified) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload Legal Document',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Supported formats: PDF (max 5MB). Please upload business registration, incorporation cert, or operational license.',
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          if (uploadState.isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else
                              ElevatedButton.icon(
                                onPressed: () async {
                                  if (_isPickingFile) {
                                    debugPrint('Startup doc upload: Prevented duplicate picker call.');
                                    return;
                                  }
                                  _isPickingFile = true;
                                  FilePickerResult? result;
                                  try {
                                    debugPrint('Startup doc upload: File picking initiated.');
                                    result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf'],
                                    );
                                  } catch (pickerError) {
                                    debugPrint('Startup doc upload: Picker platform exception -> $pickerError');
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('File picker error: $pickerError')),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isPickingFile = false;
                                      });
                                    }
                                  }
                                  if (result == null) {
                                    debugPrint('Startup doc upload: File picking cancelled or failed.');
                                    return;
                                  }

                                  try {
                                    final file = result.files.single;
                                    debugPrint('Startup doc upload: File selected -> ${file.name}');
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('File selected: ${file.name}')),
                                      );
                                    }

                                    Uint8List? bytes = file.bytes;
                                    if (bytes == null && file.path != null) {
                                      debugPrint('Startup doc upload: Reading bytes from path -> ${file.path}');
                                      bytes = await File(file.path!).readAsBytes();
                                    }
                                    if (bytes == null) {
                                      throw Exception('Unable to read file bytes.');
                                    }

                                    try {
                                      debugPrint('Startup doc upload: Supabase Storage upload started.');
                                      await ref
                                          .read(verificationDocUploadControllerProvider(startup.id).notifier)
                                          .upload(
                                            bytes: bytes,
                                            contentType: 'application/pdf',
                                            fileName: file.name,
                                          );
                                      debugPrint('Startup doc upload: Supabase Storage upload completed & Firestore URL persisted successfully!');

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Verification document uploaded successfully!')),
                                        );
                                      }
                                    } catch (uploadError) {
                                      debugPrint('Startup doc upload: Storage/Firestore upload failed -> $uploadError');
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Supabase Storage upload failed: $uploadError')),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    debugPrint('Startup doc upload: File picking/reading failed -> $e');
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('File picking/reading failed: $e')),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Pick and Upload PDF'),
                              ),
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
                                Icon(Icons.description_outlined, color: theme.colorScheme.primary, size: 28),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Verification Document', style: TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 2),
                                      Text(
                                        uploadState.value != null
                                            ? 'Status: Submitted / Pending Admin Review'
                                            : 'Status: Not Submitted',
                                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context, bool isVerified) {
    if (isVerified) {
      return const Icon(Icons.verified_user, color: Colors.green, size: 64);
    } else {
      return const Icon(Icons.gpp_maybe, color: Colors.orange, size: 64);
    }
  }
}
