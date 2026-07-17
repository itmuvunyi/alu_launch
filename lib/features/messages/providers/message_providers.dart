import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/providers/auth_providers.dart';
import '../models/message.dart';
import '../repositories/message_repository.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository();
});

final studentChatRoomsStreamProvider = StreamProvider.autoDispose<List<ChatRoom>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.valueOrNull;
  if (user == null) return Stream.value([]);

  return ref.watch(messageRepositoryProvider).watchChatRoomsForStudent(user.uid);
});

final startupChatRoomsStreamProvider = StreamProvider.autoDispose.family<List<ChatRoom>, String>((ref, startupId) {
  return ref.watch(messageRepositoryProvider).watchChatRoomsForStartup(startupId);
});

final chatMessagesStreamProvider = StreamProvider.autoDispose.family<List<ChatMessage>, String>((ref, roomId) {
  return ref.watch(messageRepositoryProvider).watchMessages(roomId);
});

final chatRoomStreamProvider = StreamProvider.autoDispose.family<ChatRoom?, String>((ref, roomId) {
  return ref.watch(messageRepositoryProvider).watchChatRoom(roomId);
});

class SendMessageController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> send({
    required String roomId,
    required String text,
    required bool isStudentSender,
  }) async {
    state = const AsyncLoading();
    try {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user == null) throw Exception('Must be signed in to send messages');

      await ref.read(messageRepositoryProvider).sendMessage(
        roomId: roomId,
        senderId: user.uid,
        senderName: user.displayName,
        text: text.trim(),
        isStudentSender: isStudentSender,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final sendMessageControllerProvider =
    AutoDisposeAsyncNotifierProvider<SendMessageController, void>(SendMessageController.new);

final studentUnreadMessagesCountProvider = Provider<int>((ref) {
  final rooms = ref.watch(studentChatRoomsStreamProvider).valueOrNull ?? [];
  return rooms.fold(0, (sum, room) => sum + room.unreadByStudent);
});

final startupUnreadMessagesCountProvider = Provider.family<int, String>((ref, startupId) {
  final rooms = ref.watch(startupChatRoomsStreamProvider(startupId)).valueOrNull ?? [];
  return rooms.fold(0, (sum, room) => sum + room.unreadByFounder);
});
