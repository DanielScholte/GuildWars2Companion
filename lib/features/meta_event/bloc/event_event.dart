part of 'event_bloc.dart';

@immutable
abstract class MetaEventEvent {}

class LoadMetaEventsEvent extends MetaEventEvent {
  final String id;

  LoadMetaEventsEvent({
    this.id,
  });
}