// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => _ChatRoom(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      studentPhotoUrl: json['studentPhotoUrl'] as String?,
      startupId: json['startupId'] as String,
      startupName: json['startupName'] as String,
      startupLogoUrl: json['startupLogoUrl'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      lastMessageTime:
          const NullableTimestampConverter().fromJson(json['lastMessageTime']),
      unreadByStudent: (json['unreadByStudent'] as num?)?.toInt() ?? 0,
      unreadByFounder: (json['unreadByFounder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChatRoomToJson(_ChatRoom instance) => <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'studentPhotoUrl': instance.studentPhotoUrl,
      'startupId': instance.startupId,
      'startupName': instance.startupName,
      'startupLogoUrl': instance.startupLogoUrl,
      'lastMessage': instance.lastMessage,
      'lastMessageSenderId': instance.lastMessageSenderId,
      'lastMessageTime':
          const NullableTimestampConverter().toJson(instance.lastMessageTime),
      'unreadByStudent': instance.unreadByStudent,
      'unreadByFounder': instance.unreadByFounder,
    };

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      text: json['text'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'text': instance.text,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
