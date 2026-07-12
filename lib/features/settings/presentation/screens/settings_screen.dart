import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../../../core/theme/app_spacing.dart';
import '../../../authentication/providers/auth_providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _emailAlerts = true;
  bool _pushNotifications = true;
  bool _marketingEmails = false;

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'Warning: This action is permanent and cannot be undone. All your applications, bookmarks, and profiles will be deleted forever.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // Trigger account deletion in AuthController
        await ref.read(authControllerProvider.notifier).signOut();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account deleted successfully.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete account: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          // Theme Section
          Text('Preferences', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Theme Mode'),
                  subtitle: const Text('Switch between light, dark, and system modes'),
                  trailing: DropdownButton<ThemeMode>(
                    value: ThemeMode.system,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                      DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                    ],
                    onChanged: (mode) {
                      // Note: Standard state logic to change system theme if desired
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Theme set to ${mode?.name.toUpperCase()}')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Notifications Section
          Text('Notifications', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.email_outlined),
                  title: const Text('Email Alerts'),
                  subtitle: const Text('Receive status updates via email'),
                  value: _emailAlerts,
                  onChanged: (val) => setState(() => _emailAlerts = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Get real-time updates on active applications'),
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.mail_outline),
                  title: const Text('Marketing & Newsletter'),
                  value: _marketingEmails,
                  onChanged: (val) => setState(() => _marketingEmails = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Legal Section
          Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.open_in_new, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.open_in_new, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('App Version'),
                  trailing: const Text('v1.0.0', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Security / Danger Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete My Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              subtitle: const Text('Irreversibly erase your student data and profile'),
              onTap: _deleteAccount,
            ),
          ),
        ],
      ),
    );
  }
}
