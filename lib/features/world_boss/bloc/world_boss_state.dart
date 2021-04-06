part of 'world_boss_bloc.dart';

@immutable
abstract class WorldBossState {}
  
class LoadingWorldbossesState extends WorldBossState {}

class LoadedWorldbossesState extends WorldBossState {
  final List<WorldBoss> worldBosses;

  LoadedWorldbossesState(this.worldBosses);
}

class ErrorWorldbossesState extends WorldBossState {}