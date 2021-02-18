import 'package:guildwars2_companion/features/world_boss/models/world_boss.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WorldBossState {}
  
class LoadingWorldbossesState extends WorldBossState {}

class LoadedWorldbossesState extends WorldBossState {
  final List<WorldBoss> worldBosses;

  LoadedWorldbossesState(this.worldBosses);
}

class ErrorWorldbossesState extends WorldBossState {}