import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/firestore_converters.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String body,
    @Default(false) bool isRead,
    required String type,
    Map<String, dynamic>? payload,
    @TimestampConverter() required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
