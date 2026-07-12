import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../../core/utils/firestore_converters.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    required UserRole role,
    required String displayName,
    String? photoUrl,
    String? phoneNumber,
    String? campus,
    String? resumeUrl,
    List<String>? portfolioUrls,
    String? headline,
    List<String>? skills,
    List<Map<String, dynamic>>? experiences,
    List<Map<String, dynamic>>? projects,
    @Default(false) bool isVerified,
    @Default(true) bool isActive,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
