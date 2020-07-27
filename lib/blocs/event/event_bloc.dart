import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/models/other/meta_event.dart';
import 'package:guildwars2_companion/repositories/event.dart';
import 'package:meta/meta.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({
    @required this.eventRepository,
  }): super(LoadingEventsState());

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is LoadEventsEvent) {
      try {
        yield LoadingEventsState();

        yield LoadedEventsState(
          events: eventRepository.getMetaEvents(id: event.id)
        );
      } catch (_) {
        yield ErrorEventsState();
      }
    }
  }
}
