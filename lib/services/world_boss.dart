import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import '../models/other/world_boss.dart';
import '../utils/urls.dart';

class WorldBossService {

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

  List<WorldBoss> getWorldBosses() {
    return [
      WorldBoss(
        name: 'Admiral Taidha Covington',
        id: 'admiral_taidha_covington',
        location: 'Bloodtide Coast',
        waypoint: 'Laughing Gull Waypoint',
        level: 50,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Claw of Jormag',
        id: 'claw_of_jormag',
        location: 'Frostgorge Sound',
        waypoint: 'Earthshake Waypoint',
        level: 80,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Fire Elemental',
        id: 'fire_elemental',
        location: 'Metrica Province',
        waypoint: 'Muridian Waypoint',
        level: 15,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Great Jungle Wurm',
        id: 'great_jungle_wurm',
        location: 'Caledon Forest',
        waypoint: 'Twilight Arbor Waypoint',
        level: 15,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Inquest Golem Mark II',
        id: 'inquest_golem_mark_ii',
        location: 'Mount Maelstrom',
        waypoint: 'Old Sledge Site Waypoint',
        level: 68,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Karka Queen',
        id: 'karka_queen',
        location: 'Southsun Cove',
        waypoint: 'Camp Karka Waypoint',
        level: 80,
        color: Colors.pink,
      ),
      WorldBoss(
        name: 'Megadestroyer',
        id: 'megadestroyer',
        location: 'Mount Maelstrom',
        waypoint: "Maelstrom's Waypoint",
        level: 66,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Modniir Ulgoth',
        id: 'modniir_ulgoth',
        location: 'Harathi Hinterlands',
        waypoint: 'Cloven Hoof Waypoint',
        level: 43,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Shadow Behemoth',
        id: 'shadow_behemoth',
        location: 'Queensdale',
        waypoint: 'Swamplost Haven Waypoint',
        level: 15,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Svanir Shaman Chief',
        id: 'svanir_shaman_chief',
        location: 'Wayfarer Foothills',
        waypoint: "Krennak's Homestead Waypoint",
        level: 10,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Tequatl the Sunless',
        id: 'tequatl_the_sunless',
        location: 'Sparkfly Fen',
        waypoint: 'Splintered Coast Waypoint',
        level: 65,
        color: Colors.pink,
      ),
      WorldBoss(
        name: 'The Shatterer',
        id: 'the_shatterer',
        location: 'Blazeridge Steppes',
        waypoint: 'Lowland Burns Waypoint',
        level: 50,
        color: Colors.green,
      ),
      WorldBoss(
        name: 'Triple Trouble Wurm',
        id: 'triple_trouble_wurm',
        location: 'Bloodtide Coast',
        waypoint: 'Firthside Vigil Waypoint',
        level: 55,
        color: Colors.pink,
      ),
    ];
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
