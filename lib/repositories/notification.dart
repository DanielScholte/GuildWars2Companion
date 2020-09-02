import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/services/notification.dart';

class NotificationRepository {
  final NotificationService notificationService;

  NotificationRepository({
    @required this.notificationService
  });

  List<ScheduledNotification> getScheduledNotifications() => notificationService.getScheduledNotifications();

  Future<void> scheduleNotification(ScheduledNotification notification) => notificationService.scheduleNotification(notification);

  Future<void> removeScheduledNotification(int id) => notificationService.removeScheduledNotification(id);

  Future<bool> removeExpiredNotifications() => notificationService.removeExpiredNotifications();
}