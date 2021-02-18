import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:guildwars2_companion/features/raid/models/raid.dart';
import 'package:guildwars2_companion/utils/urls.dart';

class RaidService {
  Dio dio;

  RaidService({
    @required this.dio,
  });

  Future<List<String>> getCompletedRaids() async {
    final response = await dio.get(Urls.completedRaidsUrl);

    if (response.statusCode == 200) {
      List dungeons = response.data;
      return dungeons.map((a) => a.toString()).toList();
    }

    throw Exception();
  }

  List<Raid> getRaids() {
    return [
      Raid(
        id: 'spirit_vale',
        name: 'Spirit Vale',
        color: Colors.green,
        checkpoints: [
          RaidCheckpoint(
            id: 'vale_guardian',
            name: 'Vale Guardian',
          ),
          RaidCheckpoint(
            id: 'spirit_woods',
            name: 'Spirit Woods',
          ),
          RaidCheckpoint(
            id: 'gorseval',
            name: 'Gorseval the Multifarious',
          ),
          RaidCheckpoint(
            id: 'sabetha',
            name: 'Sabetha the Saboteur',
          ),
        ],
      ),
      Raid(
        id: 'salvation_pass',
        name: 'Salvation Pass',
        color: Colors.green,
        checkpoints: [
          RaidCheckpoint(
            id: 'slothasor',
            name: 'Slothasor',
          ),
          RaidCheckpoint(
            id: 'bandit_trio',
            name: 'Protect the caged prisoners',
          ),
          RaidCheckpoint(
            id: 'matthias',
            name: 'Matthias Gabrel',
          ),
        ],
      ),
      Raid(
        id: 'stronghold_of_the_faithful',
        name: 'Stronghold of the Faithful',
        color: Colors.green,
        checkpoints: [
          RaidCheckpoint(
            id: 'escort',
            hasIcon: false,
            name: "Siege the Stronghold",
          ),
          RaidCheckpoint(
            id: 'keep_construct',
            name: 'Keep Construct',
          ),
          RaidCheckpoint(
            id: 'twisted_castle',
            hasIcon: false,
            name: 'Twisted Castle',
          ),
          RaidCheckpoint(
            id: 'xera',
            name: 'Xera',
          ),
        ],
      ),
      Raid(
        id: 'bastion_of_the_penitent',
        name: 'Bastion of the Penitent',
        color: Colors.green,
        checkpoints: [
          RaidCheckpoint(
            id: 'cairn',
            name: "Cairn the Indomitable",
          ),
          RaidCheckpoint(
            id: 'mursaat_overseer',
            name: 'Mursaat Overseer',
          ),
          RaidCheckpoint(
            id: 'samarog',
            name: 'Samarog',
          ),
          RaidCheckpoint(
            id: 'deimos',
            name: 'Deimos',
          ),
        ],
      ),
      Raid(
        id: 'hall_of_chains',
        name: 'Hall of Chains',
        color: Color(0xFF80066E),
        checkpoints: [
          RaidCheckpoint(
            id: 'soulless_horror',
            name: "Soulless Horror",
          ),
          RaidCheckpoint(
            id: 'river_of_souls',
            name: 'River of Souls',
          ),
          RaidCheckpoint(
            id: 'statues_of_grenth',
            hasIcon: false,
            name: 'Statues of Grenth',
          ),
          RaidCheckpoint(
            id: 'voice_in_the_void',
            name: 'Dhuum',
          ),
        ],
      ),
      Raid(
        id: 'mythwright_gambit',
        name: 'Mythwright Gambit',
        color: Color(0xFF80066E),
        checkpoints: [
          RaidCheckpoint(
            id: 'conjured_amalgamate',
            name: "Conjured Amalgamate",
          ),
          RaidCheckpoint(
            id: 'twin_largos',
            name: 'Twin Largos',
          ),
          RaidCheckpoint(
            id: 'qadim',
            name: 'Qadim',
          ),
        ],
      ),
      Raid(
        id: 'the_key_of_ahdashim',
        name: 'The Key of Ahdashim',
        color: Color(0xFF80066E),
        checkpoints: [
          RaidCheckpoint(
            id: 'gate',
            hasIcon: false,
            name: "Front Gate",
          ),
          RaidCheckpoint(
            id: 'adina',
            name: 'Cardinal Adina',
          ),
          RaidCheckpoint(
            id: 'sabir',
            name: 'Cardinal Sabir',
          ),
          RaidCheckpoint(
            id: 'qadim_the_peerless',
            name: 'Qadim the Peerless',
          ),
        ],
      ),
    ];
  }
}