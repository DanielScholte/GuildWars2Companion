import 'package:guildwars2_companion/features/event/models/notification.dart';
import 'package:guildwars2_companion/features/event/services/notification.dart';
import 'package:meta/meta.dart';

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