import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';

class MetaEventSegment {
  String id;
  String name;
  Duration duration;
  List<DateTime> times;
  DateTime time;
  EventType type;

  MetaEventSegment({
    this.id,
    this.name,
    @required this.duration,
    this.times,
    this.time,
  });
}