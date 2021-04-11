part of 'event_bloc.dart';

@immutable
abstract class MetaEventState {}

class LoadingMetaEventsState extends MetaEventState {}

class LoadedMetaEventsState extends MetaEventState {
  final List<MetaEventSequence> events;

  LoadedMetaEventsState({
    this.events,
  });
}

class ErrorMetaEventsState extends MetaEventState {}
