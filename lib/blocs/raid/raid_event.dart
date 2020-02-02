part of 'raid_bloc.dart';

@immutable
abstract class RaidEvent {}

class LoadRaidsEvent extends RaidEvent {
  final bool includeProgress;

  LoadRaidsEvent(this.includeProgress);
}