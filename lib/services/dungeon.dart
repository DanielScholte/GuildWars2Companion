import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/other/dungeon.dart';
import '../utils/dio.dart';
import '../utils/urls.dart';

class DungeonService {

  Dio _dio;

  DungeonService() {
    _dio = DioUtil.getDioInstance();
  }

  Future<List<String>> getCompletedDungeons() async {
    final response = await _dio.get(Urls.completedDungeonsUrl);

    if (response.statusCode == 200) {
      List dungeons = response.data;
      return dungeons.map((a) => a.toString()).toList();
    }

    throw Exception();
  }

  List<Dungeon> getDungeons() {
    return [
      Dungeon(
        id: 'ascalonian_catacombs',
        name: 'Ascalonian Catacombs',
        location: 'Plains of Ashford',
        color: Colors.lightBlue,
        paths: [
          DungeonPath(
            id: 'ac_story',
            name: 'Story',
            level: 30,
            coin: 0,
          ),
          DungeonPath(
            id: 'hodgins',
            name: 'Path 1 - Hodgins',
            level: 35,
            coin: 5000,
          ),
          DungeonPath(
            id: 'detha',
            name: 'Path 2 - Detha',
            level: 35,
            coin: 5000,
          ),
          DungeonPath(
            id: 'tzark',
            name: 'Path 3 - Tzark',
            level: 35,
            coin: 5000,
          ),
        ],
      ),
      Dungeon(
        id: 'caudecus_manor',
        name: "Caudecus's Manor",
        location: 'Queensdale',
        color: Colors.green,
        paths: [
          DungeonPath(
            id: 'cm_story',
            name: 'Story',
            level: 40,
            coin: 0,
          ),
          DungeonPath(
            id: 'asura',
            name: 'Path 1 - Asura',
            level: 45,
            coin: 3500,
          ),
          DungeonPath(
            id: 'seraph',
            name: 'Path 2 - Seraph',
            level: 45,
            coin: 3500,
          ),
          DungeonPath(
            id: 'butler',
            name: 'Path 3 - Butler',
            level: 45,
            coin: 3500,
          ),
        ],
      ),
      Dungeon(
        id: 'twilight_arbor',
        name: "Twilight Arbor",
        location: 'Caledon Forest',
        color: Colors.lightGreen,
        paths: [
          DungeonPath(
            id: 'ta_story',
            name: 'Story',
            level: 50,
            coin: 0,
          ),
          DungeonPath(
            id: 'leurent',
            name: 'Path 1 - Leurent (Up)',
            level: 55,
            coin: 3500,
          ),
          DungeonPath(
            id: 'vevina',
            name: 'Path 3 - Vevina (Forward)',
            level: 55,
            coin: 3500,
          ),
          DungeonPath(
            id: 'aetherpath',
            name: 'Path 4 - Aetherpath',
            level: 80,
            coin: 6600,
          ),
        ],
      ),
      Dungeon(
        id: 'sorrows_embrace',
        name: "Sorrow's Embrace",
        location: 'Dredgehaunt Cliffs',
        color: Colors.deepOrange,
        paths: [
          DungeonPath(
            id: 'se_story',
            name: 'Story',
            level: 60,
            coin: 0,
          ),
          DungeonPath(
            id: 'fergg',
            name: 'Path 1 - Fergg',
            level: 65,
            coin: 3500,
          ),
          DungeonPath(
            id: 'rasalov',
            name: 'Path 2 - Rasolov',
            level: 65,
            coin: 3500,
          ),
          DungeonPath(
            id: 'koptev',
            name: 'Path 3 - Koptev',
            level: 65,
            coin: 3500,
          ),
        ],  
      ),
      Dungeon(
        id: 'citadel_of_flame',
        name: "Citadel of Flame",
        location: 'Fireheart Rise',
        color: Colors.red,
        paths: [
          DungeonPath(
            id: 'cof_story',
            name: 'Story',
            level: 70,
            coin: 0,
          ),
          DungeonPath(
            id: 'ferrah',
            name: 'Path 1 - Ferrah',
            level: 75,
            coin: 3500,
          ),
          DungeonPath(
            id: 'magg',
            name: 'Path 2 - Magg',
            level: 75,
            coin: 3500,
          ),
          DungeonPath(
            id: 'rhiannon',
            name: 'Path 3 - Rhiannon',
            level: 75,
            coin: 3500,
          ),
        ],
      ),
      Dungeon(
        id: 'honor_of_the_waves',
        name: "Honor of the Waves",
        location: 'Frostgorge Sound',
        color: Colors.blue,
        paths: [
          DungeonPath(
            id: 'hotw_story',
            name: 'Story',
            level: 76,
            coin: 0,
          ),
          DungeonPath(
            id: 'butcher',
            name: 'Path 1 - Butcher',
            level: 80,
            coin: 3500,
          ),
          DungeonPath(
            id: 'plunderer',
            name: 'Path 2 - Plunderer',
            level: 80,
            coin: 3500,
          ),
          DungeonPath(
            id: 'zealot',
            name: 'Path 3 - Zealot',
            level: 80,
            coin: 3500,
          ),
        ],
      ),
      Dungeon(
        id: 'crucible_of_eternity',
        name: "Crucible of Eternity",
        location: 'Mount Maelstrom',
        color: Colors.deepPurple,
        paths: [
          DungeonPath(
            id: 'coe_story',
            name: 'Story',
            level: 78,
            coin: 0,
          ),
          DungeonPath(
            id: 'submarine',
            name: 'Path 1 - Submarine',
            level: 80,
            coin: 3500,
          ),
          DungeonPath(
            id: 'teleporter',
            name: 'Path 2 - Teleporter',
            level: 80,
            coin: 3500,
          ),
          DungeonPath(
            id: 'front_door',
            name: 'Path 3 - Front door',
            level: 80,
            coin: 3500,
          ),
        ],
      ),
      Dungeon(
        id: 'ruined_city_of_arah',
        name: "The Ruined City of Arah",
        location: 'Cursed Shore',
        color: Color(0xFF604F3B),
        paths: [
          DungeonPath(
            id: 'arah_story',
            name: 'Story',
            level: 80,
            coin: 0,
          ),
          DungeonPath(
            id: 'jotun',
            name: 'Path 1 - Jotun',
            level: 80,
            coin: 10000,
          ),
          DungeonPath(
            id: 'mursaat',
            name: 'Path 2 - Mursaat',
            level: 80,
            coin: 10500,
          ),
          DungeonPath(
            id: 'forgotten',
            name: 'Path 3 - Forgotten',
            level: 80,
            coin: 5000,
          ),
          DungeonPath(
            id: 'seer',
            name: 'Path 4 - Seer',
            level: 80,
            coin: 10000,
          ),
        ],
      ),
    ];
  }
}
