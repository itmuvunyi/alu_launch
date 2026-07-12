// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {
  String get uid;
  String get email;
  UserRole get role;
  String get displayName;
  String? get photoUrl;
  String? get phoneNumber;
  String? get campus;
  String? get resumeUrl;
  List<String>? get portfolioUrls;
  String? get headline;
  List<String>? get skills;
  List<Map<String, dynamic>>? get experiences;
  List<Map<String, dynamic>>? get projects;
  bool get isVerified;
  bool get isActive;
  @TimestampConverter()
  DateTime get createdAt;
  @NullableTimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppUserCopyWith<AppUser> get copyWith =>
      _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppUser &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.campus, campus) || other.campus == campus) &&
            (identical(other.resumeUrl, resumeUrl) ||
                other.resumeUrl == resumeUrl) &&
            const DeepCollectionEquality()
                .equals(other.portfolioUrls, portfolioUrls) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            const DeepCollectionEquality().equals(other.skills, skills) &&
            const DeepCollectionEquality()
                .equals(other.experiences, experiences) &&
            const DeepCollectionEquality().equals(other.projects, projects) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      role,
      displayName,
      photoUrl,
      phoneNumber,
      campus,
      resumeUrl,
      const DeepCollectionEquality().hash(portfolioUrls),
      headline,
      const DeepCollectionEquality().hash(skills),
      const DeepCollectionEquality().hash(experiences),
      const DeepCollectionEquality().hash(projects),
      isVerified,
      isActive,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, role: $role, displayName: $displayName, photoUrl: $photoUrl, phoneNumber: $phoneNumber, campus: $campus, resumeUrl: $resumeUrl, portfolioUrls: $portfolioUrls, headline: $headline, skills: $skills, experiences: $experiences, projects: $projects, isVerified: $isVerified, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) =
      _$AppUserCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String email,
      UserRole role,
      String displayName,
      String? photoUrl,
      String? phoneNumber,
      String? campus,
      String? resumeUrl,
      List<String>? portfolioUrls,
      String? headline,
      List<String>? skills,
      List<Map<String, dynamic>>? experiences,
      List<Map<String, dynamic>>? projects,
      bool isVerified,
      bool isActive,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res> implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? role = null,
    Object? displayName = null,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? campus = freezed,
    Object? resumeUrl = freezed,
    Object? portfolioUrls = freezed,
    Object? headline = freezed,
    Object? skills = freezed,
    Object? experiences = freezed,
    Object? projects = freezed,
    Object? isVerified = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _self.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      campus: freezed == campus
          ? _self.campus
          : campus // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeUrl: freezed == resumeUrl
          ? _self.resumeUrl
          : resumeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioUrls: freezed == portfolioUrls
          ? _self.portfolioUrls
          : portfolioUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      headline: freezed == headline
          ? _self.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: freezed == skills
          ? _self.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      experiences: freezed == experiences
          ? _self.experiences
          : experiences // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      projects: freezed == projects
          ? _self.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      isVerified: null == isVerified
          ? _self.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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

/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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
    TResult Function(_AppUser value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppUser() when $default != null:
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
    TResult Function(_AppUser value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppUser():
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
    TResult? Function(_AppUser value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppUser() when $default != null:
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
            String uid,
            String email,
            UserRole role,
            String displayName,
            String? photoUrl,
            String? phoneNumber,
            String? campus,
            String? resumeUrl,
            List<String>? portfolioUrls,
            String? headline,
            List<String>? skills,
            List<Map<String, dynamic>>? experiences,
            List<Map<String, dynamic>>? projects,
            bool isVerified,
            bool isActive,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AppUser() when $default != null:
        return $default(
            _that.uid,
            _that.email,
            _that.role,
            _that.displayName,
            _that.photoUrl,
            _that.phoneNumber,
            _that.campus,
            _that.resumeUrl,
            _that.portfolioUrls,
            _that.headline,
            _that.skills,
            _that.experiences,
            _that.projects,
            _that.isVerified,
            _that.isActive,
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
            String uid,
            String email,
            UserRole role,
            String displayName,
            String? photoUrl,
            String? phoneNumber,
            String? campus,
            String? resumeUrl,
            List<String>? portfolioUrls,
            String? headline,
            List<String>? skills,
            List<Map<String, dynamic>>? experiences,
            List<Map<String, dynamic>>? projects,
            bool isVerified,
            bool isActive,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppUser():
        return $default(
            _that.uid,
            _that.email,
            _that.role,
            _that.displayName,
            _that.photoUrl,
            _that.phoneNumber,
            _that.campus,
            _that.resumeUrl,
            _that.portfolioUrls,
            _that.headline,
            _that.skills,
            _that.experiences,
            _that.projects,
            _that.isVerified,
            _that.isActive,
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
            String uid,
            String email,
            UserRole role,
            String displayName,
            String? photoUrl,
            String? phoneNumber,
            String? campus,
            String? resumeUrl,
            List<String>? portfolioUrls,
            String? headline,
            List<String>? skills,
            List<Map<String, dynamic>>? experiences,
            List<Map<String, dynamic>>? projects,
            bool isVerified,
            bool isActive,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AppUser() when $default != null:
        return $default(
            _that.uid,
            _that.email,
            _that.role,
            _that.displayName,
            _that.photoUrl,
            _that.phoneNumber,
            _that.campus,
            _that.resumeUrl,
            _that.portfolioUrls,
            _that.headline,
            _that.skills,
            _that.experiences,
            _that.projects,
            _that.isVerified,
            _that.isActive,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AppUser implements AppUser {
  const _AppUser(
      {required this.uid,
      required this.email,
      required this.role,
      required this.displayName,
      this.photoUrl,
      this.phoneNumber,
      this.campus,
      this.resumeUrl,
      final List<String>? portfolioUrls,
      this.headline,
      final List<String>? skills,
      final List<Map<String, dynamic>>? experiences,
      final List<Map<String, dynamic>>? projects,
      this.isVerified = false,
      this.isActive = true,
      @TimestampConverter() required this.createdAt,
      @NullableTimestampConverter() this.updatedAt})
      : _portfolioUrls = portfolioUrls,
        _skills = skills,
        _experiences = experiences,
        _projects = projects;
  factory _AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  @override
  final String uid;
  @override
  final String email;
  @override
  final UserRole role;
  @override
  final String displayName;
  @override
  final String? photoUrl;
  @override
  final String? phoneNumber;
  @override
  final String? campus;
  @override
  final String? resumeUrl;
  final List<String>? _portfolioUrls;
  @override
  List<String>? get portfolioUrls {
    final value = _portfolioUrls;
    if (value == null) return null;
    if (_portfolioUrls is EqualUnmodifiableListView) return _portfolioUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? headline;
  final List<String>? _skills;
  @override
  List<String>? get skills {
    final value = _skills;
    if (value == null) return null;
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _experiences;
  @override
  List<Map<String, dynamic>>? get experiences {
    final value = _experiences;
    if (value == null) return null;
    if (_experiences is EqualUnmodifiableListView) return _experiences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _projects;
  @override
  List<Map<String, dynamic>>? get projects {
    final value = _projects;
    if (value == null) return null;
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @NullableTimestampConverter()
  final DateTime? updatedAt;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppUserCopyWith<_AppUser> get copyWith =>
      __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppUserToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppUser &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.campus, campus) || other.campus == campus) &&
            (identical(other.resumeUrl, resumeUrl) ||
                other.resumeUrl == resumeUrl) &&
            const DeepCollectionEquality()
                .equals(other._portfolioUrls, _portfolioUrls) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality()
                .equals(other._experiences, _experiences) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uid,
      email,
      role,
      displayName,
      photoUrl,
      phoneNumber,
      campus,
      resumeUrl,
      const DeepCollectionEquality().hash(_portfolioUrls),
      headline,
      const DeepCollectionEquality().hash(_skills),
      const DeepCollectionEquality().hash(_experiences),
      const DeepCollectionEquality().hash(_projects),
      isVerified,
      isActive,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'AppUser(uid: $uid, email: $email, role: $role, displayName: $displayName, photoUrl: $photoUrl, phoneNumber: $phoneNumber, campus: $campus, resumeUrl: $resumeUrl, portfolioUrls: $portfolioUrls, headline: $headline, skills: $skills, experiences: $experiences, projects: $projects, isVerified: $isVerified, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) =
      __$AppUserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String email,
      UserRole role,
      String displayName,
      String? photoUrl,
      String? phoneNumber,
      String? campus,
      String? resumeUrl,
      List<String>? portfolioUrls,
      String? headline,
      List<String>? skills,
      List<Map<String, dynamic>>? experiences,
      List<Map<String, dynamic>>? projects,
      bool isVerified,
      bool isActive,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$AppUserCopyWithImpl<$Res> implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? email = null,
    Object? role = null,
    Object? displayName = null,
    Object? photoUrl = freezed,
    Object? phoneNumber = freezed,
    Object? campus = freezed,
    Object? resumeUrl = freezed,
    Object? portfolioUrls = freezed,
    Object? headline = freezed,
    Object? skills = freezed,
    Object? experiences = freezed,
    Object? projects = freezed,
    Object? isVerified = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_AppUser(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      displayName: null == displayName
          ? _self.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _self.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      campus: freezed == campus
          ? _self.campus
          : campus // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeUrl: freezed == resumeUrl
          ? _self.resumeUrl
          : resumeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioUrls: freezed == portfolioUrls
          ? _self._portfolioUrls
          : portfolioUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      headline: freezed == headline
          ? _self.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: freezed == skills
          ? _self._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      experiences: freezed == experiences
          ? _self._experiences
          : experiences // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      projects: freezed == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      isVerified: null == isVerified
          ? _self.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
