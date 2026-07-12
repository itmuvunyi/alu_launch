import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/auth_providers.dart';
import '../../repositories/auth_repository.dart';

class CompleteGoogleRegistrationScreen extends ConsumerStatefulWidget {
  const CompleteGoogleRegistrationScreen(
      {required this.pendingUser, super.key});

  final NeedsRoleSelectionException pendingUser;

  @override
  ConsumerState<CompleteGoogleRegistrationScreen> createState() =>
      _CompleteGoogleRegistrationScreenState();
}

class _CompleteGoogleRegistrationScreenState
    extends ConsumerState<CompleteGoogleRegistrationScreen> {
  UserRole _selectedRole = UserRole.student;

  Future<void> _submit() async {
    if (_selectedRole == UserRole.student &&
        !widget.pendingUser.email.toLowerCase().endsWith('@alustudent.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Students must use an email ending in @alustudent.com.'),
        ),
      );
      return;
    }
    await ref.read(authControllerProvider.notifier).completeGoogleRegistration(
          uid: widget.pendingUser.uid,
          email: widget.pendingUser.email,
          displayName: widget.pendingUser.displayName,
          photoUrl: widget.pendingUser.photoUrl,
          role: _selectedRole,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('One last step')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Welcome, ${widget.pendingUser.displayName}!',
                  style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text('Tell us how you plan to use ALU Launch.',
                  style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _selectedRole == UserRole.student
                            ? theme.colorScheme.primary.withValues(alpha: 0.08)
                            : null,
                      ),
                      onPressed: () =>
                          setState(() => _selectedRole = UserRole.student),
                      child: const Text('Student'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: _selectedRole ==
                                UserRole.startupFounder
                            ? theme.colorScheme.primary.withValues(alpha: 0.08)
                            : null,
                      ),
                      onPressed: () => setState(
                          () => _selectedRole = UserRole.startupFounder),
                      child: const Text('Startup Founder'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: authState.isLoading ? null : _submit,
                child: authState.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
