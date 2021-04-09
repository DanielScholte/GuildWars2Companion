import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/event/models/notification.dart';

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

  MetaEventSegment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    duration = Duration(minutes: json['durationInMinutes']);
  }
}