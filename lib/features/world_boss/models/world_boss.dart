import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:guildwars2_companion/core/models/event_segment.dart';

class WorldBoss {
  String name;
  String id;
  String location;
  String waypoint;
  int level;
  Color color;
  bool completed;
  MetaEventSegment segment;

  WorldBoss({
    @required this.name,
    @required this.location,
    this.id,
    this.completed = false,
    this.color,
    this.level,
    this.waypoint,
    this.segment
  });
}