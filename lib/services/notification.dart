import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:guildwars2_companion/migrations/notification.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  NotificationDetails _defaultNotificationDetails;

  List<ScheduledNotification> _scheduledNotifications = [];

  Future<void> initializeNotifications() async {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    await _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        AndroidInitializationSettings("ic_notification"),
        IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        )
      )
    );

    _defaultNotificationDetails = NotificationDetails(
      AndroidNotificationDetails(
        'event_notifications',
        'World bosses and Meta events',
        'Notifications for upcoming World bosses and Meta events',
        largeIcon: DrawableResourceAndroidBitmap("ic_notification_large"),
        color: Colors.red
      ),
      IOSNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true
      )
    );

    await _loadNotifications();
  }

  List<ScheduledNotification> getScheduledNotifications() => _scheduledNotifications;

  Future<void> scheduleNotification(ScheduledNotification notification) async {
    await _requestPermissions();

    notification.id = _getUniqueId();
    notification.dateTime = notification.spawnDateTime.subtract(notification.offset);
    notification.eventName = notification.eventName + (notification.eventType == EventType.META_EVENT ? " event" : "");

    String description = "";

    if (notification.eventType == EventType.META_EVENT) description += "Starting ";
    else description += "Spawning ";

    if (notification.offset.inMinutes == 0) description += "now";
    else if (notification.offset.inMinutes >= 60) description += "in ${notification.offset.inHours} hours";
    else description += "in ${notification.offset.inMinutes} minutes";

    switch (notification.type) {
      case NotificationType.SINGLE:
        await _flutterLocalNotificationsPlugin.schedule(
          notification.id,
          notification.eventName,
          description,
          notification.dateTime,
          _defaultNotificationDetails
        );
        break;
      case NotificationType.DAILY:
        await _flutterLocalNotificationsPlugin.showDailyAtTime(
          notification.id,
          notification.eventName,
          description,
          Time(
            notification.dateTime.hour,
            notification.dateTime.minute
          ),
          _defaultNotificationDetails
        );
        break;
    }

    Database database = await _getDatabase();

    await database.insert(
      "notifications",
      notification.toDb(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );

    await _loadNotifications(useConnection: database);
  }

  Future<void> removeScheduledNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);

    Database database = await _getDatabase();

    await database.delete(
      'notifications',
      where: "id = ?",
      whereArgs: [id],
    );

    await _loadNotifications(useConnection: database);
  }

  Future<bool> removeExpiredNotifications() async {
    if (_scheduledNotifications.any((n) => n.type == NotificationType.SINGLE && n.dateTime.compareTo(DateTime.now()) <= 0)) {
      await _loadNotifications();

      return true;
    }

    return false;
  }

  Future<Database> _getDatabase() async {
    return await openDatabaseWithMigration(
      join(await getDatabasesPath(), 'notifications.db'),
      NotificationMigrations.config
    );
  }

  Future<void> _loadNotifications({ Database useConnection }) async {
    Database notificationDatabase = useConnection != null ? useConnection : await _getDatabase();

    await notificationDatabase.delete(
      'notifications',
      where: "date_time <= ? and type = ?",
      whereArgs: [
        (DateTime.now().millisecondsSinceEpoch / 60000).floor(),
        NotificationType.SINGLE.index
      ],
    );

    final List<Map<String, dynamic>> notifications = await notificationDatabase.query('notifications');
    _scheduledNotifications = List.generate(notifications.length, (i) => ScheduledNotification.fromDb(notifications[i]));

    notificationDatabase.close();

    return;
  }

  Future<void> _requestPermissions() async {
    await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  }

  int _getUniqueId() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
}