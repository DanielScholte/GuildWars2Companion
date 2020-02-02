import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WorldBossState {}
  
class LoadingWorldbossesState extends WorldBossState {}

class LoadedWorldbossesState extends WorldBossState {
  final List<WorldBoss> worldBosses;
  final bool includeProgress;

  LoadedWorldbossesState(this.worldBosses, this.includeProgress);
}

class ErrorWorldbossesState extends WorldBossState {
  final bool includeProgress;

  ErrorWorldbossesState(this.includeProgress);
}