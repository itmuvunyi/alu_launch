// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opportunity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Opportunity {
  String get id;
  String get startupId;
  String get startupName;
  String? get startupLogoUrl;
  String get title;
  String get description;
  List<String> get requirements;
  List<String>? get responsibilities;
  String get location; // e.g. Kigali, Mauritius, Remote
  String get type; // e.g. Full-time, Part-time, Internship
  String get duration; // e.g. 3 months
  String? get stipend;
  List<String> get skillsRequired;
  OpportunityStatus get status;
  @TimestampConverter()
  DateTime get createdAt;
  @NullableTimestampConverter()
  DateTime? get updatedAt;
  @NullableTimestampConverter()
  DateTime? get applicationDeadline;

  /// Create a copy of Opportunity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OpportunityCopyWith<Opportunity> get copyWith =>
      _$OpportunityCopyWithImpl<Opportunity>(this as Opportunity, _$identity);

  /// Serializes this Opportunity to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Opportunity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startupId, startupId) ||
                other.startupId == startupId) &&
            (identical(other.startupName, startupName) ||
                other.startupName == startupName) &&
            (identical(other.startupLogoUrl, startupLogoUrl) ||
                other.startupLogoUrl == startupLogoUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other.requirements, requirements) &&
            const DeepCollectionEquality()
                .equals(other.responsibilities, responsibilities) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.stipend, stipend) || other.stipend == stipend) &&
            const DeepCollectionEquality()
                .equals(other.skillsRequired, skillsRequired) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.applicationDeadline, applicationDeadline) ||
                other.applicationDeadline == applicationDeadline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      startupId,
      startupName,
      startupLogoUrl,
      title,
      description,
      const DeepCollectionEquality().hash(requirements),
      const DeepCollectionEquality().hash(responsibilities),
      location,
      type,
      duration,
      stipend,
      const DeepCollectionEquality().hash(skillsRequired),
      status,
      createdAt,
      updatedAt,
      applicationDeadline);

  @override
  String toString() {
    return 'Opportunity(id: $id, startupId: $startupId, startupName: $startupName, startupLogoUrl: $startupLogoUrl, title: $title, description: $description, requirements: $requirements, responsibilities: $responsibilities, location: $location, type: $type, duration: $duration, stipend: $stipend, skillsRequired: $skillsRequired, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, applicationDeadline: $applicationDeadline)';
  }
}

/// @nodoc
abstract mixin class $OpportunityCopyWith<$Res> {
  factory $OpportunityCopyWith(
          Opportunity value, $Res Function(Opportunity) _then) =
      _$OpportunityCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String startupId,
      String startupName,
      String? startupLogoUrl,
      String title,
      String description,
      List<String> requirements,
      List<String>? responsibilities,
      String location,
      String type,
      String duration,
      String? stipend,
      List<String> skillsRequired,
      OpportunityStatus status,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt,
      @NullableTimestampConverter() DateTime? applicationDeadline});
}

/// @nodoc
class _$OpportunityCopyWithImpl<$Res> implements $OpportunityCopyWith<$Res> {
  _$OpportunityCopyWithImpl(this._self, this._then);

  final Opportunity _self;
  final $Res Function(Opportunity) _then;

  /// Create a copy of Opportunity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startupId = null,
    Object? startupName = null,
    Object? startupLogoUrl = freezed,
    Object? title = null,
    Object? description = null,
    Object? requirements = null,
    Object? responsibilities = freezed,
    Object? location = null,
    Object? type = null,
    Object? duration = null,
    Object? stipend = freezed,
    Object? skillsRequired = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? applicationDeadline = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requirements: null == requirements
          ? _self.requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      responsibilities: freezed == responsibilities
          ? _self.responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      stipend: freezed == stipend
          ? _self.stipend
          : stipend // ignore: cast_nullable_to_non_nullable
              as String?,
      skillsRequired: null == skillsRequired
          ? _self.skillsRequired
          : skillsRequired // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OpportunityStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      applicationDeadline: freezed == applicationDeadline
          ? _self.applicationDeadline
          : applicationDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Opportunity].
extension OpportunityPatterns on Opportunity {
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
    TResult Function(_Opportunity value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Opportunity() when $default != null:
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
    TResult Function(_Opportunity value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Opportunity():
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
    TResult? Function(_Opportunity value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Opportunity() when $default != null:
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
            String startupId,
            String startupName,
            String? startupLogoUrl,
            String title,
            String description,
            List<String> requirements,
            List<String>? responsibilities,
            String location,
            String type,
            String duration,
            String? stipend,
            List<String> skillsRequired,
            OpportunityStatus status,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt,
            @NullableTimestampConverter() DateTime? applicationDeadline)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Opportunity() when $default != null:
        return $default(
            _that.id,
            _that.startupId,
            _that.startupName,
            _that.startupLogoUrl,
            _that.title,
            _that.description,
            _that.requirements,
            _that.responsibilities,
            _that.location,
            _that.type,
            _that.duration,
            _that.stipend,
            _that.skillsRequired,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.applicationDeadline);
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
            String startupId,
            String startupName,
            String? startupLogoUrl,
            String title,
            String description,
            List<String> requirements,
            List<String>? responsibilities,
            String location,
            String type,
            String duration,
            String? stipend,
            List<String> skillsRequired,
            OpportunityStatus status,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt,
            @NullableTimestampConverter() DateTime? applicationDeadline)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Opportunity():
        return $default(
            _that.id,
            _that.startupId,
            _that.startupName,
            _that.startupLogoUrl,
            _that.title,
            _that.description,
            _that.requirements,
            _that.responsibilities,
            _that.location,
            _that.type,
            _that.duration,
            _that.stipend,
            _that.skillsRequired,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.applicationDeadline);
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
            String startupId,
            String startupName,
            String? startupLogoUrl,
            String title,
            String description,
            List<String> requirements,
            List<String>? responsibilities,
            String location,
            String type,
            String duration,
            String? stipend,
            List<String> skillsRequired,
            OpportunityStatus status,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt,
            @NullableTimestampConverter() DateTime? applicationDeadline)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Opportunity() when $default != null:
        return $default(
            _that.id,
            _that.startupId,
            _that.startupName,
            _that.startupLogoUrl,
            _that.title,
            _that.description,
            _that.requirements,
            _that.responsibilities,
            _that.location,
            _that.type,
            _that.duration,
            _that.stipend,
            _that.skillsRequired,
            _that.status,
            _that.createdAt,
            _that.updatedAt,
            _that.applicationDeadline);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Opportunity implements Opportunity {
  const _Opportunity(
      {required this.id,
      required this.startupId,
      required this.startupName,
      this.startupLogoUrl,
      required this.title,
      required this.description,
      required final List<String> requirements,
      final List<String>? responsibilities,
      required this.location,
      required this.type,
      required this.duration,
      this.stipend,
      required final List<String> skillsRequired,
      this.status = OpportunityStatus.pendingReview,
      @TimestampConverter() required this.createdAt,
      @NullableTimestampConverter() this.updatedAt,
      @NullableTimestampConverter() this.applicationDeadline})
      : _requirements = requirements,
        _responsibilities = responsibilities,
        _skillsRequired = skillsRequired;
  factory _Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);

  @override
  final String id;
  @override
  final String startupId;
  @override
  final String startupName;
  @override
  final String? startupLogoUrl;
  @override
  final String title;
  @override
  final String description;
  final List<String> _requirements;
  @override
  List<String> get requirements {
    if (_requirements is EqualUnmodifiableListView) return _requirements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requirements);
  }

  final List<String>? _responsibilities;
  @override
  List<String>? get responsibilities {
    final value = _responsibilities;
    if (value == null) return null;
    if (_responsibilities is EqualUnmodifiableListView)
      return _responsibilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String location;
// e.g. Kigali, Mauritius, Remote
  @override
  final String type;
// e.g. Full-time, Part-time, Internship
  @override
  final String duration;
// e.g. 3 months
  @override
  final String? stipend;
  final List<String> _skillsRequired;
  @override
  List<String> get skillsRequired {
    if (_skillsRequired is EqualUnmodifiableListView) return _skillsRequired;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skillsRequired);
  }

  @override
  @JsonKey()
  final OpportunityStatus status;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @NullableTimestampConverter()
  final DateTime? updatedAt;
  @override
  @NullableTimestampConverter()
  final DateTime? applicationDeadline;

  /// Create a copy of Opportunity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OpportunityCopyWith<_Opportunity> get copyWith =>
      __$OpportunityCopyWithImpl<_Opportunity>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$OpportunityToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Opportunity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startupId, startupId) ||
                other.startupId == startupId) &&
            (identical(other.startupName, startupName) ||
                other.startupName == startupName) &&
            (identical(other.startupLogoUrl, startupLogoUrl) ||
                other.startupLogoUrl == startupLogoUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._requirements, _requirements) &&
            const DeepCollectionEquality()
                .equals(other._responsibilities, _responsibilities) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.stipend, stipend) || other.stipend == stipend) &&
            const DeepCollectionEquality()
                .equals(other._skillsRequired, _skillsRequired) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.applicationDeadline, applicationDeadline) ||
                other.applicationDeadline == applicationDeadline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      startupId,
      startupName,
      startupLogoUrl,
      title,
      description,
      const DeepCollectionEquality().hash(_requirements),
      const DeepCollectionEquality().hash(_responsibilities),
      location,
      type,
      duration,
      stipend,
      const DeepCollectionEquality().hash(_skillsRequired),
      status,
      createdAt,
      updatedAt,
      applicationDeadline);

  @override
  String toString() {
    return 'Opportunity(id: $id, startupId: $startupId, startupName: $startupName, startupLogoUrl: $startupLogoUrl, title: $title, description: $description, requirements: $requirements, responsibilities: $responsibilities, location: $location, type: $type, duration: $duration, stipend: $stipend, skillsRequired: $skillsRequired, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, applicationDeadline: $applicationDeadline)';
  }
}

/// @nodoc
abstract mixin class _$OpportunityCopyWith<$Res>
    implements $OpportunityCopyWith<$Res> {
  factory _$OpportunityCopyWith(
          _Opportunity value, $Res Function(_Opportunity) _then) =
      __$OpportunityCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String startupId,
      String startupName,
      String? startupLogoUrl,
      String title,
      String description,
      List<String> requirements,
      List<String>? responsibilities,
      String location,
      String type,
      String duration,
      String? stipend,
      List<String> skillsRequired,
      OpportunityStatus status,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt,
      @NullableTimestampConverter() DateTime? applicationDeadline});
}

/// @nodoc
class __$OpportunityCopyWithImpl<$Res> implements _$OpportunityCopyWith<$Res> {
  __$OpportunityCopyWithImpl(this._self, this._then);

  final _Opportunity _self;
  final $Res Function(_Opportunity) _then;

  /// Create a copy of Opportunity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? startupId = null,
    Object? startupName = null,
    Object? startupLogoUrl = freezed,
    Object? title = null,
    Object? description = null,
    Object? requirements = null,
    Object? responsibilities = freezed,
    Object? location = null,
    Object? type = null,
    Object? duration = null,
    Object? stipend = freezed,
    Object? skillsRequired = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? applicationDeadline = freezed,
  }) {
    return _then(_Opportunity(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      requirements: null == requirements
          ? _self._requirements
          : requirements // ignore: cast_nullable_to_non_nullable
              as List<String>,
      responsibilities: freezed == responsibilities
          ? _self._responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _self.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String,
      stipend: freezed == stipend
          ? _self.stipend
          : stipend // ignore: cast_nullable_to_non_nullable
              as String?,
      skillsRequired: null == skillsRequired
          ? _self._skillsRequired
          : skillsRequired // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as OpportunityStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      applicationDeadline: freezed == applicationDeadline
          ? _self.applicationDeadline
          : applicationDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
