import 'package:meta/meta.dart';

@immutable
abstract class WorldbossesEvent {}

class LoadWorldbossesEvent extends WorldbossesEvent {
  final bool showLoading;

  LoadWorldbossesEvent(this.showLoading);
}