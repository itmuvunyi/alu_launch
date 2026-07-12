// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatRoom {
  String get id;
  String get studentId;
  String get studentName;
  String? get studentPhotoUrl;
  String get startupId;
  String get startupName;
  String? get startupLogoUrl;
  String? get lastMessage;
  String? get lastMessageSenderId;
  @NullableTimestampConverter()
  DateTime? get lastMessageTime;
  int get unreadByStudent;
  int get unreadByFounder;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatRoomCopyWith<ChatRoom> get copyWith =>
      _$ChatRoomCopyWithImpl<ChatRoom>(this as ChatRoom, _$identity);

  /// Serializes this ChatRoom to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatRoom &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.studentPhotoUrl, studentPhotoUrl) ||
                other.studentPhotoUrl == studentPhotoUrl) &&
            (identical(other.startupId, startupId) ||
                other.startupId == startupId) &&
            (identical(other.startupName, startupName) ||
                other.startupName == startupName) &&
            (identical(other.startupLogoUrl, startupLogoUrl) ||
                other.startupLogoUrl == startupLogoUrl) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime) &&
            (identical(other.unreadByStudent, unreadByStudent) ||
                other.unreadByStudent == unreadByStudent) &&
            (identical(other.unreadByFounder, unreadByFounder) ||
                other.unreadByFounder == unreadByFounder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      studentName,
      studentPhotoUrl,
      startupId,
      startupName,
      startupLogoUrl,
      lastMessage,
      lastMessageSenderId,
      lastMessageTime,
      unreadByStudent,
      unreadByFounder);

  @override
  String toString() {
    return 'ChatRoom(id: $id, studentId: $studentId, studentName: $studentName, studentPhotoUrl: $studentPhotoUrl, startupId: $startupId, startupName: $startupName, startupLogoUrl: $startupLogoUrl, lastMessage: $lastMessage, lastMessageSenderId: $lastMessageSenderId, lastMessageTime: $lastMessageTime, unreadByStudent: $unreadByStudent, unreadByFounder: $unreadByFounder)';
  }
}

/// @nodoc
abstract mixin class $ChatRoomCopyWith<$Res> {
  factory $ChatRoomCopyWith(ChatRoom value, $Res Function(ChatRoom) _then) =
      _$ChatRoomCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String studentId,
      String studentName,
      String? studentPhotoUrl,
      String startupId,
      String startupName,
      String? startupLogoUrl,
      String? lastMessage,
      String? lastMessageSenderId,
      @NullableTimestampConverter() DateTime? lastMessageTime,
      int unreadByStudent,
      int unreadByFounder});
}

/// @nodoc
class _$ChatRoomCopyWithImpl<$Res> implements $ChatRoomCopyWith<$Res> {
  _$ChatRoomCopyWithImpl(this._self, this._then);

  final ChatRoom _self;
  final $Res Function(ChatRoom) _then;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? studentPhotoUrl = freezed,
    Object? startupId = null,
    Object? startupName = null,
    Object? startupLogoUrl = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageSenderId = freezed,
    Object? lastMessageTime = freezed,
    Object? unreadByStudent = null,
    Object? unreadByFounder = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _self.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      studentPhotoUrl: freezed == studentPhotoUrl
          ? _self.studentPhotoUrl
          : studentPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startupId: null == startupId
          ? _self.startupId
          : startupId // ignore: cast_nullable_to_non_nullable
              as String,
      startupName: null == startupName
          ? _self.startupName
          : startupName // ignore: cast_nullable_to_non_nullable
              as String,
      startupLogoUrl: freezed == startupLogoUrl
          ? _self.startupLogoUrl
          : startupLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: freezed == lastMessageSenderId
          ? _self.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageTime: freezed == lastMessageTime
          ? _self.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadByStudent: null == unreadByStudent
          ? _self.unreadByStudent
          : unreadByStudent // ignore: cast_nullable_to_non_nullable
              as int,
      unreadByFounder: null == unreadByFounder
          ? _self.unreadByFounder
          : unreadByFounder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatRoom].
extension ChatRoomPatterns on ChatRoom {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ChatRoom value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatRoom() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ChatRoom value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatRoom():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ChatRoom value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatRoom() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String studentId,
            String studentName,
            String? studentPhotoUrl,
            String startupId,
            String startupName,
            String? startupLogoUrl,
            String? lastMessage,
            String? lastMessageSenderId,
            @NullableTimestampConverter() DateTime? lastMessageTime,
            int unreadByStudent,
            int unreadByFounder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatRoom() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.studentName,
            _that.studentPhotoUrl,
            _that.startupId,
            _that.startupName,
            _that.startupLogoUrl,
            _that.lastMessage,
            _that.lastMessageSenderId,
            _that.lastMessageTime,
            _that.unreadByStudent,
            _that.unreadByFounder);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String studentId,
            String studentName,
            String? studentPhotoUrl,
            String startupId,
            String startupName,
            String? startupLogoUrl,
            String? lastMessage,
            String? lastMessageSenderId,
            @NullableTimestampConverter() DateTime? lastMessageTime,
            int unreadByStudent,
            int unreadByFounder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatRoom():
        return $default(
            _that.id,
            _that.studentId,
            _that.studentName,
            _that.studentPhotoUrl,
            _that.startupId,
            _that.startupName,
            _that.startupLogoUrl,
            _that.lastMessage,
            _that.lastMessageSenderId,
            _that.lastMessageTime,
            _that.unreadByStudent,
            _that.unreadByFounder);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String studentId,
            String studentName,
            String? studentPhotoUrl,
            String startupId,
            String startupName,
            String? startupLogoUrl,
            String? lastMessage,
            String? lastMessageSenderId,
            @NullableTimestampConverter() DateTime? lastMessageTime,
            int unreadByStudent,
            int unreadByFounder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatRoom() when $default != null:
        return $default(
            _that.id,
            _that.studentId,
            _that.studentName,
            _that.studentPhotoUrl,
            _that.startupId,
            _that.startupName,
            _that.startupLogoUrl,
            _that.lastMessage,
            _that.lastMessageSenderId,
            _that.lastMessageTime,
            _that.unreadByStudent,
            _that.unreadByFounder);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatRoom implements ChatRoom {
  const _ChatRoom(
      {required this.id,
      required this.studentId,
      required this.studentName,
      this.studentPhotoUrl,
      required this.startupId,
      required this.startupName,
      this.startupLogoUrl,
      this.lastMessage,
      this.lastMessageSenderId,
      @NullableTimestampConverter() this.lastMessageTime,
      this.unreadByStudent = 0,
      this.unreadByFounder = 0});
  factory _ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String studentName;
  @override
  final String? studentPhotoUrl;
  @override
  final String startupId;
  @override
  final String startupName;
  @override
  final String? startupLogoUrl;
  @override
  final String? lastMessage;
  @override
  final String? lastMessageSenderId;
  @override
  @NullableTimestampConverter()
  final DateTime? lastMessageTime;
  @override
  @JsonKey()
  final int unreadByStudent;
  @override
  @JsonKey()
  final int unreadByFounder;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatRoomCopyWith<_ChatRoom> get copyWith =>
      __$ChatRoomCopyWithImpl<_ChatRoom>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatRoomToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatRoom &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.studentPhotoUrl, studentPhotoUrl) ||
                other.studentPhotoUrl == studentPhotoUrl) &&
            (identical(other.startupId, startupId) ||
                other.startupId == startupId) &&
            (identical(other.startupName, startupName) ||
                other.startupName == startupName) &&
            (identical(other.startupLogoUrl, startupLogoUrl) ||
                other.startupLogoUrl == startupLogoUrl) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageSenderId, lastMessageSenderId) ||
                other.lastMessageSenderId == lastMessageSenderId) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime) &&
            (identical(other.unreadByStudent, unreadByStudent) ||
                other.unreadByStudent == unreadByStudent) &&
            (identical(other.unreadByFounder, unreadByFounder) ||
                other.unreadByFounder == unreadByFounder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      studentId,
      studentName,
      studentPhotoUrl,
      startupId,
      startupName,
      startupLogoUrl,
      lastMessage,
      lastMessageSenderId,
      lastMessageTime,
      unreadByStudent,
      unreadByFounder);

  @override
  String toString() {
    return 'ChatRoom(id: $id, studentId: $studentId, studentName: $studentName, studentPhotoUrl: $studentPhotoUrl, startupId: $startupId, startupName: $startupName, startupLogoUrl: $startupLogoUrl, lastMessage: $lastMessage, lastMessageSenderId: $lastMessageSenderId, lastMessageTime: $lastMessageTime, unreadByStudent: $unreadByStudent, unreadByFounder: $unreadByFounder)';
  }
}

/// @nodoc
abstract mixin class _$ChatRoomCopyWith<$Res>
    implements $ChatRoomCopyWith<$Res> {
  factory _$ChatRoomCopyWith(_ChatRoom value, $Res Function(_ChatRoom) _then) =
      __$ChatRoomCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      String studentName,
      String? studentPhotoUrl,
      String startupId,
      String startupName,
      String? startupLogoUrl,
      String? lastMessage,
      String? lastMessageSenderId,
      @NullableTimestampConverter() DateTime? lastMessageTime,
      int unreadByStudent,
      int unreadByFounder});
}

/// @nodoc
class __$ChatRoomCopyWithImpl<$Res> implements _$ChatRoomCopyWith<$Res> {
  __$ChatRoomCopyWithImpl(this._self, this._then);

  final _ChatRoom _self;
  final $Res Function(_ChatRoom) _then;

  /// Create a copy of ChatRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? studentPhotoUrl = freezed,
    Object? startupId = null,
    Object? startupName = null,
    Object? startupLogoUrl = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageSenderId = freezed,
    Object? lastMessageTime = freezed,
    Object? unreadByStudent = null,
    Object? unreadByFounder = null,
  }) {
    return _then(_ChatRoom(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _self.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      studentPhotoUrl: freezed == studentPhotoUrl
          ? _self.studentPhotoUrl
          : studentPhotoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startupId: null == startupId
          ? _self.startupId
          : startupId // ignore: cast_nullable_to_non_nullable
              as String,
      startupName: null == startupName
          ? _self.startupName
          : startupName // ignore: cast_nullable_to_non_nullable
              as String,
      startupLogoUrl: freezed == startupLogoUrl
          ? _self.startupLogoUrl
          : startupLogoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessage: freezed == lastMessage
          ? _self.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageSenderId: freezed == lastMessageSenderId
          ? _self.lastMessageSenderId
          : lastMessageSenderId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageTime: freezed == lastMessageTime
          ? _self.lastMessageTime
          : lastMessageTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unreadByStudent: null == unreadByStudent
          ? _self.unreadByStudent
          : unreadByStudent // ignore: cast_nullable_to_non_nullable
              as int,
      unreadByFounder: null == unreadByFounder
          ? _self.unreadByFounder
          : unreadByFounder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ChatMessage {
  String get id;
  String get senderId;
  String get senderName;
  String get text;
  @TimestampConverter()
  DateTime get createdAt;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, senderId, senderName, text, createdAt);

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, senderName: $senderName, text: $text, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) _then) =
      _$ChatMessageCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String senderId,
      String senderName,
      String text,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res> implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? text = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _self.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ChatMessage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ChatMessage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ChatMessage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String senderId, String senderName, String text,
            @TimestampConverter() DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
        return $default(_that.id, _that.senderId, _that.senderName, _that.text,
            _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String senderId, String senderName, String text,
            @TimestampConverter() DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage():
        return $default(_that.id, _that.senderId, _that.senderName, _that.text,
            _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String senderId, String senderName,
            String text, @TimestampConverter() DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ChatMessage() when $default != null:
        return $default(_that.id, _that.senderId, _that.senderName, _that.text,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ChatMessage implements ChatMessage {
  const _ChatMessage(
      {required this.id,
      required this.senderId,
      required this.senderName,
      required this.text,
      @TimestampConverter() required this.createdAt});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  @override
  final String id;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String text;
  @override
  @TimestampConverter()
  final DateTime createdAt;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ChatMessageCopyWith<_ChatMessage> get copyWith =>
      __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ChatMessageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ChatMessage &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderName, senderName) ||
                other.senderName == senderName) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, senderId, senderName, text, createdAt);

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, senderName: $senderName, text: $text, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(
          _ChatMessage value, $Res Function(_ChatMessage) _then) =
      __$ChatMessageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String senderId,
      String senderName,
      String text,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$ChatMessageCopyWithImpl<$Res> implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? senderId = null,
    Object? senderName = null,
    Object? text = null,
    Object? createdAt = null,
  }) {
    return _then(_ChatMessage(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      senderName: null == senderName
          ? _self.senderName
          : senderName // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
