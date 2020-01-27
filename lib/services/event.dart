import 'package:guildwars2_companion/models/other/meta_event.dart';

class EventService {
  List<MetaEventSequence> getMetaEvents() {
    return [
      MetaEventSequence(
        id: 'jahai',
        name: 'Jahai Bluffs',
        region: 'Desert',
        segments: [
          MetaEventSegment(
            duration: Duration(minutes: 60),
          ),
          MetaEventSegment(
            name: 'Escorts',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            name: 'Death-Branded Shatterer',
            duration: Duration(minutes: 15),
          ),
          MetaEventSegment(
            duration: Duration(minutes: 30),
          ),
        ]
      )
    ];
  }
}