// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplicationTimelineEvent {
  ApplicationStatus get status;
  @TimestampConverter()
  DateTime get time;
  String? get notes;

  /// Create a copy of ApplicationTimelineEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ApplicationTimelineEventCopyWith<ApplicationTimelineEvent> get copyWith =>
      _$ApplicationTimelineEventCopyWithImpl<ApplicationTimelineEvent>(
          this as ApplicationTimelineEvent, _$identity);

  /// Serializes this ApplicationTimelineEvent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ApplicationTimelineEvent &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, time, notes);

  @override
  String toString() {
    return 'ApplicationTimelineEvent(status: $status, time: $time, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class $ApplicationTimelineEventCopyWith<$Res> {
  factory $ApplicationTimelineEventCopyWith(ApplicationTimelineEvent value,
          $Res Function(ApplicationTimelineEvent) _then) =
      _$ApplicationTimelineEventCopyWithImpl;
  @useResult
  $Res call(
      {ApplicationStatus status,
      @TimestampConverter() DateTime time,
      String? notes});
}

/// @nodoc
class _$ApplicationTimelineEventCopyWithImpl<$Res>
    implements $ApplicationTimelineEventCopyWith<$Res> {
  _$ApplicationTimelineEventCopyWithImpl(this._self, this._then);

  final ApplicationTimelineEvent _self;
  final $Res Function(ApplicationTimelineEvent) _then;

  /// Create a copy of ApplicationTimelineEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? time = null,
    Object? notes = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ApplicationTimelineEvent].
extension ApplicationTimelineEventPatterns on ApplicationTimelineEvent {
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
    TResult Function(_ApplicationTimelineEvent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ApplicationTimelineEvent() when $default != null:
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
    TResult Function(_ApplicationTimelineEvent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApplicationTimelineEvent():
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
    TResult? Function(_ApplicationTimelineEvent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApplicationTimelineEvent() when $default != null:
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
    TResult Function(ApplicationStatus status,
            @TimestampConverter() DateTime time, String? notes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ApplicationTimelineEvent() when $default != null:
        return $default(_that.status, _that.time, _that.notes);
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
    TResult Function(ApplicationStatus status,
            @TimestampConverter() DateTime time, String? notes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApplicationTimelineEvent():
        return $default(_that.status, _that.time, _that.notes);
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
    TResult? Function(ApplicationStatus status,
            @TimestampConverter() DateTime time, String? notes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApplicationTimelineEvent() when $default != null:
        return $default(_that.status, _that.time, _that.notes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ApplicationTimelineEvent implements ApplicationTimelineEvent {
  const _ApplicationTimelineEvent(
      {required this.status,
      @TimestampConverter() required this.time,
      this.notes});
  factory _ApplicationTimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$ApplicationTimelineEventFromJson(json);

  @override
  final ApplicationStatus status;
  @override
  @TimestampConverter()
  final DateTime time;
  @override
  final String? notes;

  /// Create a copy of ApplicationTimelineEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ApplicationTimelineEventCopyWith<_ApplicationTimelineEvent> get copyWith =>
      __$ApplicationTimelineEventCopyWithImpl<_ApplicationTimelineEvent>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ApplicationTimelineEventToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ApplicationTimelineEvent &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, time, notes);

  @override
  String toString() {
    return 'ApplicationTimelineEvent(status: $status, time: $time, notes: $notes)';
  }
}

/// @nodoc
abstract mixin class _$ApplicationTimelineEventCopyWith<$Res>
    implements $ApplicationTimelineEventCopyWith<$Res> {
  factory _$ApplicationTimelineEventCopyWith(_ApplicationTimelineEvent value,
          $Res Function(_ApplicationTimelineEvent) _then) =
      __$ApplicationTimelineEventCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ApplicationStatus status,
      @TimestampConverter() DateTime time,
      String? notes});
}

/// @nodoc
class __$ApplicationTimelineEventCopyWithImpl<$Res>
    implements _$ApplicationTimelineEventCopyWith<$Res> {
  __$ApplicationTimelineEventCopyWithImpl(this._self, this._then);

  final _ApplicationTimelineEvent _self;
  final $Res Function(_ApplicationTimelineEvent) _then;

  /// Create a copy of ApplicationTimelineEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? time = null,
    Object? notes = freezed,
  }) {
    return _then(_ApplicationTimelineEvent(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      time: null == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$Application {
  String get id;
  String get opportunityId;
  String get opportunityTitle;
  String get startupId;
  String get startupName;
  String get studentId;
  String get studentName;
  String get studentEmail;
  String? get studentResumeUrl;
  ApplicationStatus get status;
  List<ApplicationTimelineEvent> get timeline;
  @TimestampConverter()
  DateTime get createdAt;
  @NullableTimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ApplicationCopyWith<Application> get copyWith =>
      _$ApplicationCopyWithImpl<Application>(this as Application, _$identity);

  /// Serializes this Application to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Application &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.opportunityId, opportunityId) ||
                other.opportunityId == opportunityId) &&
            (identical(other.opportunityTitle, opportunityTitle) ||
                other.opportunityTitle == opportunityTitle) &&
            (identical(other.startupId, startupId) ||
                other.startupId == startupId) &&
            (identical(other.startupName, startupName) ||
                other.startupName == startupName) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.studentEmail, studentEmail) ||
                other.studentEmail == studentEmail) &&
            (identical(other.studentResumeUrl, studentResumeUrl) ||
                other.studentResumeUrl == studentResumeUrl) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.timeline, timeline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      opportunityId,
      opportunityTitle,
      startupId,
      startupName,
      studentId,
      studentName,
      studentEmail,
      studentResumeUrl,
      status,
      const DeepCollectionEquality().hash(timeline),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'Application(id: $id, opportunityId: $opportunityId, opportunityTitle: $opportunityTitle, startupId: $startupId, startupName: $startupName, studentId: $studentId, studentName: $studentName, studentEmail: $studentEmail, studentResumeUrl: $studentResumeUrl, status: $status, timeline: $timeline, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ApplicationCopyWith<$Res> {
  factory $ApplicationCopyWith(
          Application value, $Res Function(Application) _then) =
      _$ApplicationCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String opportunityId,
      String opportunityTitle,
      String startupId,
      String startupName,
      String studentId,
      String studentName,
      String studentEmail,
      String? studentResumeUrl,
      ApplicationStatus status,
      List<ApplicationTimelineEvent> timeline,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$ApplicationCopyWithImpl<$Res> implements $ApplicationCopyWith<$Res> {
  _$ApplicationCopyWithImpl(this._self, this._then);

  final Application _self;
  final $Res Function(Application) _then;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? opportunityId = null,
    Object? opportunityTitle = null,
    Object? startupId = null,
    Object? startupName = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? studentEmail = null,
    Object? studentResumeUrl = freezed,
    Object? status = null,
    Object? timeline = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      opportunityId: null == opportunityId
          ? _self.opportunityId
          : opportunityId // ignore: cast_nullable_to_non_nullable
              as String,
      opportunityTitle: null == opportunityTitle
          ? _self.opportunityTitle
          : opportunityTitle // ignore: cast_nullable_to_non_nullable
              as String,
      startupId: null == startupId
          ? _self.startupId
          : startupId // ignore: cast_nullable_to_non_nullable
              as String,
      startupName: null == startupName
          ? _self.startupName
          : startupName // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _self.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      studentEmail: null == studentEmail
          ? _self.studentEmail
          : studentEmail // ignore: cast_nullable_to_non_nullable
              as String,
      studentResumeUrl: freezed == studentResumeUrl
          ? _self.studentResumeUrl
          : studentResumeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      timeline: null == timeline
          ? _self.timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<ApplicationTimelineEvent>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Application].
extension ApplicationPatterns on Application {
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
    TResult Function(_Application value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Application() when $default != null:
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
    TResult Function(_Application value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Application():
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
    TResult? Function(_Application value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Application() when $default != null:
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
            String opportunityId,
            String opportunityTitle,
            String startupId,
            String startupName,
            String studentId,
            String studentName,
            String studentEmail,
            String? studentResumeUrl,
            ApplicationStatus status,
            List<ApplicationTimelineEvent> timeline,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Application() when $default != null:
        return $default(
            _that.id,
            _that.opportunityId,
            _that.opportunityTitle,
            _that.startupId,
            _that.startupName,
            _that.studentId,
            _that.studentName,
            _that.studentEmail,
            _that.studentResumeUrl,
            _that.status,
            _that.timeline,
            _that.createdAt,
            _that.updatedAt);
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
            String opportunityId,
            String opportunityTitle,
            String startupId,
            String startupName,
            String studentId,
            String studentName,
            String studentEmail,
            String? studentResumeUrl,
            ApplicationStatus status,
            List<ApplicationTimelineEvent> timeline,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Application():
        return $default(
            _that.id,
            _that.opportunityId,
            _that.opportunityTitle,
            _that.startupId,
            _that.startupName,
            _that.studentId,
            _that.studentName,
            _that.studentEmail,
            _that.studentResumeUrl,
            _that.status,
            _that.timeline,
            _that.createdAt,
            _that.updatedAt);
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
            String opportunityId,
            String opportunityTitle,
            String startupId,
            String startupName,
            String studentId,
            String studentName,
            String studentEmail,
            String? studentResumeUrl,
            ApplicationStatus status,
            List<ApplicationTimelineEvent> timeline,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Application() when $default != null:
        return $default(
            _that.id,
            _that.opportunityId,
            _that.opportunityTitle,
            _that.startupId,
            _that.startupName,
            _that.studentId,
            _that.studentName,
            _that.studentEmail,
            _that.studentResumeUrl,
            _that.status,
            _that.timeline,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Application implements Application {
  const _Application(
      {required this.id,
      required this.opportunityId,
      required this.opportunityTitle,
      required this.startupId,
      required this.startupName,
      required this.studentId,
      required this.studentName,
      required this.studentEmail,
      this.studentResumeUrl,
      this.status = ApplicationStatus.applied,
      required final List<ApplicationTimelineEvent> timeline,
      @TimestampConverter() required this.createdAt,
      @NullableTimestampConverter() this.updatedAt})
      : _timeline = timeline;
  factory _Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);

  @override
  final String id;
  @override
  final String opportunityId;
  @override
  final String opportunityTitle;
  @override
  final String startupId;
  @override
  final String startupName;
  @override
  final String studentId;
  @override
  final String studentName;
  @override
  final String studentEmail;
  @override
  final String? studentResumeUrl;
  @override
  @JsonKey()
  final ApplicationStatus status;
  final List<ApplicationTimelineEvent> _timeline;
  @override
  List<ApplicationTimelineEvent> get timeline {
    if (_timeline is EqualUnmodifiableListView) return _timeline;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline);
  }

  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @NullableTimestampConverter()
  final DateTime? updatedAt;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ApplicationCopyWith<_Application> get copyWith =>
      __$ApplicationCopyWithImpl<_Application>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ApplicationToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Application &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.opportunityId, opportunityId) ||
                other.opportunityId == opportunityId) &&
            (identical(other.opportunityTitle, opportunityTitle) ||
                other.opportunityTitle == opportunityTitle) &&
            (identical(other.startupId, startupId) ||
                other.startupId == startupId) &&
            (identical(other.startupName, startupName) ||
                other.startupName == startupName) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.studentEmail, studentEmail) ||
                other.studentEmail == studentEmail) &&
            (identical(other.studentResumeUrl, studentResumeUrl) ||
                other.studentResumeUrl == studentResumeUrl) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._timeline, _timeline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      opportunityId,
      opportunityTitle,
      startupId,
      startupName,
      studentId,
      studentName,
      studentEmail,
      studentResumeUrl,
      status,
      const DeepCollectionEquality().hash(_timeline),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'Application(id: $id, opportunityId: $opportunityId, opportunityTitle: $opportunityTitle, startupId: $startupId, startupName: $startupName, studentId: $studentId, studentName: $studentName, studentEmail: $studentEmail, studentResumeUrl: $studentResumeUrl, status: $status, timeline: $timeline, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ApplicationCopyWith<$Res>
    implements $ApplicationCopyWith<$Res> {
  factory _$ApplicationCopyWith(
          _Application value, $Res Function(_Application) _then) =
      __$ApplicationCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String opportunityId,
      String opportunityTitle,
      String startupId,
      String startupName,
      String studentId,
      String studentName,
      String studentEmail,
      String? studentResumeUrl,
      ApplicationStatus status,
      List<ApplicationTimelineEvent> timeline,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$ApplicationCopyWithImpl<$Res> implements _$ApplicationCopyWith<$Res> {
  __$ApplicationCopyWithImpl(this._self, this._then);

  final _Application _self;
  final $Res Function(_Application) _then;

  /// Create a copy of Application
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? opportunityId = null,
    Object? opportunityTitle = null,
    Object? startupId = null,
    Object? startupName = null,
    Object? studentId = null,
    Object? studentName = null,
    Object? studentEmail = null,
    Object? studentResumeUrl = freezed,
    Object? status = null,
    Object? timeline = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_Application(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      opportunityId: null == opportunityId
          ? _self.opportunityId
          : opportunityId // ignore: cast_nullable_to_non_nullable
              as String,
      opportunityTitle: null == opportunityTitle
          ? _self.opportunityTitle
          : opportunityTitle // ignore: cast_nullable_to_non_nullable
              as String,
      startupId: null == startupId
          ? _self.startupId
          : startupId // ignore: cast_nullable_to_non_nullable
              as String,
      startupName: null == startupName
          ? _self.startupName
          : startupName // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _self.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      studentName: null == studentName
          ? _self.studentName
          : studentName // ignore: cast_nullable_to_non_nullable
              as String,
      studentEmail: null == studentEmail
          ? _self.studentEmail
          : studentEmail // ignore: cast_nullable_to_non_nullable
              as String,
      studentResumeUrl: freezed == studentResumeUrl
          ? _self.studentResumeUrl
          : studentResumeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      timeline: null == timeline
          ? _self._timeline
          : timeline // ignore: cast_nullable_to_non_nullable
              as List<ApplicationTimelineEvent>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
