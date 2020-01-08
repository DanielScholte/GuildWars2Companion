import 'package:meta/meta.dart';

@immutable
abstract class AchievementEvent {}

class LoadAchievementsEvent extends AchievementEvent {}