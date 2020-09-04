import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/notifications/notification.dart';

class MetaEventSequence {
  String id;
  String name;
  String region;
  Duration offset;
  List<MetaEventSegment> segments;

  MetaEventSequence({
    this.id,
    this.name,
    this.region,
    @required this.segments,
    this.offset = Duration.zero,
  });
}

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