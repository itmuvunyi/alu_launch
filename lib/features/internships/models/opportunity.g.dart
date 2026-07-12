// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opportunity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Opportunity _$OpportunityFromJson(Map<String, dynamic> json) => _Opportunity(
      id: json['id'] as String,
      startupId: json['startupId'] as String,
      startupName: json['startupName'] as String,
      startupLogoUrl: json['startupLogoUrl'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      responsibilities: (json['responsibilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      location: json['location'] as String,
      type: json['type'] as String,
      duration: json['duration'] as String,
      stipend: json['stipend'] as String?,
      skillsRequired: (json['skillsRequired'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: $enumDecodeNullable(_$OpportunityStatusEnumMap, json['status']) ??
          OpportunityStatus.pendingReview,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
      applicationDeadline: const NullableTimestampConverter()
          .fromJson(json['applicationDeadline']),
    );

Map<String, dynamic> _$OpportunityToJson(_Opportunity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startupId': instance.startupId,
      'startupName': instance.startupName,
      'startupLogoUrl': instance.startupLogoUrl,
      'title': instance.title,
      'description': instance.description,
      'requirements': instance.requirements,
      'responsibilities': instance.responsibilities,
      'location': instance.location,
      'type': instance.type,
      'duration': instance.duration,
      'stipend': instance.stipend,
      'skillsRequired': instance.skillsRequired,
      'status': _$OpportunityStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const NullableTimestampConverter().toJson(instance.updatedAt),
      'applicationDeadline': const NullableTimestampConverter()
          .toJson(instance.applicationDeadline),
    };

const _$OpportunityStatusEnumMap = {
  OpportunityStatus.draft: 'draft',
  OpportunityStatus.pendingReview: 'pendingReview',
  OpportunityStatus.approved: 'approved',
  OpportunityStatus.rejected: 'rejected',
  OpportunityStatus.expired: 'expired',
};
