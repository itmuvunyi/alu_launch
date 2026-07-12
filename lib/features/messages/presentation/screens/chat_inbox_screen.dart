import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


import '../../../../core/constants/firestore_paths.dart';

import '../../../authentication/providers/auth_providers.dart';
import '../../../startup/providers/startup_providers.dart';
import '../../models/message.dart';
import '../../providers/message_providers.dart';

class ChatInboxScreen extends ConsumerWidget {
  const ChatInboxScreen({super.key});

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat.jm().format(dateTime); // e.g. 4:30 PM
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(dateTime); // e.g. Wed
    } else {
      return DateFormat.yMMMd().format(dateTime); // e.g. Jul 12, 2026
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Please sign in to view messages.'));
          }

          final isStudent = user.role == UserRole.student;

          if (isStudent) {
            final roomsAsync = ref.watch(studentChatRoomsStreamProvider);
            return roomsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Error loading inbox: $err')),
              data: (rooms) => _buildRoomsList(context, ref, rooms, true, user.uid),
            );
          } else {
            // Startup representative
            final startupAsync = ref.watch(currentFounderStartupStreamProvider);
            return startupAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, st) => Center(child: Text('Error loading startup: $err')),
              data: (startup) {
                if (startup == null) {
                  return const Center(child: Text('Please complete your startup profile first.'));
                }

                final roomsAsync = ref.watch(startupChatRoomsStreamProvider(startup.id));
                return roomsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, st) => Center(child: Text('Error loading inbox: $err')),
                  data: (rooms) => _buildRoomsList(context, ref, rooms, false, user.uid),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildRoomsList(
    BuildContext context,
    WidgetRef ref,
    List<ChatRoom> rooms,
    bool isStudentUser,
    String currentUserId,
  ) {
    final theme = Theme.of(context);

    if (rooms.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No conversations yet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                isStudentUser
                    ? 'Start a chat with recruiters from internship opportunity detail pages!'
                    : 'Wait for candidates to message you or reach out to applicants directly from their application reviews.',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: rooms.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, idx) {
        final room = rooms[idx];

        // Determine title, logo, and unread state based on who is logged in
        final chatPartnerName = isStudentUser ? room.startupName : room.studentName;
        final chatPartnerPhoto = isStudentUser ? room.startupLogoUrl : room.studentPhotoUrl;
        final unreadCount = isStudentUser ? room.unreadByStudent : room.unreadByFounder;
        final hasUnread = unreadCount > 0;

        final isLastMessageMe = room.lastMessageSenderId == currentUserId;
        final prefix = isLastMessageMe ? 'You: ' : '';

        return ListTile(
          onTap: () {
            // Mark chat room messages as read
            ref.read(messageRepositoryProvider).markAsRead(
                  roomId: room.id,
                  isStudent: isStudentUser,
                );
            context.push('/messages/${room.id}');
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: theme.colorScheme.primaryContainer,
            backgroundImage: chatPartnerPhoto != null && chatPartnerPhoto.isNotEmpty
                ? NetworkImage(chatPartnerPhoto)
                : null,
            child: chatPartnerPhoto == null || chatPartnerPhoto.isEmpty
                ? Text(
                    chatPartnerName.isNotEmpty ? chatPartnerName.substring(0, 1).toUpperCase() : 'C',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                : null,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  chatPartnerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTime(room.lastMessageTime),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: hasUnread ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  room.lastMessage != null ? '$prefix${room.lastMessage}' : 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: hasUnread ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                    fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              if (hasUnread) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: theme.colorScheme.primary,
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
