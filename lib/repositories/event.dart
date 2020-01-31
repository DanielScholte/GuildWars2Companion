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
      DateTime offset = DateTime.utc(now.year, now.month, now.day).subtract(event.offset);

      while(offset.day <= now.day && offset.month <= now.month) {
        event.segments.forEach((segment) {
          if (offset.day > now.day || offset.month > now.month) {
            return;
          }

          segment.times.add(offset);
          offset = offset.add(segment.duration);
        });
      }

      event.segments.forEach((segment) {
        if (segment.times.isEmpty) {
          return;
        }

        List<MetaEventSegment> duplicates = 
          event.segments.where((s) => s.name == segment.name && s != segment && s.duration.inMinutes == segment.duration.inMinutes).toList();

        if (duplicates.isNotEmpty) {
          duplicates.forEach((d) {
            segment.times.addAll(d.times);
            d.times = [];
          });

          segment.times.sort((a, b) => a.compareTo(b));
        }

        segment.time = segment.times
          .firstWhere((t) => t.add(segment.duration).isAfter(now), orElse: () => segment.times[0].add(Duration(days: 1)));
      });

      event.segments.removeWhere((s) => s.times.isEmpty || s.time == null);

      event.segments.sort((a, b) => a.time.compareTo(b.time));

      event.segments.forEach((s) => s.times.removeWhere((t) => t.day != now.day));
    });

    return events;
  }
}