import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/features/event/models/event_segment.dart';
import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/core/utils/urls.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/features/world_boss/models/world_boss.dart';

class WorldBossService {
  List<WorldBoss> _worldBoss;
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

  List<MetaEventSequence> getWorldBossSequences() {
    return [
      MetaEventSequence(
        segments: [
          MetaEventSegment(
            id: 'admiral_taidha_covington',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'svanir_shaman_chief',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'megadestroyer',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'fire_elemental',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'the_shatterer',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'great_jungle_wurm',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'modniir_ulgoth',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'shadow_behemoth',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'inquest_golem_mark_ii',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'svanir_shaman_chief',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'claw_of_jormag',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'fire_elemental',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'admiral_taidha_covington',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'great_jungle_wurm',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'megadestroyer',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'shadow_behemoth',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'the_shatterer',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'svanir_shaman_chief',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'modniir_ulgoth',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'fire_elemental',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'inquest_golem_mark_ii',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'great_jungle_wurm',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'claw_of_jormag',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'shadow_behemoth',
            duration: Duration(minutes: 15),
          ),
        ]
      ),
      MetaEventSequence(
        segments: [
          MetaEventSegment(
            id: 'tequatl_the_sunless',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'triple_trouble_wurm',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'karka_queen',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'tequatl_the_sunless',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'triple_trouble_wurm',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 90),
          ),
          MetaEventSegment(
            id: 'karka_queen',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'tequatl_the_sunless',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'triple_trouble_wurm',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 120),
          ),
          MetaEventSegment(
            id: 'karka_queen',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'tequatl_the_sunless',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'triple_trouble_wurm',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 120),
          ),
          MetaEventSegment(
            id: 'karka_queen',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'tequatl_the_sunless',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'triple_trouble_wurm',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'karka_queen',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'tequatl_the_sunless',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'triple_trouble_wurm',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 150),
          ),
          MetaEventSegment(
            id: 'karka_queen',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'tequatl_the_sunless',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'triple_trouble_wurm',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
        ]
      ),
    ];
  }
}
