import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WorldBossesState {}
  
class LoadingWorldbossesState extends WorldBossesState {}

class LoadedWorldbossesState extends WorldBossesState {
  final List<WorldBoss> worldBosses;
  final bool includeProgress;

  LoadedWorldbossesState(this.worldBosses, this.includeProgress);
}

class ErrorWorldbossesState extends WorldBossesState {
  final bool includeProgress;

  ErrorWorldbossesState(this.includeProgress);
}