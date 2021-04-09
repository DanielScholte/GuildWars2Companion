import 'package:flutter/foundation.dart';
import 'package:guildwars2_companion/features/event/models/event_segment.dart';

class WorldBoss {
  String name;
  String id;
  String location;
  String waypoint;
  int level;
  bool hardDifficulty;
  bool completed;
  MetaEventSegment segment;

  WorldBoss({
    @required this.name,
    @required this.location,
    this.id,
    this.completed = false,
    this.hardDifficulty,
    this.level,
    this.waypoint,
    this.segment
  });

  WorldBoss.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    waypoint = json['waypoint'];
    level = json['level'];
    hardDifficulty = json['hardDifficulty'];
    completed = false;
  }
}