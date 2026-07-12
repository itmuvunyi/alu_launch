import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/providers/auth_providers.dart';
import '../models/notification.dart';
import '../repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationsStreamProvider = StreamProvider<List<NotificationModel>>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final user = userAsync.valueOrNull;

  if (user == null) {
    return Stream.value([]);
  }

  return ref.read(notificationRepositoryProvider).streamNotifications(user.uid);
});

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsStreamProvider).valueOrNull ?? [];
  return notifications.where((n) => !n.isRead).length;
});
