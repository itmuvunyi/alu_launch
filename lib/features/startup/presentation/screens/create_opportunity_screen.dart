import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/constants/firestore_paths.dart';
import '../../../internships/models/opportunity.dart';

import '../../providers/startup_providers.dart';

class CreateOpportunityScreen extends ConsumerStatefulWidget {
  const CreateOpportunityScreen({this.opportunityId, super.key});

  final String? opportunityId;

  @override
  ConsumerState<CreateOpportunityScreen> createState() => _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState extends ConsumerState<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _durationController;
  late TextEditingController _stipendController;

  late TextEditingController _requirementInputController;
  late TextEditingController _responsibilityInputController;
  late TextEditingController _skillInputController;

  final List<String> _requirements = [];
  final List<String> _responsibilities = [];
  final List<String> _skillsRequired = [];

  String _selectedType = 'Internship';
  DateTime? _deadline;
  bool _initialized = false;
  Opportunity? _existingOpportunity;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
    _locationController = TextEditingController();
    _durationController = TextEditingController();
    _stipendController = TextEditingController();

    _requirementInputController = TextEditingController();
    _responsibilityInputController = TextEditingController();
    _skillInputController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _stipendController.dispose();
    _requirementInputController.dispose();
    _responsibilityInputController.dispose();
    _skillInputController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingOpportunity() async {
    if (widget.opportunityId == null || _initialized) return;
    _initialized = true;

    try {
      final doc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.internships)
          .doc(widget.opportunityId)
          .get();
      if (!doc.exists) return;

      final opp = Opportunity.fromJson({...doc.data()!, 'id': doc.id});
      setState(() {
        _existingOpportunity = opp;
        _titleController.text = opp.title;
        _descController.text = opp.description;
        _locationController.text = opp.location;
        _durationController.text = opp.duration;
        _stipendController.text = opp.stipend ?? '';
        _selectedType = opp.type;
        _requirements.addAll(opp.requirements);
        _responsibilities.addAll(opp.responsibilities ?? []);
        _skillsRequired.addAll(opp.skillsRequired);
        _deadline = opp.applicationDeadline;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading opportunity: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startupAsync = ref.watch(currentFounderStartupStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.opportunityId == null ? 'Post Internship' : 'Edit Internship'),
      ),
      body: startupAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading startup: $err')),
        data: (startup) {
          if (startup == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.business_outlined, size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      'Profile Required',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You must complete your Startup Profile before creating internship opportunities.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.push('/startup/profile-edit'),
                      child: const Text('Complete Profile Now'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!startup.isVerified) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      'Verification Required',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your startup account is not verified yet. An administrator must approve your verification documents before you can post opportunities.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => context.push('/startup/verify'),
                      child: const Text('Upload Verification Docs'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Trigger loading if editing
          if (widget.opportunityId != null && !_initialized) {
            _loadExistingOpportunity();
            return const Center(child: CircularProgressIndicator());
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Basic Information', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.lg),
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(labelText: 'Internship Title *'),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedType,
                                  decoration: const InputDecoration(labelText: 'Job Type *'),
                                  items: ['Internship', 'Full-time', 'Part-time', 'Contract']
                                      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                      .toList(),
                                  onChanged: (val) => setState(() => _selectedType = val ?? 'Internship'),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: TextFormField(
                                  controller: _durationController,
                                  decoration: const InputDecoration(labelText: 'Duration * (e.g. 3 months)'),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _locationController,
                                  decoration: const InputDecoration(labelText: 'Location * (e.g. Kigali / Remote)'),
                                  validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: TextFormField(
                                  controller: _stipendController,
                                  decoration: const InputDecoration(labelText: 'Stipend (optional, e.g. \$200/mo)'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _descController,
                            maxLines: 4,
                            decoration: const InputDecoration(labelText: 'Description / Summary *'),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Application Deadline'),
                            subtitle: Text(_deadline == null
                                ? 'No deadline selected (Always open)'
                                : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}'),
                            trailing: TextButton(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().add(const Duration(days: 30)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                                if (picked != null) {
                                  setState(() => _deadline = picked);
                                }
                              },
                              child: const Text('Select Date'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Requirements Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Requirements *', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _requirementInputController,
                                  decoration: const InputDecoration(hintText: 'Add a requirement...'),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                color: theme.colorScheme.primary,
                                onPressed: () {
                                  final text = _requirementInputController.text.trim();
                                  if (text.isNotEmpty) {
                                    setState(() {
                                      _requirements.add(text);
                                      _requirementInputController.clear();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (_requirements.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Add at least one requirement.',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _requirements.length,
                              itemBuilder: (context, idx) => ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.check_circle_outline, size: 16),
                                title: Text(_requirements[idx]),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 16),
                                  onPressed: () => setState(() => _requirements.removeAt(idx)),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Responsibilities Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Responsibilities', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _responsibilityInputController,
                                  decoration: const InputDecoration(hintText: 'Add a responsibility...'),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                color: theme.colorScheme.primary,
                                onPressed: () {
                                  final text = _responsibilityInputController.text.trim();
                                  if (text.isNotEmpty) {
                                    setState(() {
                                      _responsibilities.add(text);
                                      _responsibilityInputController.clear();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _responsibilities.length,
                            itemBuilder: (context, idx) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.arrow_right, size: 16),
                              title: Text(_responsibilities[idx]),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, size: 16),
                                onPressed: () => setState(() => _responsibilities.removeAt(idx)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Skills Required Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Skills Required *', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _skillInputController,
                                  decoration: const InputDecoration(hintText: 'Add a skill...'),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                color: theme.colorScheme.primary,
                                onPressed: () {
                                  final text = _skillInputController.text.trim();
                                  if (text.isNotEmpty) {
                                    setState(() {
                                      _skillsRequired.add(text);
                                      _skillInputController.clear();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (_skillsRequired.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Add at least one skill.',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
                            )
                          else
                            Wrap(
                              spacing: 8,
                              children: _skillsRequired
                                  .map((skill) => Chip(
                                        label: Text(skill),
                                        onDeleted: () => setState(() => _skillsRequired.remove(skill)),
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      if (_requirements.isEmpty || _skillsRequired.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please add at least one requirement and one skill.')),
                        );
                        return;
                      }

                      final oppId = widget.opportunityId ??
                          FirebaseFirestore.instance.collection(FirestoreCollections.internships).doc().id;

                      final opportunity = Opportunity(
                        id: oppId,
                        startupId: startup.id,
                        startupName: startup.name,
                        startupLogoUrl: startup.logoUrl,
                        title: _titleController.text.trim(),
                        description: _descController.text.trim(),
                        requirements: _requirements,
                        responsibilities: _responsibilities,
                        location: _locationController.text.trim(),
                        type: _selectedType,
                        duration: _durationController.text.trim(),
                        stipend: _stipendController.text.trim().isEmpty ? null : _stipendController.text.trim(),
                        skillsRequired: _skillsRequired,
                        status: _existingOpportunity?.status ?? OpportunityStatus.pendingReview,
                        createdAt: _existingOpportunity?.createdAt ?? DateTime.now(),
                        updatedAt: DateTime.now(),
                        applicationDeadline: _deadline,
                      );

                      try {
                        await FirebaseFirestore.instance
                            .collection(FirestoreCollections.internships)
                            .doc(oppId)
                            .set(opportunity.toJson());

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(widget.opportunityId == null
                                ? 'Opportunity posted! Pending admin review.'
                                : 'Opportunity updated successfully!'),
                          ),
                        );
                        context.pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to post opportunity: $e')),
                        );
                      }
                    },
                    child: Text(widget.opportunityId == null ? 'Submit for Review' : 'Save Changes'),
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
