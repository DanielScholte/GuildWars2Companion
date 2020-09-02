import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/services/notification.dart';

class NotificationRepository {
  final NotificationService notificationService;

  NotificationRepository({
    @required this.notificationService
  });

  Future<void> scheduleNotification(ScheduledNotification notification) => notificationService.scheduleNotification(notification);

  Future<void> cancelScheduledNotification(int id) => notificationService.cancelScheduledNotification(id);

  Future<bool> removeExpiredNotifications() => notificationService.removeExpiredNotifications();
}