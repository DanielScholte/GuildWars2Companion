part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class ScheduleNotificationEvent extends NotificationEvent {
  final ScheduledNotification notification;

  ScheduleNotificationEvent(this.notification);
}

class RemoveScheduledNotificationEvent extends NotificationEvent {
  final int id;

  RemoveScheduledNotificationEvent(this.id);
}

class RemoveExpiredNotificationsEvent extends NotificationEvent {}