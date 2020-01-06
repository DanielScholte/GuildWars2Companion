import 'dart:ui';

class Dungeon {
  String name;
  String pathName;
  String pathId;
  String id;
  int coin;
  int level;
  Color color;
  bool completed;

  Dungeon({
    this.name,
    this.pathName,
    this.pathId,
    this.id,
    this.coin,
    this.level,
    this.color,
    this.completed
  });
}