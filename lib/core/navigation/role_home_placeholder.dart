import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/providers/auth_providers.dart';

class RoleHomePlaceholder extends ConsumerWidget {
  const RoleHomePlaceholder({required this.roleLabel, super.key});

  final String roleLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text('$roleLabel Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle,
                  color: theme.colorScheme.primary, size: 48),
              const SizedBox(height: 16),
              Text('Signed in as ${user?.displayName ?? '...'}',
                  style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(user?.email ?? '', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 24),
              Text(
                'Role-based routing verified.\nReal $roleLabel dashboard lands here in a later phase.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
                child: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
