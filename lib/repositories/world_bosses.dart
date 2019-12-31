import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';
import 'package:http/http.dart' as http;

class WorldBossesRepository {
  Future<List<String>> getCompletedWorldBosses() async {
    final response = await http.get(
      Urls.completedWorldBossesUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List worldBosses = json.decode(response.body);
      // return worldBosses;
      return worldBosses.map((a) => a.toString()).toList();
    } else {
      return [];
    }
  }

  List<WorldBoss> getWorldBosses() {
    return [
      WorldBoss(
        name: 'Admiral Taidha Covington',
        id: 'admiral_taidha_covington',
        location: 'Bloodtide Coast',
        color: Colors.brown,
        times: [
          '00:00',
          '03:00',
          '06:00',
          '09:00',
          '12:00',
          '15:00',
          '18:00',
          '21:00',
        ]
      ),
      WorldBoss(
        name: 'Claw of Jormag',
        id: 'claw_of_jormag',
        location: 'Frostgorge Sound',
        color: Colors.blue,
        times: [
          '02:30',
          '05:30',
          '08:30',
          '11:30',
          '14:30',
          '17:30',
          '20:30',
          '23:30',
        ]
      ),
      WorldBoss(
        name: 'Fire Elemental',
        id: 'fire_elemental',
        location: 'Metrica Province',
        color: Colors.deepOrange,
        times: [
          '00:45',
          '02:45',
          '04:45',
          '06:45',
          '08:45',
          '10:45',
          '12:45',
          '14:45',
          '16:45',
          '18:45',
          '20:45',
          '22:45',
        ]
      ),
      WorldBoss(
        name: 'Great Jungle Wurm',
        id: 'great_jungle_wurm',
        location: 'Caledon Forest',
        color: Colors.green,
        times: [
          '01:15',
          '03:15',
          '05:15',
          '07:15',
          '09:15',
          '11:15',
          '13:15',
          '15:15',
          '17:15',
          '19:15',
          '21:15',
          '23:15',
        ]
      ),
      WorldBoss(
        name: 'Inquest Golem Mark II',
        id: 'inquest_golem_mark_ii',
        location: 'Mount Maelstrom',
        color: Colors.blueGrey,
        times: [
          '02:00',
          '05:00',
          '08:00',
          '11:00',
          '14:00',
          '17:00',
          '20:00',
          '23:00',
        ]
      ),
      WorldBoss(
        name: 'Karka Queen',
        id: 'karka_queen',
        location: 'Southsun Cove',
        color: Colors.pink,
        times: [
          '02:00',
          '06:00',
          '10:30',
          '15:00',
          '18:00',
          '23:00',
        ]
      ),
      WorldBoss(
        name: 'Megadestroyer',
        id: 'megadestroyer',
        location: 'Mount Maelstrom',
        color: Colors.red,
        times: [
          '00:30',
          '03:30',
          '06:30',
          '09:30',
          '12:30',
          '15:30',
          '18:30',
          '21:30',
        ]
      ),
      WorldBoss(
        name: 'Modniir Ulgoth',
        id: 'modniir_ulgoth',
        location: 'Harathi Hinterlands',
        color: Colors.brown,
        times: [
          '01:30',
          '04:30',
          '07:30',
          '10:30',
          '13:30',
          '16:30',
          '19:30',
          '22:30',
        ]
      ),
      WorldBoss(
        name: 'Shadow Behemoth',
        id: 'shadow_behemoth',
        location: 'Queensdale',
        color: Colors.brown,
        times: [
          '01:45',
          '03:45',
          '05:45',
          '07:45',
          '09:45',
          '11:45',
          '13:45',
          '15:45',
          '17:45',
          '19:45',
          '21:45',
          '23:45',
        ]
      ),
      WorldBoss(
        name: 'Svanir Shaman Chief',
        id: 'svanir_shaman_chief',
        location: 'Wayfarer Foothills',
        color: Colors.lightBlue,
        times: [
          '00:15',
          '02:15',
          '04:15',
          '06:15',
          '08:15',
          '10:15',
          '12:15',
          '14:15',
          '16:15',
          '18:15',
          '20:15',
          '22:15',
        ]
      ),
      WorldBoss(
        name: 'Tequatl the Sunless',
        id: 'tequatl_the_sunless',
        location: 'Sparkfly Fen',
        color: Colors.green,
        times: [
          '00:00',
          '03:00',
          '07:00',
          '11:30',
          '16:00',
          '19:00',
        ]
      ),
      WorldBoss(
        name: 'The Shatterer',
        id: 'the_shatterer',
        location: 'Blazeridge Steppes',
        color: Colors.deepPurple,
        times: [
          '01:00',
          '04:00',
          '07:00',
          '10:00',
          '13:00',
          '16:00',
          '19:00',
          '22:00',
        ]
      ),
      WorldBoss(
        name: 'Triple Trouble Wurm',
        id: 'triple_trouble_wurm',
        location: 'Sparkfly Fen',
        color: Colors.green,
        times: [
          '01:00',
          '04:00',
          '08:00',
          '12:30',
          '17:00',
          '20:00',
        ]
      ),
    ];
  }
}