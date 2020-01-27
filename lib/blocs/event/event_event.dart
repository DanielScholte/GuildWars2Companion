part of 'event_bloc.dart';

@immutable
abstract class EventEvent {}

class LoadEventsEvent extends EventEvent {
  final String id;

  LoadEventsEvent({
    this.id,
  });
}