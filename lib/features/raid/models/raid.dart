import 'dart:ui';

class Raid {
  String name;
  String id;
  Color color;
  List<RaidCheckpoint> checkpoints;

  Raid({
    this.name,
    this.id,
    this.color,
    this.checkpoints,
  });
}

class RaidCheckpoint {
  String id;
  String name;
  bool hasIcon;
  bool completed;

  RaidCheckpoint({
    this.id,
    this.name,
    this.hasIcon = true,
    this.completed = false,
  });
}