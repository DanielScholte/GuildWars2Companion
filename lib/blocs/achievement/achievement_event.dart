import 'package:meta/meta.dart';

@immutable
abstract class AchievementEvent {}

class LoadAchievementsEvent extends AchievementEvent {
  final bool includeProgress;

  LoadAchievementsEvent({
    @required this.includeProgress
  });
}