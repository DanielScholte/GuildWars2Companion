import 'dart:ui';

class Dungeon {
  String name;
  String id;
  Color color;
  List<DungeonPath> paths;

  Dungeon({
    this.name,
    this.id,
    this.color,
    this.paths,
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