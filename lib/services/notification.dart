import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> initializeNotifications() async {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    await _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        AndroidInitializationSettings("ic_notification"),
        IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        )
      )
    );

    await _scheduleTestNotification();
  }

  Future<void> _scheduleTestNotification() async {
    await _flutterLocalNotificationsPlugin.schedule(
      _getUniqueId(),
      'Shadow Behemoth',
      'Spawning in 10 minutes',
      DateTime.now().add(Duration(minutes: 1)),
      NotificationDetails(
        AndroidNotificationDetails(
          'event_notifications',
          'World bosses and Meta events',
          'Notifications for upcoming World bosses and Meta events',
          largeIcon: DrawableResourceAndroidBitmap("ic_notification_large")
        ),
        IOSNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true
        )
      )
    );
  }

  int _getUniqueId() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
}