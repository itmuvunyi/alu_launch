import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../models/notification.dart';
import '../../providers/notification_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          notificationsAsync.maybeWhen(
            data: (notifications) {
              final hasUnread = notifications.any((n) => !n.isRead);
              if (!hasUnread) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () async {
                  final notificationsList = ref.read(notificationsStreamProvider).valueOrNull ?? [];
                  if (notificationsList.isNotEmpty) {
                    final userId = notificationsList.first.userId;
                    await ref.read(notificationRepositoryProvider).markAllAsRead(userId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('All notifications marked as read.')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.done_all, size: 16),
                label: const Text('Mark all read'),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error loading notifications: $err')),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'All caught up!',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You do not have any notifications at the moment.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            itemCount: notifications.length,
            itemBuilder: (context, idx) {
              final n = notifications[idx];
              return Card(
                elevation: n.isRead ? 0.5 : 2,
                color: n.isRead
                    ? theme.colorScheme.surface
                    : theme.colorScheme.primaryContainer.withOpacity(0.08),
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
                  leading: CircleAvatar(
                    backgroundColor: n.isRead
                        ? theme.colorScheme.surfaceContainer
                        : theme.colorScheme.primaryContainer,
                    child: Icon(
                      _getIconForType(n.type),
                      color: n.isRead
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: TextStyle(
                            fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!n.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        n.body,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(n.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  onTap: () async {
                    // Mark as read
                    if (!n.isRead) {
                      await ref.read(notificationRepositoryProvider).markAsRead(n.id);
                    }

                    // Handle navigation payload
                    if (context.mounted && n.payload != null) {
                      final payload = n.payload!;
                      if (n.type == 'applicationStatusChanged' && payload.containsKey('applicationId')) {
                        context.push('/student/applications/tracking/${payload['applicationId']}');
                      } else if (n.type == 'newOpportunity' && payload.containsKey('opportunityId')) {
                        context.push('/opportunity/${payload['opportunityId']}');
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'applicationStatusChanged':
        return Icons.assignment_turned_in_outlined;
      case 'newOpportunity':
        return Icons.campaign_outlined;
      case 'verificationStatus':
        return Icons.verified_user_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }
}
