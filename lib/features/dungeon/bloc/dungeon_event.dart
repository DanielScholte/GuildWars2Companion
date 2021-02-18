import 'package:meta/meta.dart';

@immutable
abstract class DungeonEvent {}

class LoadDungeonsEvent extends DungeonEvent {
  final bool includeProgress;

  LoadDungeonsEvent(this.includeProgress);
}