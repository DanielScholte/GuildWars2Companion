part of 'world_boss_bloc.dart';

@immutable
abstract class WorldBossEvent {}

class LoadWorldbossesEvent extends WorldBossEvent {
  final bool showLoading;
  final bool includeProgress;

  LoadWorldbossesEvent(this.showLoading, this.includeProgress);
}