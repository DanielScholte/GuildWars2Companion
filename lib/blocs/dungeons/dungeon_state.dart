import 'package:guildwars2_companion/models/other/dungeon.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DungeonState {}
  
class LoadingDungeonsState extends DungeonState {}

class LoadedDungeonsState extends DungeonState {
  final List<Dungeon> dungeons;

  LoadedDungeonsState(this.dungeons);
}