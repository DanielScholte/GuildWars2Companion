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

  Dungeon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    location = json['location'];
    color = Color.fromARGB(
      json['color']['a'],
      json['color']['r'],
      json['color']['g'],
      json['color']['b']
    );
    if (json['paths'] != null) {
      paths = (json['paths'] as List)
        .map((j) => DungeonPath.fromJson(j))
        .toList();
    }
  }
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

  DungeonPath.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coin = json['coin'];
    level = json['level'];
    completed = false;
  }
}