import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/dungeon/models/dungeon.dart';
import 'package:guildwars2_companion/features/dungeon/services/dungeon.dart';

class DungeonRepository {
  final DungeonService dungeonService;

  DungeonRepository({
    @required this.dungeonService
  });

  Future<List<Dungeon>> getDungeons(bool includeProgress) async {
    List<Dungeon> dungeons = dungeonService.getDungeons();

    if (includeProgress) {
      List<String> completedDungeons = await dungeonService.getCompletedDungeons();
      dungeons.forEach((d) {
        d.paths.forEach((p) => p.completed = completedDungeons.contains(p.id));
      });
    }

    return dungeons;
  }
}