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
            name: 'Crash Site',
            duration: Duration(minutes: 40),
          ),
          MetaEventSegment(
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
            name: 'Night',
            duration: Duration(minutes: 25),
          ),
          MetaEventSegment(
            name: 'Night Bosses',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
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
            name: 'Pillars',
            duration: Duration(minutes: 75),
          ),
          MetaEventSegment(
            name: 'Challenges',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            name: 'Octovine',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
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
            name: 'Help the Outposts',
            duration: Duration(minutes: 95),
          ),
          MetaEventSegment(
            name: 'Prep',
            duration: Duration(minutes: 5),
          ),
          MetaEventSegment(
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
            name: 'New Loamhurst',
            duration: Duration(minutes: 45),
          ),
          MetaEventSegment(
            name: "Noran's Homestead",
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            name: "Saidra's Haven",
            duration: Duration(minutes: 45),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'ley-line',
        name: 'Ley-Line Anomaly',
        region: 'Maguuma',
        offset: Duration(minutes: 80),
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 100),
          ),
          MetaEventSegment(
            name: 'Timberline Falls',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 100),
          ),
          MetaEventSegment(
            name: 'Iron Marches',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 100),
          ),
          MetaEventSegment(
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
            name: 'Rounds 1 to 3',
            duration: Duration(minutes: 16),
          ),
          MetaEventSegment(
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
            name: 'Doppelganger',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 75),
          ),
          MetaEventSegment(
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
            name: 'Junundu Rising',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 10),
          ),
          MetaEventSegment(
            name: 'Maws of Torment',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 10),
          ),
          MetaEventSegment(
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
            name: 'Forged with Fire',
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
            name: "Serpents' Ire",
            duration: Duration(minutes: 30),
          ),
          MetaEventSegment(
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
            name: 'Escorts',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
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
            name: 'Thunderhead Keep',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 40),
          ),
          MetaEventSegment(
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
            name: 'Effigy',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 13),
          ),
          MetaEventSegment(
            name: 'Doomlore Shrine',
            duration: Duration(minutes: 22),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 5),
          ),
          MetaEventSegment(
            name: 'Ooze Pits',
            duration: Duration(minutes: 20),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            name: 'Metal Concert',
            duration: Duration(minutes: 15),
          ),
        ]
      ),
      MetaEventSequence(
        id: 'bjora',
        name: 'Bjora Marches',
        region: 'Icebrood',
        offset: Duration(minutes: 5),
        segments: [
          MetaEventSegment(
            name: 'Icebrood Champions',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 85),
          ),
          MetaEventSegment(
            name: 'Raven Shrines',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            name: 'Shards and Construct',
            duration: Duration(minutes: 5),
          ),
        ]
      ),
    ];
  }
}