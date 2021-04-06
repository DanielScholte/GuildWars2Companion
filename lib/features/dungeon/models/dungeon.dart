import 'dart:ui';

class Dungeon {
  String name;
  String id;
  String location;
  Color color;
  List<DungeonPath> paths;

  Dungeon({
    this.name,
    this.id,
    this.color,
    this.paths,
    this.location,
  });
}

class DungeonPath {
  String id;
  String name;
  int coin;
  int level;
  bool completed;

  DungeonPath({
    this.id,
    this.name,
    this.coin,
    this.level,
    this.completed = false,
  });
}