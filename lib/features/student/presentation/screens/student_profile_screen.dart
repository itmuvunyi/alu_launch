import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../authentication/providers/auth_providers.dart';
import '../../../profile/providers/student_upload_controllers.dart';
import '../../../applications/providers/application_providers.dart';
import '../../../applications/models/application.dart';

class StudentProfileScreen extends ConsumerStatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  ConsumerState<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends ConsumerState<StudentProfileScreen> {
  // Experience adding dialog helper
  Future<void> _addExperienceDialog(BuildContext context, String userId, List<Map<String, dynamic>> currentExp) async {
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final durationController = TextEditingController();
    final descController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Experience'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Job Title (e.g. Software Engineer)')),
              TextField(controller: companyController, decoration: const InputDecoration(labelText: 'Company (e.g. Google)')),
              TextField(controller: durationController, decoration: const InputDecoration(labelText: 'Duration (e.g. Jun 2023 - Present)')),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Add')),
        ],
      ),
    );

    if (confirm == true && titleController.text.isNotEmpty && companyController.text.isNotEmpty) {
      final newExp = {
        'title': titleController.text.trim(),
        'company': companyController.text.trim(),
        'duration': durationController.text.trim(),
        'description': descController.text.trim(),
      };

      final updatedList = List<Map<String, dynamic>>.from(currentExp)..add(newExp);

      try {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(userId)
            .update({'experiences': updatedList});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Experience added!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  // Experience deletion helper
  Future<void> _deleteExperience(BuildContext context, String userId, List<Map<String, dynamic>> currentExp, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Experience?'),
        content: const Text('Are you sure you want to remove this experience?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      final updatedList = List<Map<String, dynamic>>.from(currentExp)..removeAt(index);
      try {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(userId)
            .update({'experiences': updatedList});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  // Portfolio project adding helper
  Future<void> _addProjectDialog(BuildContext context, String userId, List<Map<String, dynamic>> currentProj) async {
    final titleController = TextEditingController();
    final techController = TextEditingController();
    final imageController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Portfolio Project'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Project Title')),
              TextField(controller: techController, decoration: const InputDecoration(labelText: 'Technologies (e.g. Flutter, Firebase)')),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL (optional)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Add')),
        ],
      ),
    );

    if (confirm == true && titleController.text.isNotEmpty) {
      final defaultImage = 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=600&q=80';
      final newProj = {
        'title': titleController.text.trim(),
        'subtitle': techController.text.trim().isEmpty ? 'General Project' : techController.text.trim(),
        'imageUrl': imageController.text.trim().isEmpty ? defaultImage : imageController.text.trim(),
      };

      final updatedList = List<Map<String, dynamic>>.from(currentProj)..add(newProj);

      try {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(userId)
            .update({'projects': updatedList});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save project: $e')),
        );
      }
    }
  }

  // Project deletion helper
  Future<void> _deleteProject(BuildContext context, String userId, List<Map<String, dynamic>> currentProj, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project?'),
        content: const Text('Are you sure you want to remove this project from your portfolio?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      final updatedList = List<Map<String, dynamic>>.from(currentProj)..removeAt(index);
      try {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(userId)
            .update({'projects': updatedList});
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  // Edit Info Dialog
  Future<void> _editInfoDialog(BuildContext context, String userId, String currentName, String currentHeadline, String currentCampus) async {
    final nameController = TextEditingController(text: currentName);
    final headlineController = TextEditingController(text: currentHeadline);
    final campusController = TextEditingController(text: currentCampus);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile Info'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Display Name')),
              TextField(controller: headlineController, decoration: const InputDecoration(labelText: 'Professional Headline')),
              TextField(controller: campusController, decoration: const InputDecoration(labelText: 'Campus Location (e.g. Kigali, Rwanda)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Save')),
        ],
      ),
    );

    if (confirm == true && nameController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(userId)
            .update({
          'displayName': nameController.text.trim(),
          'headline': headlineController.text.trim(),
          'campus': campusController.text.trim(),
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    }
  }

  // Add Skill Dialog
  Future<void> _addSkillDialog(BuildContext context, String userId, List<String> currentSkills) async {
    final skillController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Skill'),
        content: TextField(
          controller: skillController,
          decoration: const InputDecoration(labelText: 'Skill (e.g. Python, SQL, UI Design)'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Add')),
        ],
      ),
    );

    if (confirm == true && skillController.text.isNotEmpty) {
      final cleanSkill = skillController.text.trim();
      if (!currentSkills.contains(cleanSkill)) {
        final updatedList = List<String>.from(currentSkills)..add(cleanSkill);
        try {
          await FirebaseFirestore.instance
              .collection(FirestoreCollections.users)
              .doc(userId)
              .update({'skills': updatedList});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add skill: $e')),
          );
        }
      }
    }
  }

  // Delete Skill helper
  Future<void> _deleteSkill(BuildContext context, String userId, List<String> currentSkills, String skill) async {
    final updatedList = List<String>.from(currentSkills)..remove(skill);
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(userId)
          .update({'skills': updatedList});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove skill: $e')),
      );
    }
  }

  Future<void> _pickAndUploadResume() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        final file = result.files.single;
        Uint8List? bytes = file.bytes;
        if (bytes == null && file.path != null) {
          bytes = await File(file.path!).readAsBytes();
        }
        if (bytes == null) {
          throw Exception('Unable to read file bytes.');
        }

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        }

        await ref.read(resumeUploadControllerProvider.notifier).upload(
              bytes: bytes,
              contentType: 'application/pdf',
              fileName: file.name,
            );

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Resume uploaded successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload resume: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider).valueOrNull;
    final avatarState = ref.watch(avatarUploadControllerProvider);
    final applicationsAsync = ref.watch(studentApplicationsStreamProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final experiences = (user.experiences != null)
        ? List<Map<String, dynamic>>.from(user.experiences!)
        : <Map<String, dynamic>>[];

    final projects = (user.projects != null)
        ? List<Map<String, dynamic>>.from(user.projects!)
        : <Map<String, dynamic>>[];

    final skills = user.skills ?? <String>[];
    final headline = user.headline ?? 'No profile headline added yet';
    final location = user.campus ?? 'ALU Campus';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner & Overlay Profile Header Card
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Top Banner
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Overlay Profile Card
                Padding(
                  padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70, left: 16, right: 16, bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user.displayName.isNotEmpty ? user.displayName : 'Set Profile Name',
                                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                onPressed: () => _editInfoDialog(context, user.uid, user.displayName, headline, location),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            headline,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined, size: 16, color: theme.colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                '$location • African Leadership University',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(12),
                                ),
                                onPressed: () => context.push('/settings'),
                                child: Icon(Icons.settings_outlined, color: theme.colorScheme.primary),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(12),
                                ),
                                onPressed: () async {
                                  final hasResume = user.resumeUrl != null && user.resumeUrl!.isNotEmpty;
                                  if (hasResume) {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.open_in_new),
                                                title: const Text('View Current Resume'),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                  final url = Uri.parse(user.resumeUrl!);
                                                  if (await canLaunchUrl(url)) {
                                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                                  }
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.upload_file),
                                                title: const Text('Upload New Resume (PDF)'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _pickAndUploadResume();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    _pickAndUploadResume();
                                  }
                                },
                                child: Icon(
                                  Icons.description_outlined,
                                  color: user.resumeUrl != null && user.resumeUrl!.isNotEmpty
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Profile connection matches prototype.')),
                                  );
                                },
                                child: const Text('Connect', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Overlapping Avatar Image (Tap to navigate to settings)
                // Height constraints bounded at 108 to resolve box.dart assertions
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  height: 108,
                  child: Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () => context.push('/settings'),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: theme.colorScheme.surfaceContainer,
                              backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                                  ? NetworkImage(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null || user.photoUrl!.isEmpty
                                  ? Text(
                                      user.displayName.isNotEmpty
                                          ? user.displayName.substring(0, 1).toUpperCase()
                                          : 'S',
                                      style: theme.textTheme.headlineLarge?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        // Avatar picking overlay
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: avatarState.isLoading
                                ? null
                                : () async {
                                    final picker = ImagePicker();
                                    final image = await picker.pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      final bytes = await image.readAsBytes();
                                      await ref.read(avatarUploadControllerProvider.notifier).upload(
                                        bytes: bytes,
                                        contentType: image.mimeType ?? 'image/png',
                                        fileName: image.name,
                                      );
                                    }
                                  },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: theme.colorScheme.primary,
                              child: avatarState.isLoading
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.edit, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Experience Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.business_center_outlined, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text('Experience', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            onPressed: () => _addExperienceDialog(context, user.uid, experiences),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (experiences.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'No professional experience added yet. Tap "+" to add.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        )
                      else
                        ...experiences.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final exp = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: theme.colorScheme.surfaceContainer,
                                  child: Icon(Icons.domain, color: theme.colorScheme.primary),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(exp['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                                            onPressed: () => _deleteExperience(context, user.uid, experiences, idx),
                                          ),
                                        ],
                                      ),
                                      Text(exp['company'] ?? '', style: theme.textTheme.bodyMedium),
                                      Text(exp['duration'] ?? '', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                                      if (exp['description'] != null) ...[
                                        const SizedBox(height: 4),
                                        Text(exp['description']!, style: theme.textTheme.bodyMedium),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Portfolio Projects Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.grid_view_outlined, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text('Portfolio Projects', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            onPressed: () => _addProjectDialog(context, user.uid, projects),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (projects.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'No portfolio projects added yet. Tap "+" to add.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        )
                      else
                        ...projects.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final proj = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: _buildProjectCard(
                              context,
                              title: proj['title'] ?? '',
                              subtitle: proj['subtitle'] ?? '',
                              imageUrl: proj['imageUrl'] ?? '',
                              onDelete: () => _deleteProject(context, user.uid, projects, idx),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Skills Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.psychology_outlined, color: theme.colorScheme.primary),
                              const SizedBox(width: 8),
                              Text('Skills', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            onPressed: () => _addSkillDialog(context, user.uid, skills),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (skills.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'No skills added yet. Tap "+" to add.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: skills.map((skill) => Chip(
                                label: Text(skill),
                                backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.08),
                                labelStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                                onDeleted: () => _deleteSkill(context, user.uid, skills, skill),
                                deleteIconColor: Colors.red,
                              )).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Application Status Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.assessment_outlined, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('Application Status', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      applicationsAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, st) => Text('Error loading applications: $err'),
                        data: (apps) {
                          if (apps.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text('No active applications found. Apply to listings in Explore!'),
                            );
                          }

                          // Limit list to last 3 applications
                          final recentApps = apps.take(3).toList();

                          return Column(
                            children: [
                              ...recentApps.map((app) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(app.opportunityTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(app.startupName),
                                    trailing: _buildStatusPill(context, app.status),
                                    onTap: () => context.push('/student/applications/tracking/${app.id}'),
                                  )),
                              const Divider(),
                              TextButton(
                                onPressed: () {
                                  context.push('/student/applications');
                                },
                                child: const Text('View Full History'),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, {required String title, required String subtitle, required String imageUrl, required VoidCallback onDelete}) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: imageUrl.isNotEmpty
                ? Image.network(imageUrl, height: 140, fit: BoxFit.cover)
                : Container(height: 140, color: theme.colorScheme.surfaceContainerHigh, child: const Icon(Icons.image_outlined, size: 48)),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(BuildContext context, ApplicationStatus status) {
    final theme = Theme.of(context);
    Color color;
    Color bgColor;

    switch (status) {
      case ApplicationStatus.applied:
        color = theme.colorScheme.primary;
        bgColor = theme.colorScheme.primaryContainer;
        break;
      case ApplicationStatus.shortlisted:
        color = Colors.blue;
        bgColor = Colors.blue.withOpacity(0.15);
        break;
      case ApplicationStatus.rejected:
        color = Colors.red;
        bgColor = Colors.red.withOpacity(0.15);
        break;
      case ApplicationStatus.interviewScheduled:
        color = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.15);
        break;
      case ApplicationStatus.accepted:
        color = Colors.green;
        bgColor = Colors.green.withOpacity(0.15);
        break;
      case ApplicationStatus.underReview:
        color = theme.colorScheme.secondary;
        bgColor = theme.colorScheme.secondaryContainer;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
