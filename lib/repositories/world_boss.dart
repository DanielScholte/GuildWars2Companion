import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/services/world_boss.dart';

class WorldBossRepository {

  final WorldBossService worldBossService;

  WorldBossRepository({
    @required this.worldBossService
  });

  Future<List<WorldBoss>> getWorldBosses(bool includeProgress) async {
    List<WorldBoss> worldBosses = worldBossService.getWorldBosses();

    DateTime now = DateTime.now().toUtc();

    List<String> completedWorldBosses;
    if (includeProgress) {
      completedWorldBosses = await worldBossService.getCompletedWorldBosses();
    }

    worldBosses.forEach((worldBoss) {
      List<DateTime> times = worldBoss.times
        .map((t) {
          List<int> timeParts = t.split(':').map((p) => int.parse(p)).toList();
          return DateTime.utc(
            now.year,
            now.month,
            now.day,
            timeParts[0],
            timeParts[1]
          );
        })
        .toList();
      DateTime next = times
        .firstWhere((t) => t.add(Duration(minutes: 15)).isAfter(now), orElse: () => times[0].add(Duration(days: 1)));
      worldBoss.dateTime = next;
      worldBoss.refreshTime = next.add(Duration(minutes: 15));
      if (includeProgress) {
        worldBoss.completed = completedWorldBosses.contains(worldBoss.id);
      }
    });
    worldBosses.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return worldBosses;
  }
}