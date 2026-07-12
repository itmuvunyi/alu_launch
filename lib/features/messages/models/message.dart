import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/firestore_converters.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
abstract class ChatRoom with _$ChatRoom {
  const factory ChatRoom({
    required String id,
    required String studentId,
    required String studentName,
    String? studentPhotoUrl,
    required String startupId,
    required String startupName,
    String? startupLogoUrl,
    String? lastMessage,
    String? lastMessageSenderId,
    @NullableTimestampConverter() DateTime? lastMessageTime,
    @Default(0) int unreadByStudent,
    @Default(0) int unreadByFounder,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String senderId,
    required String senderName,
    required String text,
    @TimestampConverter() required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
