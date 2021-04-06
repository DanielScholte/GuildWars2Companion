import 'package:flutter/widgets.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/features/world_boss/models/world_boss.dart';
import 'package:guildwars2_companion/features/world_boss/services/world_boss.dart';

class WorldBossRepository {

  final WorldBossService worldBossService;

  WorldBossRepository({
    @required this.worldBossService
  });

  Future<List<WorldBoss>> getWorldBosses(bool includeProgress) async {
    List<WorldBoss> worldBosses = worldBossService.getWorldBosses();

    List<String> completedWorldBosses;
    if (includeProgress) {
      completedWorldBosses = await worldBossService.getCompletedWorldBosses();
    }

    worldBosses.forEach((worldBoss) {
      worldBoss.completed =  includeProgress ? completedWorldBosses.contains(worldBoss.id) : false;
    });

    return worldBosses;
  }

  List<MetaEventSequence> getWorldBossSequences() => worldBossService.getWorldBossSequences();
}