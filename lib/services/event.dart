import 'package:guildwars2_companion/models/other/meta_event.dart';

class EventService {
  List<MetaEventSequence> getMetaEvents() {
    return [
      MetaEventSequence(
        id: 'dry_top',
        name: 'Dry Top',
        region: 'Tyria',
        segments: [
          MetaEventSegment(
            id: 'dry_top_crash',
            name: 'Crash Site',
            duration: Duration(minutes: 40),
          ),
          MetaEventSegment(
            id: 'dry_top_sandstorm',
            name: 'Sandstorm',
            duration: Duration(minutes: 20),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'verdant',
        name: 'Verdant Brink',
        region: 'Maguuma',
        offset: Duration(minutes: 15),
        segments: [
          MetaEventSegment(
            id: 'verdant_night',
            name: 'Night',
            duration: Duration(minutes: 25),
          ),
          MetaEventSegment(
            id: 'verdant_night_bosses',
            name: 'Night Bosses',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            id: 'verdant_day',
            name: 'Daytime',
            duration: Duration(minutes: 75),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'auric',
        name: 'Auric Basin',
        region: 'Maguuma',
        offset: Duration(minutes: 30),
        segments: [
          MetaEventSegment(
            id: 'auric_pylons',
            name: 'Pylons',
            duration: Duration(minutes: 75),
          ),
          MetaEventSegment(
            id: 'auric_challenges',
            name: 'Challenges',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'auric_octovine',
            name: 'Octovine',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            id: 'auric_reset',
            name: 'Reset',
            duration: Duration(minutes: 10),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'tangled',
        name: 'Tangled Depths',
        region: 'Maguuma',
        offset: Duration(minutes: 70),
        segments: [
          MetaEventSegment(
            id: 'tangled_outposts',
            name: 'Help the Outposts',
            duration: Duration(minutes: 95),
          ),
          MetaEventSegment(
            id: 'tangled_prep',
            name: 'Prep',
            duration: Duration(minutes: 5),
          ),
          MetaEventSegment(
            id: 'tangled_chak',
            name: 'Chak Gerent',
            duration: Duration(minutes: 20),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'dragonstand',
        name: "Dragon's Stand",
        region: 'Maguuma',
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 90),
          ),
          MetaEventSegment(
            id: 'dragonstand_start',
            name: 'Start',
            duration: Duration(minutes: 30),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'lake',
        name: "Lake Doric",
        region: 'Maguuma',
        offset: Duration(minutes: 15),
        segments: [
          MetaEventSegment(
            id: 'lake_loamhurst',
            name: 'New Loamhurst',
            duration: Duration(minutes: 45),
          ),
          MetaEventSegment(
            id: 'lake_homestead',
            name: "Noran's Homestead",
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'lake_haven',
            name: "Saidra's Haven",
            duration: Duration(minutes: 45),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'ley_line',
        name: 'Ley-Line Anomaly',
        region: 'Maguuma',
        offset: Duration(minutes: 80),
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 100),
          ),
          MetaEventSegment(
            id: 'ley_line_timerline',
            name: 'Timberline Falls',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 100),
          ),
          MetaEventSegment(
            id: 'ley_line_iron',
            name: 'Iron Marches',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 100),
          ),
          MetaEventSegment(
            id: 'ley_line_gendarran',
            name: 'Gendarran Fields',
            duration: Duration(minutes: 20),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'oasis',
        name: 'Crystal Oasis',
        region: 'Desert',
        offset: Duration(minutes: 90),
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 95),
          ),
          MetaEventSegment(
            id: 'oasis_rounds',
            name: 'Rounds 1 to 3',
            duration: Duration(minutes: 16),
          ),
          MetaEventSegment(
            id: 'oasis_pinata',
            name: 'Pinata/Reset',
            duration: Duration(minutes: 9),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'desert_highlands',
        name: 'Desert Highlands',
        region: 'Desert',
        offset: Duration(minutes: 40),
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 100),
          ),
          MetaEventSegment(
            id: 'desert_highlands_buried',
            name: 'Buried Treasure',
            duration: Duration(minutes: 20),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'elon_riverlands',
        name: 'Elon Riverlands',
        region: 'Desert',
        offset: Duration(minutes: 5),
        segments: [
          MetaEventSegment(
            id: 'elon_riverlands_doppelganger',
            name: 'Doppelganger',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 75),
          ),
          MetaEventSegment(
            id: 'elon_riverlands_acension',
            name: 'The Path to Ascension: Augury Rock',
            duration: Duration(minutes: 25),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'desolation',
        name: 'The Desolation',
        region: 'Desert',
        offset: Duration(minutes: 10),
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 40),
          ),
          MetaEventSegment(
            id: 'desolation_junundu',
            name: 'Junundu Rising',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 10),
          ),
          MetaEventSegment(
            id: 'desolation_torment',
            name: 'Maws of Torment',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 10),
          ),
          MetaEventSegment(
            id: 'desolation_junundu',
            name: 'Junundu Rising',
            duration: Duration(minutes: 20),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'vabbi',
        name: 'Domain of Vabbi',
        region: 'Desert',
        segments: [
          MetaEventSegment(
            id: 'vabbi_forged',
            name: 'Forged with Fire',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'vabbi_serpent',
            name: "Serpents' Ire",
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            id: 'vabbi_forged',
            name: 'Forged with Fire',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'istan',
        name: 'Domain of Istan',
        region: 'Desert',
        offset: Duration(minutes: 15),
        segments: [
          MetaEventSegment(
            id: 'istan_palawadan',
            name: 'Palawadan',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 90),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'jahai',
        name: 'Jahai Bluffs',
        region: 'Desert',
        offset: Duration(minutes: 30),
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 90),
          ),
          MetaEventSegment(
            id: 'jahai_escort',
            name: 'Escorts',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'jahai_shatterer',
            name: 'Death-Branded Shatterer',
            duration: Duration(minutes: 15),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'thunderhead',
        name: 'Thunderhead Peaks',
        region: 'Desert',
        offset: Duration(minutes: 15),
        segments: [
          MetaEventSegment(
            id: 'thunderhead_keep',
            name: 'Thunderhead Keep',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 40),
          ),
          MetaEventSegment(
            id: 'thunderhead_oil',
            name: 'The Oil Floes',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 45),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'grothmar',
        name: 'Grothmar Valley',
        region: 'Icebrood',
        offset: Duration(minutes: 5),
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'grothmar_effigy',
            name: 'Effigy',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 13),
          ),
          MetaEventSegment(
            id: 'grothmar_doomlore',
            name: 'Doomlore Shrine',
            duration: Duration(minutes: 22),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 5),
          ),
          MetaEventSegment(
            id: 'grothmar_ooze',
            name: 'Ooze Pits',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            id: 'grothmar_metal',
            name: 'Metal Concert',
            duration: Duration(minutes: 15),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'bjora',
        name: 'Bjora Marches',
        region: 'Icebrood',
        segments: [
          MetaEventSegment(
            id: 'bjora_shards',
            name: 'Shards and Construct',
            duration: Duration(minutes: 5),
          ),
          MetaEventSegment(
            id: 'bjora_icebrood',
            name: 'Icebrood Champions',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 45),
          ),
          MetaEventSegment(
            id: 'bjora_drakkar',
            name: 'Drakkar and Spirits of the Wild',
            duration: Duration(minutes: 35),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 5),
          ),
          MetaEventSegment(
            id: 'bjora_shrines',
            name: 'Raven Shrines',
            duration: Duration(minutes: 15),
          ),
        ]
      ),
    ];
  }
}