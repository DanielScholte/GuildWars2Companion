part of 'dungeon_bloc.dart';

@immutable
abstract class DungeonState {}
  
class LoadingDungeonsState extends DungeonState {}

class LoadedDungeonsState extends DungeonState {
  final List<Dungeon> dungeons;
  final bool includeProgress;

  LoadedDungeonsState(this.dungeons, this.includeProgress);
}

class ErrorDungeonsState extends DungeonState {
  final bool includeProgress;

  ErrorDungeonsState(this.includeProgress);
}