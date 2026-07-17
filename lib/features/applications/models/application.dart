import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../../core/utils/firestore_converters.dart';

part 'application.freezed.dart';
part 'application.g.dart';

List<ApplicationTimelineEvent> _timelineFromJson(List<dynamic> json) {
  return json
      .map((e) => ApplicationTimelineEvent.fromJson(e as Map<String, dynamic>))
      .toList();
}

List<Map<String, dynamic>> _timelineToJson(List<ApplicationTimelineEvent> timeline) {
  return timeline.map((e) => e.toJson()).toList();
}

@freezed
abstract class ApplicationTimelineEvent with _$ApplicationTimelineEvent {
  const factory ApplicationTimelineEvent({
    required ApplicationStatus status,
    @TimestampConverter() required DateTime time,
    String? notes,
  }) = _ApplicationTimelineEvent;

  factory ApplicationTimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$ApplicationTimelineEventFromJson(json);
}

@freezed
abstract class Application with _$Application {
  const factory Application({
    required String id,
    required String opportunityId,
    required String opportunityTitle,
    required String startupId,
    required String startupName,
    required String studentId,
    required String studentName,
    required String studentEmail,
    String? studentResumeUrl,
    List<String>? studentPortfolioUrls,
    @Default(ApplicationStatus.applied) ApplicationStatus status,
    @JsonKey(fromJson: _timelineFromJson, toJson: _timelineToJson)
    required List<ApplicationTimelineEvent> timeline,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _Application;

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);
}
