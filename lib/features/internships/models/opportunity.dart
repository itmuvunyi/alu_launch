import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/constants/firestore_paths.dart';
import '../../../core/utils/firestore_converters.dart';

part 'opportunity.freezed.dart';
part 'opportunity.g.dart';

@freezed
abstract class Opportunity with _$Opportunity {
  const factory Opportunity({
    required String id,
    required String startupId,
    required String startupName,
    String? startupLogoUrl,
    required String title,
    required String description,
    required List<String> requirements,
    List<String>? responsibilities,
    required String location, // e.g. Kigali, Mauritius, Remote
    required String type, // e.g. Full-time, Part-time, Internship
    required String duration, // e.g. 3 months
    String? stipend,
    required List<String> skillsRequired,
    @Default(OpportunityStatus.pendingReview) OpportunityStatus status,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
    @NullableTimestampConverter() DateTime? applicationDeadline,
  }) = _Opportunity;

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);
}
