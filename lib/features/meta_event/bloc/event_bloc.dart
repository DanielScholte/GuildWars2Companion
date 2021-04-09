import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:guildwars2_companion/features/meta_event/models/meta_event.dart';
import 'package:guildwars2_companion/features/meta_event/repositories/event.dart';
import 'package:meta/meta.dart';

part 'event_event.dart';
part 'event_state.dart';

class MetaEventBloc extends Bloc<MetaEventEvent, MetaEventState> {
  final MetaEventRepository eventRepository;

  MetaEventBloc({
    @required this.eventRepository,
  }): super(LoadingMetaEventsState());

  @override
  Stream<MetaEventState> mapEventToState(
    MetaEventEvent event,
  ) async* {
    if (event is LoadMetaEventsEvent) {
      try {
        yield LoadingMetaEventsState();

        yield LoadedMetaEventsState(
          events: await eventRepository.getMetaEvents(id: event.id)
        );
      } catch (_) {
        yield ErrorMetaEventsState();
      }
    }
  }
}
