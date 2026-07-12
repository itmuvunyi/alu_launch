// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'startup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Startup {
  String get id;
  String get ownerId;
  String get name;
  String get description;
  String? get logoUrl;
  String get industry;
  String? get website;
  String get email;
  String? get phone;
  String get location;
  String? get verificationDocPath;
  bool get isVerified;
  @TimestampConverter()
  DateTime get createdAt;
  @NullableTimestampConverter()
  DateTime? get updatedAt;

  /// Create a copy of Startup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $StartupCopyWith<Startup> get copyWith =>
      _$StartupCopyWithImpl<Startup>(this as Startup, _$identity);

  /// Serializes this Startup to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Startup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.verificationDocPath, verificationDocPath) ||
                other.verificationDocPath == verificationDocPath) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
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
      ownerId,
      name,
      description,
      logoUrl,
      industry,
      website,
      email,
      phone,
      location,
      verificationDocPath,
      isVerified,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'Startup(id: $id, ownerId: $ownerId, name: $name, description: $description, logoUrl: $logoUrl, industry: $industry, website: $website, email: $email, phone: $phone, location: $location, verificationDocPath: $verificationDocPath, isVerified: $isVerified, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $StartupCopyWith<$Res> {
  factory $StartupCopyWith(Startup value, $Res Function(Startup) _then) =
      _$StartupCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String description,
      String? logoUrl,
      String industry,
      String? website,
      String email,
      String? phone,
      String location,
      String? verificationDocPath,
      bool isVerified,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class _$StartupCopyWithImpl<$Res> implements $StartupCopyWith<$Res> {
  _$StartupCopyWithImpl(this._self, this._then);

  final Startup _self;
  final $Res Function(Startup) _then;

  /// Create a copy of Startup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = null,
    Object? logoUrl = freezed,
    Object? industry = null,
    Object? website = freezed,
    Object? email = null,
    Object? phone = freezed,
    Object? location = null,
    Object? verificationDocPath = freezed,
    Object? isVerified = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: null == industry
          ? _self.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      verificationDocPath: freezed == verificationDocPath
          ? _self.verificationDocPath
          : verificationDocPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _self.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [Startup].
extension StartupPatterns on Startup {
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
    TResult Function(_Startup value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Startup() when $default != null:
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
    TResult Function(_Startup value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Startup():
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
    TResult? Function(_Startup value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Startup() when $default != null:
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
            String ownerId,
            String name,
            String description,
            String? logoUrl,
            String industry,
            String? website,
            String email,
            String? phone,
            String location,
            String? verificationDocPath,
            bool isVerified,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Startup() when $default != null:
        return $default(
            _that.id,
            _that.ownerId,
            _that.name,
            _that.description,
            _that.logoUrl,
            _that.industry,
            _that.website,
            _that.email,
            _that.phone,
            _that.location,
            _that.verificationDocPath,
            _that.isVerified,
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
            String ownerId,
            String name,
            String description,
            String? logoUrl,
            String industry,
            String? website,
            String email,
            String? phone,
            String location,
            String? verificationDocPath,
            bool isVerified,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Startup():
        return $default(
            _that.id,
            _that.ownerId,
            _that.name,
            _that.description,
            _that.logoUrl,
            _that.industry,
            _that.website,
            _that.email,
            _that.phone,
            _that.location,
            _that.verificationDocPath,
            _that.isVerified,
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
            String ownerId,
            String name,
            String description,
            String? logoUrl,
            String industry,
            String? website,
            String email,
            String? phone,
            String location,
            String? verificationDocPath,
            bool isVerified,
            @TimestampConverter() DateTime createdAt,
            @NullableTimestampConverter() DateTime? updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Startup() when $default != null:
        return $default(
            _that.id,
            _that.ownerId,
            _that.name,
            _that.description,
            _that.logoUrl,
            _that.industry,
            _that.website,
            _that.email,
            _that.phone,
            _that.location,
            _that.verificationDocPath,
            _that.isVerified,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Startup implements Startup {
  const _Startup(
      {required this.id,
      required this.ownerId,
      required this.name,
      required this.description,
      this.logoUrl,
      required this.industry,
      this.website,
      required this.email,
      this.phone,
      required this.location,
      this.verificationDocPath,
      this.isVerified = false,
      @TimestampConverter() required this.createdAt,
      @NullableTimestampConverter() this.updatedAt});
  factory _Startup.fromJson(Map<String, dynamic> json) =>
      _$StartupFromJson(json);

  @override
  final String id;
  @override
  final String ownerId;
  @override
  final String name;
  @override
  final String description;
  @override
  final String? logoUrl;
  @override
  final String industry;
  @override
  final String? website;
  @override
  final String email;
  @override
  final String? phone;
  @override
  final String location;
  @override
  final String? verificationDocPath;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @NullableTimestampConverter()
  final DateTime? updatedAt;

  /// Create a copy of Startup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$StartupCopyWith<_Startup> get copyWith =>
      __$StartupCopyWithImpl<_Startup>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$StartupToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Startup &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.industry, industry) ||
                other.industry == industry) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.verificationDocPath, verificationDocPath) ||
                other.verificationDocPath == verificationDocPath) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
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
      ownerId,
      name,
      description,
      logoUrl,
      industry,
      website,
      email,
      phone,
      location,
      verificationDocPath,
      isVerified,
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'Startup(id: $id, ownerId: $ownerId, name: $name, description: $description, logoUrl: $logoUrl, industry: $industry, website: $website, email: $email, phone: $phone, location: $location, verificationDocPath: $verificationDocPath, isVerified: $isVerified, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$StartupCopyWith<$Res> implements $StartupCopyWith<$Res> {
  factory _$StartupCopyWith(_Startup value, $Res Function(_Startup) _then) =
      __$StartupCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String description,
      String? logoUrl,
      String industry,
      String? website,
      String email,
      String? phone,
      String location,
      String? verificationDocPath,
      bool isVerified,
      @TimestampConverter() DateTime createdAt,
      @NullableTimestampConverter() DateTime? updatedAt});
}

/// @nodoc
class __$StartupCopyWithImpl<$Res> implements _$StartupCopyWith<$Res> {
  __$StartupCopyWithImpl(this._self, this._then);

  final _Startup _self;
  final $Res Function(_Startup) _then;

  /// Create a copy of Startup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = null,
    Object? logoUrl = freezed,
    Object? industry = null,
    Object? website = freezed,
    Object? email = null,
    Object? phone = freezed,
    Object? location = null,
    Object? verificationDocPath = freezed,
    Object? isVerified = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_Startup(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _self.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _self.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      industry: null == industry
          ? _self.industry
          : industry // ignore: cast_nullable_to_non_nullable
              as String,
      website: freezed == website
          ? _self.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      verificationDocPath: freezed == verificationDocPath
          ? _self.verificationDocPath
          : verificationDocPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _self.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
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
