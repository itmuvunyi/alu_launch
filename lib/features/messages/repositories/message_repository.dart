import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class MessageRepository {
  MessageRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _chatRoomsRef =>
      _firestore.collection('chat_rooms');

  Stream<List<ChatRoom>> watchChatRoomsForStudent(String studentId) {
    return _chatRoomsRef
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ChatRoom.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      list.sort((a, b) {
        final aTime = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      return list;
    });
  }

  Stream<List<ChatRoom>> watchChatRoomsForStartup(String startupId) {
    return _chatRoomsRef
        .where('startupId', isEqualTo: startupId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => ChatRoom.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      list.sort((a, b) {
        final aTime = a.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.lastMessageTime ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      return list;
    });
  }

  /// Get single opportunity
  Stream<ChatRoom?> watchChatRoom(String roomId) {
    return _chatRoomsRef.doc(roomId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ChatRoom.fromJson({...doc.data()!, 'id': doc.id});
    });
  }

  Stream<List<ChatMessage>> watchMessages(String roomId) {
    return _chatRoomsRef
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  Future<String> getOrCreateChatRoom({
    required String studentId,
    required String studentName,
    String? studentPhotoUrl,
    required String startupId,
    required String startupName,
    String? startupLogoUrl,
  }) async {
    final roomId = '${studentId}_$startupId';
    final docRef = _chatRoomsRef.doc(roomId);
    final doc = await docRef.get();

    if (!doc.exists) {
      final newRoom = ChatRoom(
        id: roomId,
        studentId: studentId,
        studentName: studentName,
        studentPhotoUrl: studentPhotoUrl,
        startupId: startupId,
        startupName: startupName,
        startupLogoUrl: startupLogoUrl,
        unreadByStudent: 0,
        unreadByFounder: 0,
      );
      await docRef.set(newRoom.toJson());
    }
    return roomId;
  }

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String senderName,
    required String text,
    required bool isStudentSender,
  }) async {
    final messageId = _chatRoomsRef.doc(roomId).collection('messages').doc().id;
    final message = ChatMessage(
      id: messageId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      createdAt: DateTime.now(),
    );

    final roomDocRef = _chatRoomsRef.doc(roomId);

    await _firestore.runTransaction((transaction) async {
      // 1. Add message document
      transaction.set(roomDocRef.collection('messages').doc(messageId), message.toJson());

      // 2. Update room summary
      final roomSnap = await transaction.get(roomDocRef);
      if (roomSnap.exists) {
        final currentData = roomSnap.data()!;
        final unreadStudent = (currentData['unreadByStudent'] as int?) ?? 0;
        final unreadFounder = (currentData['unreadByFounder'] as int?) ?? 0;

        transaction.update(roomDocRef, {
          'lastMessage': text,
          'lastMessageSenderId': senderId,
          'lastMessageTime': FieldValue.serverTimestamp(),
          'unreadByStudent': isStudentSender ? 0 : unreadStudent + 1,
          'unreadByFounder': isStudentSender ? unreadFounder + 1 : 0,
        });
      }
    });
  }

  Future<void> markAsRead({
    required String roomId,
    required bool isStudent,
  }) async {
    await _chatRoomsRef.doc(roomId).update({
      isStudent ? 'unreadByStudent' : 'unreadByFounder': 0,
    });
  }
}
