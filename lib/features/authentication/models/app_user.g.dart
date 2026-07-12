// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      campus: json['campus'] as String?,
      resumeUrl: json['resumeUrl'] as String?,
      portfolioUrls: (json['portfolioUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      headline: json['headline'] as String?,
      skills:
          (json['skills'] as List<dynamic>?)?.map((e) => e as String).toList(),
      experiences: (json['experiences'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      projects: (json['projects'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      isVerified: json['isVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'phoneNumber': instance.phoneNumber,
      'campus': instance.campus,
      'resumeUrl': instance.resumeUrl,
      'portfolioUrls': instance.portfolioUrls,
      'headline': instance.headline,
      'skills': instance.skills,
      'experiences': instance.experiences,
      'projects': instance.projects,
      'isVerified': instance.isVerified,
      'isActive': instance.isActive,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const NullableTimestampConverter().toJson(instance.updatedAt),
    };

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.startupFounder: 'startupFounder',
  UserRole.admin: 'admin',
};
