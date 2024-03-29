
import 'package:flutter_test/flutter_test.dart';
import 'package:guildwars2_companion/features/event/models/event_segment.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/features/meta_event/repositories/event.dart';
import 'package:mockito/mockito.dart';

import 'mocks/services.dart';

main() {
  group('Event Timers', () {
    test('Meta requested', () async {
      final eventService = MockEventService();

      when(eventService.getMetaEvents())
        .thenAnswer((_) async => [
          MetaEventSequence(
            id: 'test',
            name: 'Test Meta Event',
            region: 'test',
            segments: [
              MetaEventSegment(
                duration: Duration(hours: 1),
                id: 'test_event',
                name: 'Test Event'
              ),
              MetaEventSegment(
                duration: Duration(hours: 1),
                id: 'test_event_2',
                name: 'Test Event2'
              ),
            ],
          ),
          MetaEventSequence(
            id: 'test2',
            name: 'Test Meta Event2',
            region: 'test',
            segments: [
              MetaEventSegment(
                duration: Duration(hours: 1),
                id: 'test_2_event',
                name: 'Test Event'
              ),
              MetaEventSegment(
                duration: Duration(hours: 1),
                id: 'test_2_event_2',
                name: 'Test Event2'
              ),
            ],
          ),
        ]);

      final eventRepository = MetaEventRepository(
        eventService: eventService
      );

      final metaEventSequences = await eventRepository.getMetaEvents();

      expect(metaEventSequences, hasLength(2));

      for (MetaEventSequence sequence in metaEventSequences) {
        expect(sequence.segments, hasLength(2));
        
        for (MetaEventSegment segment in sequence.segments) {
          expect(segment.times, hasLength(12));
          expect(segment.time, isNotNull);
        }
      }
    });

    test('Removes offset times', () async {
      final eventService = MockEventService();

      when(eventService.getMetaEvents())
        .thenAnswer((_) async => [
          MetaEventSequence(
            id: 'test',
            name: 'Test Meta Event',
            region: 'test',
            offset: Duration(hours: 3),
            segments: [
              MetaEventSegment(
                duration: Duration(hours: 1),
                id: 'test_event',
                name: 'Test Event'
              ),
            ],
          ),
        ]);

      final eventRepository = MetaEventRepository(
        eventService: eventService
      );

      final metaEventSequences = await eventRepository.getMetaEvents();

      expect(metaEventSequences, hasLength(1));
      expect(metaEventSequences.first.segments, hasLength(1));
      expect(metaEventSequences.first.segments.first.times, hasLength(24));
      expect(metaEventSequences.first.segments.first.time, isNotNull);
    });
  });
}