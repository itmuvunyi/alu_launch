// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApplicationTimelineEvent _$ApplicationTimelineEventFromJson(
        Map<String, dynamic> json) =>
    _ApplicationTimelineEvent(
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      time: const TimestampConverter().fromJson(json['time']),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ApplicationTimelineEventToJson(
        _ApplicationTimelineEvent instance) =>
    <String, dynamic>{
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'time': const TimestampConverter().toJson(instance.time),
      'notes': instance.notes,
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.applied: 'applied',
  ApplicationStatus.underReview: 'underReview',
  ApplicationStatus.shortlisted: 'shortlisted',
  ApplicationStatus.interviewScheduled: 'interviewScheduled',
  ApplicationStatus.accepted: 'accepted',
  ApplicationStatus.rejected: 'rejected',
};

_Application _$ApplicationFromJson(Map<String, dynamic> json) => _Application(
      id: json['id'] as String,
      opportunityId: json['opportunityId'] as String,
      opportunityTitle: json['opportunityTitle'] as String,
      startupId: json['startupId'] as String,
      startupName: json['startupName'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      studentEmail: json['studentEmail'] as String,
      studentResumeUrl: json['studentResumeUrl'] as String?,
      studentPortfolioUrls: (json['studentPortfolioUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: $enumDecodeNullable(_$ApplicationStatusEnumMap, json['status']) ??
          ApplicationStatus.applied,
      timeline: _timelineFromJson(json['timeline'] as List),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const NullableTimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$ApplicationToJson(_Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'opportunityId': instance.opportunityId,
      'opportunityTitle': instance.opportunityTitle,
      'startupId': instance.startupId,
      'startupName': instance.startupName,
      'studentId': instance.studentId,
      'studentName': instance.studentName,
      'studentEmail': instance.studentEmail,
      'studentResumeUrl': instance.studentResumeUrl,
      'studentPortfolioUrls': instance.studentPortfolioUrls,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'timeline': _timelineToJson(instance.timeline),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt':
          const NullableTimestampConverter().toJson(instance.updatedAt),
    };
