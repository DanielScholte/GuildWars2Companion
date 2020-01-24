import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/other/dungeon.dart';
import 'package:guildwars2_companion/services/dungeon.dart';

class DungeonRepository {
  final DungeonService dungeonService;

  DungeonRepository({
    @required this.dungeonService
  });

  Future<List<Dungeon>> getDungeons(bool includeProgress) async {
    List<Dungeon> dungeons = dungeonService.getDungeons();

    if (includeProgress) {
      List<String> completedDungeons = await dungeonService.getCompletedDungeons();
      dungeons.forEach((d) => d.completed = completedDungeons.contains(d.pathId));
    }

    return dungeons;
  }
}