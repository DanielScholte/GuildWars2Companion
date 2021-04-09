import 'package:guildwars2_companion/core/utils/assets.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';

class EventService {
  List<MetaEventSequence> _metaEvents;

  Future<List<MetaEventSequence>> getMetaEvents() async {
    if (_metaEvents == null) {
      List metaEventData = await Assets.loadDataAsset(Assets.eventTimersMetaEvents);
      _metaEvents = metaEventData
        .map((r) => MetaEventSequence.fromJson(r))
        .toList();
    }
    
    return _metaEvents;
  }
}