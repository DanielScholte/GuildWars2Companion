part of 'event_bloc.dart';

@immutable
abstract class EventState {}

class LoadingEventsState extends EventState {}

class LoadedEventsState extends EventState {
  final List<MetaEventSequence> events;

  LoadedEventsState({
    this.events,
  });
}

class ErrorEventsState extends EventState {}
