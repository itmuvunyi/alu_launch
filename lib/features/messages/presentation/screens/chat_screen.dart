import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


import '../../../../core/constants/firestore_paths.dart';

import '../../../authentication/providers/auth_providers.dart';

import '../../providers/message_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.roomId});

  final String roomId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isStudentUser = true;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _textController.clear();
    try {
      await ref.read(sendMessageControllerProvider.notifier).send(
            roomId: widget.roomId,
            text: text,
            isStudentSender: _isStudentUser,
          );
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentUserProvider);
    final roomAsync = ref.watch(chatRoomStreamProvider(widget.roomId));
    final messagesAsync = ref.watch(chatMessagesStreamProvider(widget.roomId));

    return userAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, st) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('Please sign in.')));
        }

        _isStudentUser = user.role == UserRole.student;

        // Auto mark as read when rendering messages
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(messageRepositoryProvider).markAsRead(
                roomId: widget.roomId,
                isStudent: _isStudentUser,
              );
        });

        return roomAsync.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (err, st) => Scaffold(body: Center(child: Text('Error: $err'))),
          data: (room) {
            if (room == null) {
              return Scaffold(
                appBar: AppBar(),
                body: const Center(child: Text('Conversation not found')),
              );
            }

            final chatPartnerName = _isStudentUser ? room.startupName : room.studentName;
            final chatPartnerPhoto = _isStudentUser ? room.startupLogoUrl : room.studentPhotoUrl;

            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
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
                                fontSize: 14,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        chatPartnerName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  // Message history list
                  Expanded(
                    child: messagesAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, st) => Center(child: Text('Error loading messages: $err')),
                      data: (messages) {
                        // Scroll bottom when messages load/change
                        if (messages.isNotEmpty) {
                          _scrollToBottom();
                        }

                        if (messages.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.waving_hand_outlined, size: 48, color: theme.colorScheme.primary),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Say Hello to $chatPartnerName!',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Start your conversation now. Real-time delivery is active.',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final isMe = msg.senderId == user.uid;

                            return Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.surfaceContainerHigh,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                    bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                                    bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.text,
                                      style: TextStyle(
                                        color: isMe ? Colors.white : theme.colorScheme.onSurface,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat.jm().format(msg.createdAt),
                                      style: TextStyle(
                                        color: isMe ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // Message Input Bar
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 1,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: theme.colorScheme.surfaceContainerLow,
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            radius: 22,
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white, size: 18),
                              onPressed: () => _sendMessage(_textController.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
