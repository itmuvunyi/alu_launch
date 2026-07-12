import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts Firestore `Timestamp` <-> `DateTime` for required fields.
/// Firestore returns `Timestamp` objects in `doc.data()`, not ISO strings —
/// without this, json_serializable's generated fromJson would crash on
/// every document read.
class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json is Timestamp) return json.toDate();
    if (json is DateTime) return json;
    if (json is String) return DateTime.parse(json);
    return DateTime.now();
  }

  @override
  Object toJson(DateTime object) => Timestamp.fromDate(object);
}

/// Same as [TimestampConverter] but for nullable DateTime fields
/// (e.g. `updatedAt`, which is null until the first edit).
class NullableTimestampConverter implements JsonConverter<DateTime?, Object?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is DateTime) return json;
    if (json is String) return DateTime.parse(json);
    return null;
  }

  @override
  Object? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}