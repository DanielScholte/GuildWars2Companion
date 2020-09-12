import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:guildwars2_companion/repositories/notification.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({
    @required this.notificationRepository,
  }) : super(ScheduledNotificationsState(notificationRepository.getScheduledNotifications()));

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is ScheduleNotificationEvent) {
      yield* _scheduleNotification(event);
    } else if (event is RemoveScheduledNotificationEvent) {
      yield* _removeScheduledNotification(event);
    } else if (event is RemoveExpiredNotificationsEvent) {
      yield* _removeExpiredNotifications();
    }
  }

  Stream<NotificationState> _scheduleNotification(ScheduleNotificationEvent event) async* {
    yield LoadingScheduledNotificationsState();

    await notificationRepository.scheduleNotification(event.notification);

    yield getScheduledNotificationsState();
  }

  Stream<NotificationState> _removeScheduledNotification(RemoveScheduledNotificationEvent event) async* {
    yield LoadingScheduledNotificationsState();

    await notificationRepository.removeScheduledNotification(event.id);

    yield getScheduledNotificationsState();
  }

  Stream<NotificationState> _removeExpiredNotifications() async* {
    if (await notificationRepository.removeExpiredNotifications()) {
      yield getScheduledNotificationsState();
    }
  }

  ScheduledNotificationsState getScheduledNotificationsState() =>
    ScheduledNotificationsState(notificationRepository.getScheduledNotifications());
}
