import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/features/world_boss/models/world_boss.dart';

class WorldBossService {
  List<WorldBoss> _worldBoss;
  List<MetaEventSequence> _worldBossSequences;
  Dio dio;

  WorldBossService({
    @required this.dio,
  });

  Future<List<String>> getCompletedWorldBosses() async {
    final response = await dio.get(Urls.completedWorldBossesUrl);

    if (response.statusCode == 200) {
      List worldBosses = response.data;
      return worldBosses.map((a) => a.toString()).toList();
    }

    throw Exception();
  }

  Future<List<WorldBoss>> getWorldBosses() async {
    if (_worldBoss == null) {
      List worldBossData = await Assets.loadDataAsset(Assets.worldBosses);
      _worldBoss = worldBossData
        .map((w) => WorldBoss.fromJson(w))
        .toList();
    }
    
    return _worldBoss;
  }

  Future<List<MetaEventSequence>> getWorldBossSequences() async {
    if (_worldBossSequences == null) {
      List worldBossSequenceData = await Assets.loadDataAsset(Assets.eventTimersWorldBosses);
      _worldBossSequences = worldBossSequenceData
        .map((w) => MetaEventSequence.fromJson(w))
        .toList();
    }
    
    return _worldBossSequences
      .map((m) => MetaEventSequence.copy(m))
      .toList();
  }
}
