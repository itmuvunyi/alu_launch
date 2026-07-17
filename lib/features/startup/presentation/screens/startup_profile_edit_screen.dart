import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


import '../../../../core/theme/app_spacing.dart';
import '../../../authentication/providers/auth_providers.dart';
import '../../models/startup.dart';
import '../../providers/startup_providers.dart';
import '../../providers/startup_upload_controllers.dart';

class StartupProfileEditScreen extends ConsumerStatefulWidget {
  const StartupProfileEditScreen({super.key});

  @override
  ConsumerState<StartupProfileEditScreen> createState() => _StartupProfileEditScreenState();
}

class _classStateHelper {
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController industryController;
  late TextEditingController websiteController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
}

class _StartupProfileEditScreenState extends ConsumerState<StartupProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _helper = _classStateHelper();
  String? _logoUrl;
  bool _initialized = false;
  String? _startupId;
  bool _isPickingLogo = false;

  @override
  void initState() {
    super.initState();
    _helper.nameController = TextEditingController();
    _helper.descController = TextEditingController();
    _helper.industryController = TextEditingController();
    _helper.websiteController = TextEditingController();
    _helper.phoneController = TextEditingController();
    _helper.locationController = TextEditingController();
  }

  @override
  void dispose() {
    _helper.nameController.dispose();
    _helper.descController.dispose();
    _helper.industryController.dispose();
    _helper.websiteController.dispose();
    _helper.phoneController.dispose();
    _helper.locationController.dispose();
    super.dispose();
  }

  void _initFields(Startup? startup) {
    if (_initialized) return;
    _initialized = true;
    if (startup != null) {
      _startupId = startup.id;
      _helper.nameController.text = startup.name;
      _helper.descController.text = startup.description;
      _helper.industryController.text = startup.industry;
      _helper.websiteController.text = startup.website ?? '';
      _helper.phoneController.text = startup.phone ?? '';
      _helper.locationController.text = startup.location;
      _logoUrl = startup.logoUrl;
    } else {
      _startupId = FirebaseFirestore.instance.collection('startups').doc().id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startupAsync = ref.watch(currentFounderStartupStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Startup Profile'),
      ),
      body: startupAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading profile: $err')),
        data: (startup) {
          _initFields(startup);

          final uploadState = ref.watch(startupLogoUploadControllerProvider(_startupId!));

          ref.listen<AsyncValue<String?>>(startupLogoUploadControllerProvider(_startupId!), (prev, next) {
            next.whenOrNull(
              error: (err, stack) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logo upload failed: $err')),
                );
              },
              data: (url) {
                if (url != null) {
                  setState(() {
                    _logoUrl = url;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logo uploaded successfully!')),
                  );
                }
              },
            );
          });

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Uploader Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: uploadState.isLoading || _isPickingLogo
                                ? null
                                : () async {
                                    if (_isPickingLogo) return;
                                    _isPickingLogo = true;
                                    XFile? image;
                                    try {
                                      debugPrint('Startup logo upload: Image picking initiated.');
                                      final picker = ImagePicker();
                                      image = await picker.pickImage(source: ImageSource.gallery);
                                    } catch (pickerError) {
                                      debugPrint('Startup logo upload: Picker platform exception -> $pickerError');
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Image picker error: $pickerError')),
                                        );
                                      }
                                    } finally {
                                      setState(() {
                                        _isPickingLogo = false;
                                      });
                                    }
                                    if (image == null) {
                                      debugPrint('Startup logo upload: Image picking cancelled or failed.');
                                      return;
                                    }

                                    try {
                                      debugPrint('Startup logo upload: Image selected -> ${image.name}');
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Image selected: ${image.name}')),
                                        );
                                      }

                                      final bytes = await image.readAsBytes();
                                      debugPrint('Startup logo upload: Supabase Storage upload started.');
                                      await ref
                                          .read(startupLogoUploadControllerProvider(_startupId!).notifier)
                                          .upload(
                                            bytes: bytes,
                                            contentType: image.mimeType ?? 'image/png',
                                            fileName: image.name,
                                          );
                                      debugPrint('Startup logo upload: Supabase Storage upload completed & Firestore URL persisted successfully!');

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Logo uploaded successfully!')),
                                        );
                                      }
                                    } catch (e) {
                                      debugPrint('Startup logo upload: Failed -> $e');
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Logo upload failed: $e')),
                                        );
                                      }
                                    }
                                  },
                            child: Stack(
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surfaceContainer,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: theme.colorScheme.outlineVariant),
                                  ),
                                  child: _logoUrl != null
                                      ? ClipOval(
                                          child: Image.network(_logoUrl!, fit: BoxFit.cover),
                                        )
                                      : Icon(Icons.business, size: 48, color: theme.colorScheme.onSurfaceVariant),
                                ),
                                if (uploadState.isLoading)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black38,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(color: Colors.white),
                                      ),
                                    ),
                                  )
                                else
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: theme.colorScheme.primary,
                                      child: const Icon(Icons.edit, size: 16, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Startup Logo',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Click to upload or update logo image',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Company details fields
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Company Details',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextFormField(
                            controller: _helper.nameController,
                            decoration: const InputDecoration(
                              labelText: 'Company Name *',
                              prefixIcon: Icon(Icons.business),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _helper.industryController,
                            decoration: const InputDecoration(
                              labelText: 'Industry * (e.g. EdTech, FinTech, AgriTech)',
                              prefixIcon: Icon(Icons.category_outlined),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _helper.locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location * (e.g. Kigali, Rwanda / Remote)',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _helper.descController,
                            decoration: const InputDecoration(
                              labelText: 'About Startup / Mission Statement *',
                              prefixIcon: Icon(Icons.description_outlined),
                            ),
                            maxLines: 4,
                            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Contact / Links card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Info & Links',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextFormField(
                            controller: _helper.websiteController,
                            decoration: const InputDecoration(
                              labelText: 'Website URL',
                              prefixIcon: Icon(Icons.language),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _helper.phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      final currentUser = ref.read(currentUserProvider).valueOrNull;
                      if (currentUser == null) return;

                      final updatedStartup = Startup(
                        id: _startupId!,
                        ownerId: currentUser.uid,
                        name: _helper.nameController.text.trim(),
                        description: _helper.descController.text.trim(),
                        logoUrl: _logoUrl,
                        industry: _helper.industryController.text.trim(),
                        website: _helper.websiteController.text.trim(),
                        email: currentUser.email,
                        phone: _helper.phoneController.text.trim(),
                        location: _helper.locationController.text.trim(),
                        isVerified: startup?.isVerified ?? false,
                        createdAt: startup?.createdAt ?? DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      try {
                        final repo = ref.read(startupRepositoryProvider);
                        if (startup == null) {
                          await repo.createStartup(updatedStartup);
                        } else {
                          await repo.updateStartup(updatedStartup);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Startup profile saved successfully!')),
                        );
                        context.pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save profile: $e')),
                        );
                      }
                    },
                    child: const Text('Save Profile'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
