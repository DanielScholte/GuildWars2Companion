import 'package:flutter/widgets.dart';

class ScheduledNotification {
  int id;
  NotificationType type;
  String eventId;
  String eventName;
  EventType eventType;
  DateTime dateTime;
  DateTime spawnDateTime;
  Duration offset;

  ScheduledNotification({
    @required this.type,
    @required this.eventId,
    @required this.eventName,
    @required this.eventType,
    @required this.spawnDateTime,
    @required this.offset
  });

  ScheduledNotification.fromDb(Map<String, dynamic> db) {
    id =  db['id'];
    type = NotificationType.values[db['type']];
    eventId = db['event_id'];
    eventName = db['event_name'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(db['date_time'] * 60000);
    spawnDateTime = DateTime.fromMillisecondsSinceEpoch(db['spawn_date_time'] * 60000);
    offset = Duration(minutes: db['offset']);
  }

  Map<String, dynamic> toDb() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['type'] = this.type.index;
    data['event_id'] = this.eventId;
    data['event_name'] = this.eventName;
    data['date_time'] = (this.dateTime.millisecondsSinceEpoch / 60000).floor();
    data['spawn_date_time'] = (this.spawnDateTime.millisecondsSinceEpoch / 60000).floor();
    data['offset'] = this.offset.inMinutes;

    return data;
  }
}

enum EventType {
  WORLD_BOSS,
  META_EVENT
}

enum NotificationType {
  SINGLE,
  DAILY
}