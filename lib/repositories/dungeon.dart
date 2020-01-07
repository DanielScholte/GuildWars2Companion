import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guildwars2_companion/models/other/dungeon.dart';
import 'package:guildwars2_companion/utils/token.dart';
import 'package:guildwars2_companion/utils/urls.dart';

import 'package:http/http.dart' as http;

class DungeonRepository {
  Future<List<String>> getCompletedDungeons() async {
    final response = await http.get(
      Urls.completedDungeonsUrl,
      headers: {
        'Authorization': 'Bearer ${await TokenUtil.getToken()}',
      }
    );

    if (response.statusCode == 200) {
      List dungeons = json.decode(response.body);
      return dungeons.map((a) => a.toString()).toList();
    } else {
      return [];
    }
  }

  List<Dungeon> getDungeons() {
    return [
      Dungeon(
        id: 'ascalonian_catacombs',
        name: 'Ascalonian Catacombs',
        color: Colors.lightBlue,
        level: 30,
        coin: 0,
        pathId: 'ac_story',
        pathName: 'Story'
      ),
      Dungeon(
        id: 'ascalonian_catacombs',
        name: 'Ascalonian Catacombs',
        color: Colors.lightBlue,
        level: 35,
        coin: 5000,
        pathId: 'hodgins',
        pathName: 'Path 1 - Hodgins'
      ),
      Dungeon(
        id: 'ascalonian_catacombs',
        name: 'Ascalonian Catacombs',
        color: Colors.lightBlue,
        level: 35,
        coin: 5000,
        pathId: 'detha',
        pathName: 'Path 2 - Detha'
      ),
      Dungeon(
        id: 'ascalonian_catacombs',
        name: 'Ascalonian Catacombs',
        color: Colors.lightBlue,
        level: 35,
        coin: 5000,
        pathId: 'tzark',
        pathName: 'Path 3 - Tzark'
      ),
      Dungeon(
        id: 'caudecus_manor',
        name: "Caudecus's Manor",
        color: Colors.green,
        level: 40,
        coin: 0,
        pathId: 'cm_story',
        pathName: 'Story'
      ),
      Dungeon(
        id: 'caudecus_manor',
        name: "Caudecus's Manor",
        color: Colors.green,
        level: 45,
        coin: 3500,
        pathId: 'asura',
        pathName: 'Path 1 - Asura'
      ),
      Dungeon(
        id: 'caudecus_manor',
        name: "Caudecus's Manor",
        color: Colors.green,
        level: 45,
        coin: 3500,
        pathId: 'seraph',
        pathName: 'Path 2 - Seraph'
      ),
      Dungeon(
        id: 'caudecus_manor',
        name: "Caudecus's Manor",
        color: Colors.green,
        level: 45,
        coin: 3500,
        pathId: 'butler',
        pathName: 'Path 3 - Butler'
      ),
      Dungeon(
        id: 'twilight_arbor',
        name: "Twilight Arbor",
        color: Colors.lightGreen,
        level: 50,
        coin: 0,
        pathId: 'ta_story',
        pathName: 'Story'
      ),
      Dungeon(
        id: 'twilight_arbor',
        name: "Twilight Arbor",
        color: Colors.lightGreen,
        level: 55,
        coin: 3500,
        pathId: 'leurent',
        pathName: 'Path 1 - Leurent (Up)'
      ),
      Dungeon(
        id: 'twilight_arbor',
        name: "Twilight Arbor",
        color: Colors.lightGreen,
        level: 55,
        coin: 3500,
        pathId: 'vevina',
        pathName: 'Path 3 - Vevina (Forward)'
      ),
      Dungeon(
        id: 'twilight_arbor',
        name: "Twilight Arbor",
        color: Colors.lightGreen,
        level: 80,
        coin: 6600,
        pathId: 'aetherpath',
        pathName: 'Path 4 - Aetherpath'
      ),
      Dungeon(
        id: 'sorrows_embrace',
        name: "Sorrow's Embrace",
        color: Colors.deepOrange,
        level: 60,
        coin: 0,
        pathId: 'se_story',
        pathName: 'Story'
      ),
      Dungeon(
        id: 'sorrows_embrace',
        name: "Sorrow's Embrace",
        color: Colors.deepOrange,
        level: 65,
        coin: 3500,
        pathId: 'fergg',
        pathName: 'Path 1 - Fergg'
      ),
      Dungeon(
        id: 'sorrows_embrace',
        name: "Sorrow's Embrace",
        color: Colors.deepOrange,
        level: 65,
        coin: 3500,
        pathId: 'rasalov',
        pathName: 'Path 2 - Rasolov'
      ),
      Dungeon(
        id: 'sorrows_embrace',
        name: "Sorrow's Embrace",
        color: Colors.deepOrange,
        level: 65,
        coin: 3500,
        pathId: 'koptev',
        pathName: 'Path 3 - Koptev'
      ),
      Dungeon(
        id: 'citadel_of_flame',
        name: "Citadel of Flame",
        color: Colors.red,
        level: 70,
        coin: 0,
        pathId: 'cof_story',
        pathName: 'Story'
      ),
      Dungeon(
        id: 'citadel_of_flame',
        name: "Citadel of Flame",
        color: Colors.red,
        level: 75,
        coin: 3500,
        pathId: 'ferrah',
        pathName: 'Path 1 - Ferrah'
      ),
      Dungeon(
        id: 'citadel_of_flame',
        name: "Citadel of Flame",
        color: Colors.red,
        level: 75,
        coin: 3500,
        pathId: 'magg',
        pathName: 'Path 2 - Magg'
      ),
      Dungeon(
        id: 'citadel_of_flame',
        name: "Citadel of Flame",
        color: Colors.red,
        level: 75,
        coin: 3500,
        pathId: 'rhiannon',
        pathName: 'Path 3 - Rhiannon'
      ),
      Dungeon(
        id: 'honor_of_the_waves',
        name: "Honor of the Waves",
        color: Colors.blue,
        level: 76,
        coin: 0,
        pathId: 'hotw_story',
        pathName: 'Story'
      ),
      Dungeon(
        id: 'honor_of_the_waves',
        name: "Honor of the Waves",
        color: Colors.blue,
        level: 80,
        coin: 3500,
        pathId: 'butcher',
        pathName: 'Path 1 - Butcher'
      ),
      Dungeon(
        id: 'honor_of_the_waves',
        name: "Honor of the Waves",
        color: Colors.blue,
        level: 80,
        coin: 3500,
        pathId: 'plunderer',
        pathName: 'Path 2 - Plunderer'
      ),
      Dungeon(
        id: 'honor_of_the_waves',
        name: "Honor of the Waves",
        color: Colors.blue,
        level: 80,
        coin: 3500,
        pathId: 'zealot',
        pathName: 'Path 3 - Zealot'
      ),
      Dungeon(
        id: 'crucible_of_eternity',
        name: "Crucible of Eternity",
        color: Colors.deepPurple,
        level: 78,
        coin: 0,
        pathId: 'coe_story',
        pathName: 'Story'
      ),
      Dungeon(
        id: 'crucible_of_eternity',
        name: "Crucible of Eternity",
        color: Colors.deepPurple,
        level: 80,
        coin: 3500,
        pathId: 'submarine',
        pathName: 'Path 1 - Submarine'
      ),
      Dungeon(
        id: 'crucible_of_eternity',
        name: "Crucible of Eternity",
        color: Colors.deepPurple,
        level: 80,
        coin: 3500,
        pathId: 'teleporter',
        pathName: 'Path 2 - Teleporter'
      ),
      Dungeon(
        id: 'crucible_of_eternity',
        name: "Crucible of Eternity",
        color: Colors.deepPurple,
        level: 80,
        coin: 3500,
        pathId: 'front_door',
        pathName: 'Path 3 - Front door'
      ),
      Dungeon(
        id: 'ruined_city_of_arah',
        name: "The Ruined City of Arah",
        color: Color(0xFF604F3B),
        level: 80,
        coin: 0,
        pathId: 'arah_story',
        pathName: 'Story'
      ),
      Dungeon(
        id: 'ruined_city_of_arah',
        name: "The Ruined City of Arah",
        color: Color(0xFF604F3B),
        level: 80,
        coin: 10000,
        pathId: 'jotun',
        pathName: 'Path 1 - Jotun'
      ),
      Dungeon(
        id: 'ruined_city_of_arah',
        name: "The Ruined City of Arah",
        color: Color(0xFF604F3B),
        level: 80,
        coin: 10500,
        pathId: 'mursaat',
        pathName: 'Path 2 - Mursaat'
      ),
      Dungeon(
        id: 'ruined_city_of_arah',
        name: "The Ruined City of Arah",
        color: Color(0xFF604F3B),
        level: 80,
        coin: 5000,
        pathId: 'forgotten',
        pathName: 'Path 3 - Forgotten'
      ),
      Dungeon(
        id: 'ruined_city_of_arah',
        name: "The Ruined City of Arah",
        color: Color(0xFF604F3B),
        level: 80,
        coin: 10000,
        pathId: 'seer',
        pathName: 'Path 4 - Seer'
      ),
    ];
  }
}