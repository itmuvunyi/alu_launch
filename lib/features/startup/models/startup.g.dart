// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Startup _$StartupFromJson(Map<String, dynamic> json) => _Startup(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      logoUrl: json['logoUrl'] as String?,
      industry: json['industry'] as String,
      website: json['website'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      location: json['location'] as String,
      verificationDocPath: json['verificationDocPath'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$StartupToJson(_Startup instance) => <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'logoUrl': instance.logoUrl,
      'industry': instance.industry,
      'website': instance.website,
      'email': instance.email,
      'phone': instance.phone,
      'location': instance.location,
      'verificationDocPath': instance.verificationDocPath,
      'isVerified': instance.isVerified,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const NullableTimestampConverter().toJson(instance.updatedAt),
    };
