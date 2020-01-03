import 'dart:ui';

import 'package:flutter/foundation.dart';

class WorldBoss {
  String name;
  String id;
  String location;
  String waypoint;
  int level;
  Color color;
  bool completed;
  DateTime dateTime;
  DateTime refreshTime;
  List<String> times;

  WorldBoss({
    @required this.name,
    @required this.location,
    this.id,
    this.dateTime,
    this.completed,
    this.refreshTime,
    this.times,
    this.color,
    this.level,
    this.waypoint
  });
}