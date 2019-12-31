import 'package:guildwars2_companion/models/other/world_boss.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WorldbossesState {}
  
class LoadingWorldbossesState extends WorldbossesState {}

class LoadedWorldbossesState extends WorldbossesState {
  final List<WorldBoss> worldBosses;

  LoadedWorldbossesState(this.worldBosses);
}