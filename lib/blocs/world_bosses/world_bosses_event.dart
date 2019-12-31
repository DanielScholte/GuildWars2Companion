import 'package:meta/meta.dart';

@immutable
abstract class WorldBossesEvent {}

class LoadWorldbossesEvent extends WorldBossesEvent {
  final bool showLoading;

  LoadWorldbossesEvent(this.showLoading);
}