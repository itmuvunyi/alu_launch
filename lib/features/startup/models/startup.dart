import 'package:freezed_annotation/freezed_annotation.dart';


import '../../../core/utils/firestore_converters.dart';

part 'startup.freezed.dart';
part 'startup.g.dart';

@freezed
abstract class Startup with _$Startup {
  const factory Startup({
    required String id,
    required String ownerId,
    required String name,
    required String description,
    String? logoUrl,
    required String industry,
    String? website,
    required String email,
    String? phone,
    required String location,
    String? verificationDocPath,
    @Default(false) bool isVerified,
    @TimestampConverter() required DateTime createdAt,
    @NullableTimestampConverter() DateTime? updatedAt,
  }) = _Startup;

  factory Startup.fromJson(Map<String, dynamic> json) =>
      _$StartupFromJson(json);
}
