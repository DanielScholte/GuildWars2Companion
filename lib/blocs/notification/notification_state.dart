part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

class LoadingScheduledNotificationsState extends NotificationState {}

class ScheduledNotificationsState extends NotificationState {
  final List<ScheduledNotification> scheduledNotifications;

  ScheduledNotificationsState(this.scheduledNotifications);
}
