import 'package:meta/meta.dart';

@immutable
abstract class DungeonEvent {}

class LoadDungeonsEvent extends DungeonEvent {}