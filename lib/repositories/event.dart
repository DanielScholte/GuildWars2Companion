import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/services/event.dart';

class EventRepository {

  final EventService eventService;

  EventRepository({
    this.eventService,
  });

  List<MetaEventSequence> getMetaEvents({
    String id
  }) {
    List<MetaEventSequence> events = eventService.getMetaEvents();

    events.forEach((event) {
      event.segments.forEach((segment) {
        segment.time = null;
        segment.times = [];
      });

      if (event.id != id) {
        return;
      }

      DateTime now = DateTime.now().toUtc();
      DateTime offset = DateTime.utc(now.year, now.month, now.day);

      while(offset.day == now.day) {
        event.segments.forEach((segment) {
          if (offset.day != now.day) {
            return;
          }

          segment.times.add(offset);
          offset = offset.add(segment.duration);
        });
      }

      event.segments.forEach((segment) {
        segment.time = segment.times
          .firstWhere((t) => t.add(segment.duration).isAfter(now), orElse: () => segment.times[0].add(Duration(days: 1)));
      });
    });

    return events;
  }
}